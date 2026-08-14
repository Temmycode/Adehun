import 'dart:async';
import 'dart:developer';

import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/states/agreement_state.dart';
import 'package:adehun_mvp/data/services/websocket_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'agreement_list_controller.g.dart';

@Riverpod(keepAlive: true)
class AgreementListController extends _$AgreementListController {
  bool _isConnected = false;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  @override
  Future<AgreementState> build() async {
    final websocketService = ref.watch(agreementWebsocketServiceProvider);
    ref.onDispose(_dispose);

    final token = await ref.read(tokenStorageProvider).getAccessToken();
    if (token != null) {
      await _connectSocket(websocketService, token);
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

  Future<void> getAgreement(String agreementId) async {
    final websocketService = ref.read(agreementWebsocketServiceProvider);

    if (!_isConnected) {
      final token = await ref.read(tokenStorageProvider).getAccessToken();
      if (token == null) return;
      await _connectSocket(websocketService, token);
    }

    try {
      websocketService.send({
        'type': 'get_agreement',
        'agreement_id': agreementId,
      });
    } catch (err, stk) {
      log('Failed to send get_agreement request: $err', stackTrace: stk);
    }
  }

  Future<void> _connectSocket(
    AgreementWebsocketService websocketService,
    String token,
  ) async {
    if (_isConnected) return;

    try {
      websocketService.connect(_buildWebsocketUrl(agreementWebsocketUrl, token));
      _isConnected = true;
      _subscription = websocketService.agreementStream.listen(
        _handleMessage,
        onError: (err, stk) {
          log('Agreement websocket error: $err', stackTrace: stk);
        },
        onDone: () {
          _isConnected = false;
        },
      );
    } catch (err, stk) {
      _isConnected = false;
      log('Agreement websocket connect failed: $err', stackTrace: stk);
    }
  }

  void _handleMessage(Map<String, dynamic> message) {
    final type = message['type'] as String?;
    if (type != 'agreement') return;

    final agreementPayload = message['agreement'];
    if (agreementPayload is! Map<String, dynamic>) return;

    final agreement = AgreementResponse.fromJson(agreementPayload);
    final currentState = state.value ?? const AgreementState();
    state = AsyncData(_mergeAgreement(currentState, agreement));
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

  String _buildWebsocketUrl(String path, String token) {
    final socketBase = baseUrl.replaceFirstMapped(
      RegExp(r'^https?://'),
      (match) => match.group(0) == 'https://' ? 'wss://' : 'ws://',
    );
    return '$socketBase$path?token=$token';
  }

  void _dispose() {
    _subscription?.cancel();
    ref.read(agreementWebsocketServiceProvider).close();
    _isConnected = false;
  }
}
