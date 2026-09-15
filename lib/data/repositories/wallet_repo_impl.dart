import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/data/services/wallet_api_service.dart';
import 'package:adehun_mvp/data/services/websocket_service.dart';
import 'package:adehun_mvp/domain/models/wallet_code_response.dart';
import 'package:adehun_mvp/domain/models/wallet_data.dart';
import 'package:adehun_mvp/domain/models/withdrawal_response.dart';
import 'package:adehun_mvp/domain/wallet_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class WalletRepoImpl implements WalletRepository {
  final Ref ref;
  final WalletApiService _walletApiService;
  final WalletWebsocketService _walletWebsocketService;

  StreamController<WalletData>? _balances;
  final StreamController<Map<String, dynamic>> _withdrawals =
      StreamController<Map<String, dynamic>>.broadcast();
  StreamSubscription? _frames;
  StreamSubscription? _connection;
  WalletData? _last;
  bool _socketStarted = false;

  WalletRepoImpl(
    WalletApiService apiService,
    WalletWebsocketService websocketService, {
    required this.ref,
  }) : _walletApiService = apiService,
       _walletWebsocketService = websocketService;

  // ------------------------------------------------------------------ //
  //  HTTP                                                               //
  // ------------------------------------------------------------------ //

  @override
  Future<DataState<WalletCodeResponse>> fundWallet(
    double amount,
    String channel,
  ) async {
    try {
      final apiResponse = await _walletApiService.fundWallet({
        'amount': amount.toStringAsFixed(2),
        'channel': channel,
      }, const Uuid().v4());

      final statusCode = apiResponse.response.statusCode;
      if (statusCode == HttpStatus.ok || statusCode == HttpStatus.created) {
        return DataSuccess(apiResponse.data);
      }
      return DataFailed(const FundWalletError());
    } catch (err) {
      if (kDebugMode) log('fundWallet failed: ${err.runtimeType}');
      rethrow;
    }
  }

  @override
  Future<DataState<WalletData>> getWallet() async {
    try {
      final apiResponse = await _walletApiService.getWallet();
      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }
      return DataFailed(const GetWalletError());
    } catch (err) {
      if (kDebugMode) log('getWallet failed: ${err.runtimeType}');
      return DataFailed(const GetWalletError());
    }
  }

  @override
  Future<DataState<WithdrawalResponse>> withdraw({
    required String amount,
    String? bankAccountId,
  }) async {
    try {
      final apiResponse = await _walletApiService.withdraw({
        'amount': amount,
        'bank_account_id': ?bankAccountId,
      }, const Uuid().v4());
      final status = apiResponse.response.statusCode;
      if (status == HttpStatus.ok || status == HttpStatus.accepted) {
        return DataSuccess(apiResponse.data);
      }
      return DataFailed(const WithdrawError());
    } catch (err) {
      if (kDebugMode) log('withdraw failed: ${err.runtimeType}');
      // Rethrown so the controller can read the API error code
      // (WITHDRAWALS_DISABLED, INSUFFICIENT_FUNDS, …).
      rethrow;
    }
  }

  @override
  Future<DataState<WithdrawalResponse>> getWithdrawal(String reference) async {
    try {
      final apiResponse = await _walletApiService.getWithdrawal(reference);
      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }
      return DataFailed(const WithdrawError());
    } catch (err) {
      if (kDebugMode) log('getWithdrawal failed: ${err.runtimeType}');
      return DataFailed(const WithdrawError());
    }
  }

  // ------------------------------------------------------------------ //
  //  Live balances                                                      //
  // ------------------------------------------------------------------ //

  @override
  Stream<WalletData> get walletData {
    _balances ??= StreamController<WalletData>.broadcast(
      onListen: () {
        // Late subscribers get the last known value immediately.
        if (_last != null) _balances!.add(_last!);
      },
    );
    _start();
    return _balances!.stream;
  }

  @override
  Stream<Map<String, dynamic>> get withdrawalEvents => _withdrawals.stream;

  @override
  Future<void> refresh() async {
    final result = await getWallet();
    if (result is DataSuccess && result.data != null) {
      _emit(result.data!);
    }
  }

  Future<void> _start() async {
    if (_socketStarted) return;
    _socketStarted = true;

    // HTTP first so the UI never waits on a socket that may not deliver.
    await refresh();

    _frames ??= _walletWebsocketService.walletDataStream.listen(_onFrame);
    _connection ??= _walletWebsocketService.connectionState.listen((up) {
      // Frames sent while we were away are gone; reconcile over HTTP.
      if (up) refresh();
    });

    try {
      final token = await ref.read(tokenStorageProvider).getAccessToken();
      if (token == null) return;
      _walletWebsocketService.connect(websocketUrl(walletWebsocketUrl, token));
    } catch (err) {
      if (kDebugMode) log('wallet socket connect failed: ${err.runtimeType}');
    }
  }

  void _onFrame(Map<String, dynamic> frame) {
    switch (frame['type']) {
      case 'WALLET_STATE':
      case 'WALLET_CREDITED':
        _emit(WalletData.fromJson(frame));
      case 'WITHDRAWAL_COMPLETED':
      case 'WITHDRAWAL_FAILED':
        // Partial frames: merge on top of the last state rather than parsing
        // as a full WalletData, which would zero missing balances.
        final base = _last;
        if (base != null) _emit(base.merge(frame));
        _withdrawals.add(frame);
      default:
        // Unknown type: the docs say refetch.
        refresh();
    }
  }

  void _emit(WalletData data) {
    _last = data;
    _balances?.add(data);
  }

  @override
  void closeWalletSocket() {
    _frames?.cancel();
    _frames = null;
    _connection?.cancel();
    _connection = null;
    _walletWebsocketService.close();
    _balances?.close();
    _balances = null;
    _last = null;
    _socketStarted = false;
  }
}
