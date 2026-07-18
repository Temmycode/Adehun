import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AssetState {
  final Map<String, List<AssetsResponse>>
  assets; // {"condition_id": [...] // list of assets}
  final bool isAdding;

  const AssetState({this.assets = const {}, this.isAdding = false});

  AssetState copyWith({
    Map<String, List<AssetsResponse>>? assets,
    bool? isAdding,
  }) {
    return AssetState(
      assets: assets ?? this.assets,
      isAdding: isAdding ?? this.isAdding,
    );
  }
}
