// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attention_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Derives the "Needs your attention" feed from data other providers already
/// hold. It makes no requests of its own, so it is only as fresh as the
/// agreement list, the pending invitations and whatever conditions have been
/// loaded for individual agreements.
///
/// Order is by urgency: invitations, agreements waiting for the user to agree,
/// escrow the user still has to fund, submitted conditions the user has to
/// review, then open disputes.

@ProviderFor(attentionItems)
final attentionItemsProvider = AttentionItemsProvider._();

/// Derives the "Needs your attention" feed from data other providers already
/// hold. It makes no requests of its own, so it is only as fresh as the
/// agreement list, the pending invitations and whatever conditions have been
/// loaded for individual agreements.
///
/// Order is by urgency: invitations, agreements waiting for the user to agree,
/// escrow the user still has to fund, submitted conditions the user has to
/// review, then open disputes.

final class AttentionItemsProvider
    extends
        $FunctionalProvider<
          List<AttentionItem>,
          List<AttentionItem>,
          List<AttentionItem>
        >
    with $Provider<List<AttentionItem>> {
  /// Derives the "Needs your attention" feed from data other providers already
  /// hold. It makes no requests of its own, so it is only as fresh as the
  /// agreement list, the pending invitations and whatever conditions have been
  /// loaded for individual agreements.
  ///
  /// Order is by urgency: invitations, agreements waiting for the user to agree,
  /// escrow the user still has to fund, submitted conditions the user has to
  /// review, then open disputes.
  AttentionItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attentionItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attentionItemsHash();

  @$internal
  @override
  $ProviderElement<List<AttentionItem>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<AttentionItem> create(Ref ref) {
    return attentionItems(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AttentionItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AttentionItem>>(value),
    );
  }
}

String _$attentionItemsHash() => r'e9107ae4d11619fbd445482aa76feae675a83459';
