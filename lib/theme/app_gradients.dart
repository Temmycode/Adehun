import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Depth for the app.
///
/// Flat fills everywhere read as unfinished, so hero surfaces get a real
/// gradient plus a couple of off-hue glows rather than one solid colour.
/// These are tokens, not one-off decoration: use them through [MeshSurface]
/// so every rich surface in the app is lit the same way.
abstract final class AppGradients {
  /// The wallet card, the splash field, the escrow amount card.
  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF138A62), Color(0xFF0B6E4F), Color(0xFF06503A)],
    stops: [0.0, 0.52, 1.0],
  );

  /// A deeper cut of [brand] for full-screen fields, where a light top-left
  /// corner would wash out the status bar.
  static const LinearGradient brandDeep = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0E7A57), Color(0xFF084F39)],
  );

  /// Warm wash behind first-run content, on cream.
  static const LinearGradient dawn = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFDF6EC), Color(0xFFF6EEE2)],
  );

  /// The glows layered over [brand]. Clay top-right, gold bottom-left: enough
  /// hue shift that the surface reads as lit rather than tinted.
  static const List<MeshGlow> brandGlows = [
    MeshGlow(
      center: Alignment(0.95, -0.85),
      color: AppColors.accent,
      radius: 0.95,
      opacity: 0.38,
    ),
    MeshGlow(
      center: Alignment(-0.85, 1.0),
      color: AppColors.gold,
      radius: 0.85,
      opacity: 0.22,
    ),
    MeshGlow(
      center: Alignment(-0.4, -1.0),
      color: Color(0xFF4FD6A0),
      radius: 0.7,
      opacity: 0.20,
    ),
  ];
}

/// One radial highlight laid over a gradient surface.
class MeshGlow {
  /// Where the glow sits, in the surface's own alignment space.
  final Alignment center;
  final Color color;

  /// Reach, as a fraction of the surface's shortest side.
  final double radius;
  final double opacity;

  const MeshGlow({
    required this.center,
    required this.color,
    this.radius = 0.8,
    this.opacity = 0.3,
  });
}
