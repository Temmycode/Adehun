import 'package:flutter/material.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

/// Opens [builder] in the app's bottom sheet chrome: drag handle, rounded top,
/// safe area, and keyboard-aware bottom inset.
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  String? title,
  bool isDismissible = true,
  bool enableDrag = true,
  bool showHandle = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: context.colors.surface,
    barrierColor: context.colors.textPrimary.withValues(alpha: 0.45),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: AppBottomSheet(
        title: title,
        showHandle: showHandle,
        child: builder(sheetContext),
      ),
    ),
  );
}

/// The body of a bottom sheet. Sizes to its child; wrap long content in a
/// scroll view yourself.
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool showHandle;
  final EdgeInsetsGeometry padding;

  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.showHandle = true,
    this.padding = AppInsets.sheet,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SafeArea(
      top: false,
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showHandle)
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            if (title != null) ...[
              Text(
                title!,
                style: AppTextStyles.h2.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
