import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_color_scheme.dart';
import 'app_text_styles.dart';
import 'app_tokens.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = _build(Brightness.light);
  static final ThemeData dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final cs = isDark ? AppColorScheme.dark : AppColorScheme.light;

    final baseText = GoogleFonts.dmSansTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );
    final textTheme = baseText
        .copyWith(
          displayLarge: AppTextStyles.displayLarge,
          displayMedium: AppTextStyles.displayMedium,
          displaySmall: AppTextStyles.h1,
          headlineLarge: AppTextStyles.h1,
          headlineMedium: AppTextStyles.h2,
          headlineSmall: AppTextStyles.h3,
          titleLarge: AppTextStyles.h3,
          titleMedium: AppTextStyles.labelLarge,
          titleSmall: AppTextStyles.labelMedium,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          labelLarge: AppTextStyles.buttonLarge,
          labelMedium: AppTextStyles.labelMedium,
          labelSmall: AppTextStyles.labelSmall,
        )
        .apply(bodyColor: cs.textPrimary, displayColor: cs.textPrimary);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: cs.primarySurface,
      onPrimaryContainer: isDark ? cs.textPrimary : AppColors.primaryDark,
      secondary: AppColors.accent,
      onSecondary: AppColors.textPrimary,
      secondaryContainer: cs.accentLight,
      onSecondaryContainer: AppColors.accentDark,
      surface: cs.surface,
      onSurface: cs.textPrimary,
      surfaceContainerHighest: cs.surfaceVariant,
      onSurfaceVariant: cs.textSecondary,
      outline: cs.cardBorder,
      outlineVariant: cs.cardBorder,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: cs.errorLight,
      onErrorContainer: AppColors.error,
    );

    final buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.button);
    const buttonMinSize = Size(64, 56);
    const buttonPadding = EdgeInsets.symmetric(horizontal: AppSpacing.xxl);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: cs.background,
      canvasColor: cs.background,
      extensions: [cs],
      textTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      dividerColor: cs.cardBorder,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cs.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: cs.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.h3.copyWith(color: cs.textPrimary),
        iconTheme: IconThemeData(color: cs.textPrimary, size: 22),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: brightness,
        ),
      ),
      cardTheme: CardThemeData(
        color: cs.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(color: cs.cardBorder),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: cs.surfaceVariant,
          disabledForegroundColor: cs.textTertiary,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: AppTextStyles.buttonLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: cs.surfaceVariant,
          disabledForegroundColor: cs.textTertiary,
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: AppTextStyles.buttonLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: cs.textTertiary,
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          side: BorderSide(color: cs.cardBorder, width: 1.5),
          textStyle: AppTextStyles.buttonLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(kMinTapTarget, kMinTapTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          shape: buttonShape,
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: cs.textPrimary,
          minimumSize: const Size(kMinTapTarget, kMinTapTarget),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: cs.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: cs.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: cs.cardBorder.withValues(alpha: 0.6)),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: cs.textTertiary),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: cs.textSecondary),
        helperStyle: AppTextStyles.bodySmall.copyWith(color: cs.textSecondary),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
        prefixIconColor: cs.textSecondary,
        suffixIconColor: cs.textSecondary,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cs.surfaceVariant,
        selectedColor: cs.primarySurface,
        labelStyle: AppTextStyles.labelMedium.copyWith(color: cs.textPrimary),
        secondaryLabelStyle:
            AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.chip),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        showCheckmark: false,
      ),
      dividerTheme: DividerThemeData(
        color: cs.cardBorder,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: cs.textSecondary,
        textColor: cs.textPrimary,
        titleTextStyle: AppTextStyles.bodyLarge.copyWith(color: cs.textPrimary),
        subtitleTextStyle:
            AppTextStyles.bodySmall.copyWith(color: cs.textSecondary),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.input),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: cs.surface,
        showDragHandle: false,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sheet),
        clipBehavior: Clip.antiAlias,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
        titleTextStyle: AppTextStyles.h3.copyWith(color: cs.textPrimary),
        contentTextStyle:
            AppTextStyles.bodyMedium.copyWith(color: cs.textSecondary),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? cs.surfaceVariant : AppColors.textPrimary,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: isDark ? cs.textPrimary : Colors.white,
        ),
        actionTextColor: isDark ? AppColors.primaryLight : AppColors.gold,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.input),
        elevation: 0,
        insetPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Colors.white : cs.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary
              : cs.cardBorder,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary
              : Colors.transparent,
        ),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        side: BorderSide(color: cs.cardBorder, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary
              : cs.textTertiary,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: cs.surfaceVariant,
        circularTrackColor: cs.surfaceVariant,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: cs.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.input),
        textStyle: AppTextStyles.bodyMedium.copyWith(color: cs.textPrimary),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: cs.textSecondary,
        labelStyle: AppTextStyles.labelLarge,
        unselectedLabelStyle: AppTextStyles.labelLarge,
        indicatorColor: AppColors.primary,
        dividerColor: cs.cardBorder,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cs.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: cs.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
