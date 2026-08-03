import 'package:flutter/foundation.dart' show immutable;

@immutable
class FundWalletState {
  final bool isLoading;
  final String? error;

  const FundWalletState({this.isLoading = false, this.error});

  FundWalletState copyWith({
    bool? isLoading,
    String? Function()? error, // Function wrap allows passing explicit null
  }) {
    return FundWalletState(
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
    );
  }

  @override
  int get hashCode => Object.hashAll([isLoading, error]);

  @override
  bool operator ==(covariant FundWalletState other) {
    return isLoading == other.isLoading && error == other.error;
  }
}
