import 'dart:convert';

import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/domain/models/dispute_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataCacheManager {
  static const _agreementConditionsPrefix = 'cache_conditions_';
  static const _conditionAssetsPrefix = 'cache_assets_';
  static const _agreementDisputesPrefix = 'cache_disputes_';

  final SharedPreferences _prefs;

  LocalDataCacheManager(this._prefs);

  List<ConditionResponse>? getCachedConditions(String agreementId) {
    final raw = _prefs.getString('$_agreementConditionsPrefix$agreementId');
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .cast<Map<String, dynamic>>()
          .map(ConditionResponse.fromJson)
          .toList();
    } catch (_) {
      _prefs.remove('$_agreementConditionsPrefix$agreementId');
      return null;
    }
  }

  Future<bool> cacheConditions(
    String agreementId,
    List<ConditionResponse> conditions,
  ) {
    final raw = jsonEncode(conditions.map((c) => c.toJson()).toList());
    return _prefs.setString('$_agreementConditionsPrefix$agreementId', raw);
  }

  Future<bool> clearCachedConditions(String agreementId) {
    return _prefs.remove('$_agreementConditionsPrefix$agreementId');
  }

  List<AssetsResponse>? getCachedAssets(String conditionId) {
    final raw = _prefs.getString('$_conditionAssetsPrefix$conditionId');
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .cast<Map<String, dynamic>>()
          .map(AssetsResponse.fromJson)
          .toList();
    } catch (_) {
      _prefs.remove('$_conditionAssetsPrefix$conditionId');
      return null;
    }
  }

  Future<bool> cacheAssets(String conditionId, List<AssetsResponse> assets) {
    final raw = jsonEncode(assets.map((a) => a.toJson()).toList());
    return _prefs.setString('$_conditionAssetsPrefix$conditionId', raw);
  }

  Future<bool> clearCachedAssets(String conditionId) {
    return _prefs.remove('$_conditionAssetsPrefix$conditionId');
  }

  List<DisputeResponse>? getCachedDisputes(String agreementId) {
    final raw = _prefs.getString('$_agreementDisputesPrefix$agreementId');
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .cast<Map<String, dynamic>>()
          .map(DisputeResponse.fromJson)
          .toList();
    } catch (_) {
      _prefs.remove('$_agreementDisputesPrefix$agreementId');
      return null;
    }
  }

  Future<bool> cacheDisputes(
    String agreementId,
    List<DisputeResponse> disputes,
  ) {
    final raw = jsonEncode(disputes.map((d) => d.toJson()).toList());
    return _prefs.setString('$_agreementDisputesPrefix$agreementId', raw);
  }

  Future<bool> clearCachedDisputes(String agreementId) {
    return _prefs.remove('$_agreementDisputesPrefix$agreementId');
  }

  /// Clears all locally cached agreement conditions, assets and disputes.
  /// Returns true if all targeted keys were removed successfully.
  Future<bool> clearAll() async {
    final keys = _prefs.getKeys();
    var success = true;
    for (final key in keys) {
      if (key.startsWith(_agreementConditionsPrefix) ||
          key.startsWith(_conditionAssetsPrefix) ||
          key.startsWith(_agreementDisputesPrefix)) {
        final removed = await _prefs.remove(key);
        success = success && removed;
      }
    }
    return success;
  }
}
