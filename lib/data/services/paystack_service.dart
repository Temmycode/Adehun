import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:paystack_flutter_sdk/paystack_flutter_sdk.dart';

class PaystackService {
  PaystackService._internal();
  static final PaystackService instance = PaystackService._internal();

  final Paystack _paystack = Paystack();
  bool _initialized = false;

  Future<void> initialize(String publicKey) async {
    if (_initialized) return; // guard against calling this more than once
    try {
      final response = await _paystack.initialize(publicKey, true);
      _initialized = response;
      log(
        response
            ? "Successfully initialised the SDK"
            : "Unable to initialise the SDK",
      );
    } on PlatformException catch (e) {
      log(e.message ?? 'Unknown error initialising Paystack SDK');
    }
  }

  Future<String?> launch(String accessCode) async {
    if (!_initialized) {
      log("Paystack SDK not initialised yet");
      return null;
    }

    try {
      final response = await _paystack.launch(accessCode);
      if (response.status == "success") {
        return response.reference;
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      log(e.message ?? 'Unknown error launching Paystack checkout');
      return null;
    }
  }
}
