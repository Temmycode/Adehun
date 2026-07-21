import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

extension StringToSVG on String {
  Widget toSvg({double? height, double? width, Color? color}) {
    return SvgPicture.asset(this, height: height, width: width, color: color);
  }
}

/// Extension for creating a ValueNotifier from a value directly.
extension ValueNotifierExtension<T> on T {
  /// Converts a variable value into a value notifier of that value
  ValueNotifier<T> get notifier {
    return ValueNotifier<T>(this);
  }
}

/// extension for listening to ValueNotifier instances.
extension ValueNotifierBuilderExtension<T> on ValueNotifier<T> {
  Widget sync({
    required Widget Function(BuildContext context, T value, Widget? child)
    builder,
  }) {
    return ValueListenableBuilder<T>(valueListenable: this, builder: builder);
  }
}

extension ListenableBuilderExtension on List<Listenable> {
  Widget multiSync({
    required Widget Function(BuildContext context, Widget? child) builder,
  }) {
    return ListenableBuilder(
      listenable: Listenable.merge(this),
      builder: builder,
    );
  }
}

extension ScreenSizeExtension on BuildContext {
  double get screenHeight {
    return MediaQuery.of(this).size.height;
  }

  double get screenWidth {
    return MediaQuery.of(this).size.width;
  }
}

extension AppBarHeightExtension on BuildContext {
  double? get appBarHeight {
    return Scaffold.of(this).appBarMaxHeight;
  }
}

extension TargetPlatformExtension on BuildContext {
  TargetPlatform get targetPlatform {
    return Theme.of(this).platform;
  }
}

extension SafeAreaExtension on BuildContext {
  EdgeInsets get safearea {
    return MediaQuery.of(this).padding;
  }
}

extension GetArgument on BuildContext {
  Object? get navigationArguments {
    return GoRouterState.of(this).extra;
  }
}

extension StringCasing on String {
  /// Converts the first character in this string to upper case.

  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

extension SizeToNumber on String? {
  num toNumber() {
    if (this == null) {
      return 0;
    }

    final values = this!.split(' ');
    return num.parse(values.first);
  }
}

extension RouteName on String {
  String get routeName {
    return replaceAll('/', ' ').replaceFirst(' ', '');
  }
}

extension FilePickerResultToFile on FilePickerResult {
  File toFile() {
    return File(files.single.path!);
  }
}
