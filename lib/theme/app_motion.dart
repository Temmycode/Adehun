import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'app_tokens.dart';

/// Entrance animation for list items and sections.
///
/// `index` staggers the start; items past [AppMotion.staggerCap] appear with
/// the same delay as the last staggered item so long lists don't crawl in.
/// Returns the widget unchanged when the OS asks for reduced motion.
extension EntranceX on Widget {
  Widget entrance(BuildContext context, [int index = 0]) {
    if (AppMotion.reduced(context)) return this;
    final delay = AppMotion.staggerInterval * index.clamp(0, AppMotion.staggerCap);
    return animate(delay: delay)
        .fadeIn(duration: AppMotion.normal, curve: AppMotion.curve)
        .slideY(begin: 0.06, end: 0, duration: AppMotion.normal, curve: AppMotion.curve);
  }
}
