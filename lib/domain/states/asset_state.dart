import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AssetState {
  final Map<String, List<AssetsResponse>>
  assets; // {"condition_id": [...] // list of assets}
  final bool isLoading;
  final bool isAdding;
  final String? errorMessage;

  const AssetState({
    this.assets = const {},
    this.isLoading = false,
    this.isAdding = false,
    this.errorMessage,
  });

  List<AssetsResponse> assetsFor(String conditionId) =>
      assets[conditionId] ?? const [];

  AssetState copyWith({
    Map<String, List<AssetsResponse>>? assets,
    bool? isLoading,
    bool? isAdding,
    String? Function()?
    errorMessage, // Function wrap allows passing explicit null
  }) {
    return AssetState(
      assets: assets ?? this.assets,
      isLoading: isLoading ?? this.isLoading,
      isAdding: isAdding ?? this.isAdding,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
