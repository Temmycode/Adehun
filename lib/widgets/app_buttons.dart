import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

enum ButtonTone { primary, accent, danger }

/// Filled 56px pill. The one call to action per screen.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final bool expand;
  final ButtonTone tone;
  final bool haptic;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.expand = true,
    this.tone = ButtonTone.primary,
    this.haptic = true,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      ButtonTone.primary => (AppColors.primary, AppColors.textOnPrimary),
      ButtonTone.accent => (AppColors.accent, AppColors.textPrimary),
      ButtonTone.danger => (AppColors.error, Colors.white),
    };

    return _ButtonShell(
      expand: expand,
      loading: loading,
      enabled: onPressed != null,
      child: FilledButton(
        onPressed: _wrap(onPressed, loading, haptic),
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor:
              loading ? bg : context.colors.surfaceVariant,
          disabledForegroundColor:
              loading ? fg : context.colors.textTertiary,
        ),
        child: _ButtonContent(
          label: label,
          icon: icon,
          loading: loading,
          spinnerColor: fg,
        ),
      ),
    );
  }
}

/// Outlined 56px pill for the secondary choice next to a [PrimaryButton].
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final bool expand;
  final ButtonTone tone;
  final bool haptic;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.expand = true,
    this.tone = ButtonTone.primary,
    this.haptic = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = switch (tone) {
      ButtonTone.primary => AppColors.primary,
      ButtonTone.accent => AppColors.accentDark,
      ButtonTone.danger => AppColors.error,
    };

    return _ButtonShell(
      expand: expand,
      loading: loading,
      enabled: onPressed != null,
      child: OutlinedButton(
        onPressed: _wrap(onPressed, loading, haptic),
        style: OutlinedButton.styleFrom(
          foregroundColor: fg,
          backgroundColor: colors.surface,
          side: BorderSide(color: colors.cardBorder, width: 1.5),
        ),
        child: _ButtonContent(
          label: label,
          icon: icon,
          loading: loading,
          spinnerColor: fg,
        ),
      ),
    );
  }
}

/// Text-only action, for "Skip", "I already have an account", and the like.
class TertiaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonTone tone;
  final bool expand;
  final bool haptic;

  const TertiaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.tone = ButtonTone.primary,
    this.expand = false,
    this.haptic = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = switch (tone) {
      ButtonTone.primary => AppColors.primary,
      ButtonTone.accent => AppColors.accentDark,
      ButtonTone.danger => AppColors.error,
    };
    final button = TextButton(
      onPressed: _wrap(onPressed, false, haptic),
      style: TextButton.styleFrom(
        foregroundColor: fg,
        minimumSize: Size(expand ? double.infinity : kMinTapTarget, 48),
        textStyle: AppTextStyles.buttonLarge,
      ),
      child: _ButtonContent(label: label, icon: icon, spinnerColor: fg),
    );
    return _PressScale(enabled: onPressed != null, child: button);
  }
}

VoidCallback? _wrap(VoidCallback? onPressed, bool loading, bool haptic) {
  if (onPressed == null) return null;
  if (loading) return () {};
  if (!haptic) return onPressed;
  return () {
    HapticFeedback.lightImpact();
    onPressed();
  };
}

class _ButtonShell extends StatelessWidget {
  final Widget child;
  final bool expand;
  final bool loading;
  final bool enabled;

  const _ButtonShell({
    required this.child,
    required this.expand,
    required this.loading,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = _PressScale(enabled: enabled && !loading, child: child);
    if (loading) body = IgnorePointer(child: body);
    if (expand) body = SizedBox(width: double.infinity, child: body);
    return body;
  }
}

class _ButtonContent extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool loading;
  final Color spinnerColor;

  const _ButtonContent({
    required this.label,
    required this.spinnerColor,
    this.icon,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(label, maxLines: 1, overflow: TextOverflow.ellipsis);
    final content = icon == null
        ? text
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Flexible(child: text),
            ],
          );

    return AnimatedSwitcher(
      duration: AppMotion.fast,
      child: loading
          ? SizedBox(
              key: const ValueKey('spinner'),
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: spinnerColor,
              ),
            )
          : KeyedSubtree(key: const ValueKey('label'), child: content),
    );
  }
}

/// Scales the child down slightly while pressed. Purely decorative, so it is
/// skipped under reduced motion.
class _PressScale extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const _PressScale({required this.child, required this.enabled});

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _down = false;

  void _set(bool value) {
    if (_down == value || !widget.enabled) return;
    setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduced(context)) return widget.child;
    return Listener(
      behavior: HitTestBehavior.deferToChild,
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? 0.97 : 1,
        duration: AppMotion.fast,
        curve: AppMotion.curve,
        child: widget.child,
      ),
    );
  }
}
