import 'package:flutter/material.dart';

import '../theme/app_gradients.dart';

/// A gradient surface with radial glows layered over it.
///
/// This is what replaced the mesh-gradient PNG: same richness, but it scales,
/// themes and tints without shipping a 300 KB image.
class MeshSurface extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final List<MeshGlow> glows;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final List<BoxShadow>? boxShadow;

  const MeshSurface({
    super.key,
    required this.child,
    this.gradient = AppGradients.brand,
    this.glows = AppGradients.brandGlows,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final surface = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(decoration: BoxDecoration(gradient: gradient)),
          ),
          for (final glow in glows)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: glow.center,
                    radius: glow.radius,
                    colors: [
                      glow.color.withValues(alpha: glow.opacity),
                      glow.color.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          Padding(padding: padding, child: child),
        ],
      ),
    );

    if (boxShadow == null) return surface;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: surface,
    );
  }
}
