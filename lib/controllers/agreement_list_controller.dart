import 'dart:async';
import 'dart:developer';

import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/controllers/dispute_controller.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/data/services/websocket_service.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/states/agreement_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'agreement_list_controller.g.dart';

@Riverpod(keepAlive: true)
class AgreementListController extends _$AgreementListController {
  StreamSubscription<Map<String, dynamic>>? _subscription;
  StreamSubscription<bool>? _connection;

  @override
  Future<AgreementState> build() async {
    final websocketService = ref.watch(agreementWebsocketServiceProvider);
    ref.onDispose(_dispose);

    final token = await ref.read(tokenStorageProvider).getAccessToken();
    if (token != null) {
      _connectSocket(websocketService, token);
    }

    final dataState = await ref
        .read(agreementRepositoryProvider)
        .getAllUserAgreements();

    if (dataState is DataSuccess && dataState.data != null) {
      return AgreementState(agreements: dataState.data!);
    }

    return const AgreementState();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    try {
      final dataState = await ref
          .read(agreementRepositoryProvider)
          .getAllUserAgreements();

      if (dataState is DataSuccess && dataState.data != null) {
        state = AsyncData(AgreementState(agreements: dataState.data!));
        return;
      }
    } catch (err, stk) {
      log('Agreement refresh failed: $err', stackTrace: stk);
    }

    state = const AsyncData(AgreementState());
  }

  /// Silent refetch used on socket reconnect: no loading flicker.
  Future<void> _reconcile() async {
    try {
      final dataState = await ref
          .read(agreementRepositoryProvider)
          .getAllUserAgreements();
      if (dataState is DataSuccess && dataState.data != null) {
        final current = state.value ?? const AgreementState();
        state = AsyncData(current.copyWith(agreements: dataState.data));
      }
    } catch (err) {
      log('Agreement reconcile failed: $err');
    }
  }

  Future<void> getAgreement(String agreementId) async {
    final websocketService = ref.read(agreementWebsocketServiceProvider);

    if (!websocketService.isConnected) {
      final token = await ref.read(tokenStorageProvider).getAccessToken();
      if (token == null) return;
      _connectSocket(websocketService, token);
    }

    try {
      websocketService.send({
        'type': 'get_agreement',
        'agreement_id': agreementId,
      });
    } catch (err) {
      // Socket not up yet; the reconnect handler reconciles over HTTP.
      log('get_agreement not sent: $err');
    }
  }

  void _connectSocket(AgreementWebsocketService websocketService, String token) {
    _subscription ??= websocketService.agreementStream.listen(_handleMessage);
    _connection ??= websocketService.connectionState.listen((up) {
      if (up) _reconcile();
    });
    if (!websocketService.isConnected) {
      websocketService.connect(websocketUrl(agreementWebsocketUrl, token));
    }
  }

  void _handleMessage(Map<String, dynamic> message) {
    switch (message['type']) {
      case 'agreement':
        final payload = message['agreement'];
        if (payload is! Map<String, dynamic>) return;
        final agreement = AgreementResponse.fromJson(payload);
        final currentState = state.value ?? const AgreementState();
        state = AsyncData(_mergeAgreement(currentState, agreement));
      case 'dispute':
        // A dispute frame precedes the agreement frame; refresh the dispute
        // list so an open detail screen shows the new state.
        final agreementId = message['agreement_id'];
        if (agreementId is String) {
          ref.read(disputeControllerProvider.notifier).refresh(agreementId);
        }
      case 'error':
        log('agreement socket error: ${message['message']}');
      case 'connected':
        break;
      default:
        break;
    }
  }

  AgreementState _mergeAgreement(
    AgreementState currentState,
    AgreementResponse agreement,
  ) {
    final updatedAgreements = [
      agreement,
      ...currentState.agreements.where((item) => item.id != agreement.id),
    ];

    final updatedSelected = currentState.selectedAgreement?.id == agreement.id
        ? agreement
        : currentState.selectedAgreement;

    return currentState.copyWith(
      agreements: updatedAgreements,
      selectedAgreement: updatedSelected,
    );
  }

  void _dispose() {
    _subscription?.cancel();
    _subscription = null;
    _connection?.cancel();
    _connection = null;
    ref.read(agreementWebsocketServiceProvider).close();
  }
}
