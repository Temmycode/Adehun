import 'dart:developer';
import 'dart:io';

import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/data/services/wallet_api_service.dart';
import 'package:adehun_mvp/data/services/websocket_service.dart';
import 'package:adehun_mvp/domain/models/wallet_code_response.dart';
import 'package:adehun_mvp/domain/models/wallet_data.dart';
import 'package:adehun_mvp/domain/wallet_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class WalletRepoImpl implements WalletRepository {
  final Ref ref;
  final WalletApiService _walletApiService;
  final WalletWebsocketService _walletWebsocketService;

  bool _isConnected = false;

  WalletRepoImpl(
    WalletApiService apiService,
    WalletWebsocketService websocketService, {
    required this.ref,
  }) : _walletApiService = apiService,
       _walletWebsocketService = websocketService;

  @override
  Future<DataState<WalletCodeResponse>> fundWallet(
    double amount,
    String channel,
  ) async {
    try {
      String idempotencyKey = Uuid().v4();
      final apiResponse = await _walletApiService.fundWallet({
        'amount': amount,
        'channel': channel,
      }, idempotencyKey);

      final statusCode = apiResponse.response.statusCode;

      // Initialising a payment creates a resource, so the API answers 201 —
      // matching only 200 turned every successful call into a FundWalletError.
      if (statusCode == HttpStatus.ok || statusCode == HttpStatus.created) {
        return DataSuccess(apiResponse.data);
      }

      if (kDebugMode) {
        log('fundWallet: unexpected status $statusCode');
      }

      return DataFailed(FundWalletError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  @override
  Stream<WalletData> get walletData {
    _initConnection();

    return _walletWebsocketService.walletDataStream.map(
      (json) => WalletData.fromJson(json),
    );
  }

  Future<void> _initConnection() async {
    if (_isConnected) return;

    try {
      final tokenStorage = ref.read(tokenStorageProvider);
      final token = await tokenStorage.getAccessToken();

      _walletWebsocketService.connect(
        'wss://adehun-api.onrender.com/wallet/ws?token=$token',
      );
      _isConnected = true;
    } catch (e) {
      // Handle token or connection errors here gracefully
      _isConnected = false;
    }
  }

  @override
  void closeWalletSocket() {
    _walletWebsocketService.close();
    _isConnected = false;
  }
}
