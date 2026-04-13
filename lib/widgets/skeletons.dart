import 'package:flutter/material.dart';
import '../theme/app_color_scheme.dart';

/// Lightweight shimmer wrapper. Paints a moving gradient over its [child]
/// using [ShaderMask]. No external dependency.
class Shimmer extends StatefulWidget {
  final Widget child;
  const Shimmer({super.key, required this.child});

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = colors.surfaceVariant;
    final highlight = Color.alphaBlend(
      Colors.white.withValues(alpha: 0.35),
      base,
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 - 2 * (1 - t), 0),
              end: Alignment(1.0 + 2 * (1 - t), 0),
              stops: const [0.35, 0.5, 0.65],
              colors: [base, highlight, base],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Solid rounded placeholder block used inside skeletons.
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Skeleton mirroring `_AnalyticsCard` on the home screen.
class AnalyticsCardSkeleton extends StatelessWidget {
  const AnalyticsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Shimmer(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SkeletonBox(width: 160, height: 12),
            SizedBox(height: 18),
            _BarRowSkeleton(),
            SizedBox(height: 12),
            _BarRowSkeleton(),
            SizedBox(height: 12),
            _BarRowSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _BarRowSkeleton extends StatelessWidget {
  const _BarRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        SizedBox(width: 72, child: SkeletonBox(height: 10)),
        SizedBox(width: 8),
        Expanded(child: SkeletonBox(height: 8, radius: 4)),
        SizedBox(width: 10),
        SizedBox(width: 20, child: SkeletonBox(height: 10)),
      ],
    );
  }
}

/// Skeleton mirroring `AgreementCard` shape & spacing.
class AgreementCardSkeleton extends StatelessWidget {
  const AgreementCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Shimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: title + status badge
            Row(
              children: const [
                Expanded(child: SkeletonBox(height: 14)),
                SizedBox(width: 8),
                SkeletonBox(width: 56, height: 20, radius: 10),
              ],
            ),
            const SizedBox(height: 14),
            // Row 2: amount + parties
            Row(
              children: [
                const SkeletonBox(width: 110, height: 18),
                const Spacer(),
                Row(
                  children: const [
                    SkeletonBox(width: 28, height: 28, radius: 14),
                    SizedBox(width: 8),
                    SkeletonBox(width: 28, height: 28, radius: 14),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Row 3: conditions bar
            Row(
              children: const [
                SkeletonBox(width: 90, height: 10),
                Spacer(),
                SkeletonBox(width: 48, height: 4, radius: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders N skeleton cards stacked with the same 12px gap the real list uses.
class AgreementListSkeleton extends StatelessWidget {
  final int count;
  const AgreementListSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (_) => const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: AgreementCardSkeleton(),
        ),
      ),
    );
  }
}
