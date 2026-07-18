import 'dart:convert';

import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataCacheManager {
  static const _agreementConditionsPrefix = 'cache_conditions_';
  static const _conditionAssetsPrefix = 'cache_assets_';

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
}
