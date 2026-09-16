import 'package:flutter/material.dart';
import '../theme/app_color_scheme.dart';

/// Skeleton loaders for the app.
///
/// Two conventions hold everything together:
///
/// 1. **Metrics mirror the real widget exactly** — same padding, radii, gaps and
///    bar heights. A skeleton that doesn't match its content makes the layout
///    jump when data lands, which reads as jank no matter how nice the shimmer
///    is.
/// 2. **One sweep per group.** Item skeletons take `shimmer: false` when they
///    sit inside a list skeleton, and the list wraps the whole column in a
///    single [Shimmer]. Independent sweeps per row look like a rendering bug.
///    The flag defaults to true so a bare item still animates on its own.

/// Sweeps a soft highlight across its [child].
///
/// Every placeholder inside is painted in [AppColorScheme.surfaceVariant]; this
/// masks over them with a travelling gradient. Honours the platform's
/// reduce-motion setting by falling back to the flat base colour.
class Shimmer extends StatefulWidget {
  final Widget child;

  /// Override for skeletons that sit on a coloured surface rather than the page
  /// background — the wallet card's gradient, for instance, where the default
  /// grey would look like a rendering fault.
  final Color? baseColor;
  final Color? highlightColor;

  const Shimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  /// Sweeps across for the first 70% of the cycle, then rests. A gapless loop
  /// feels frantic; the pause is what makes it read as "waiting", not "broken".
  static const _sweep = Interval(0, 0.7, curve: Curves.easeInOutSine);

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = widget.baseColor ?? colors.surfaceVariant;

    // Dark surfaces blow out fast, so the highlight has to be far subtler there
    // than the near-white lift that reads well on a light background.
    final highlight =
        widget.highlightColor ??
        Color.alphaBlend(
          Colors.white.withValues(alpha: context.isDarkMode ? 0.10 : 0.55),
          base,
        );

    // Respect the OS reduce-motion switch: the placeholders are already the base
    // colour, so skipping the mask leaves a correct static skeleton.
    if (MediaQuery.of(context).disableAnimations) {
      if (_controller.isAnimating) _controller.stop();
      return widget.child;
    }

    if (!_controller.isAnimating) _controller.repeat();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Travel the band from fully off-screen left to fully off-screen right.
        // The previous implementation kept begin/end symmetric about zero, which
        // pinned the highlight at the centre and merely narrowed it — a pulse,
        // not a sweep.
        final dx = -2.0 + 4.0 * _sweep.transform(_controller.value);

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            // Slight tilt; a purely horizontal band looks mechanical.
            begin: Alignment(dx - 1, -0.2),
            end: Alignment(dx + 1, 0.2),
            colors: [base, highlight, base],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Solid rounded placeholder block.
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  /// For skeletons on a coloured surface — see [Shimmer.baseColor].
  final Color? color;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.radius = 8,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// A text-line placeholder sized as a fraction of the available width.
///
/// Text bars want a tighter radius than blocks, and varying [widthFactor] down a
/// list is what stops a stack of rows reading as a table.
class SkeletonLine extends StatelessWidget {
  final double widthFactor;
  final double height;
  final double radius;
  final Color? color;

  const SkeletonLine({
    super.key,
    this.widthFactor = 1,
    this.height = 12,
    this.radius = 6,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor.clamp(0.0, 1.0),
      child: SkeletonBox(height: height, radius: radius, color: color),
    );
  }
}

/// Circular placeholder, for avatars.
class SkeletonCircle extends StatelessWidget {
  final double diameter;
  final Color? color;

  const SkeletonCircle({super.key, required this.diameter, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color ?? context.colors.surfaceVariant,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Card shell every card-shaped skeleton in this file sits in — matches the
/// `surface` + `cardBorder` recipe the real cards use.
class _SkeletonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const _SkeletonCard({
    required this.child,
    required this.padding,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: colors.cardBorder),
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Home — analytics
// ---------------------------------------------------------------------------

/// Mirrors `_AnalyticsCard` on the home screen.
class AnalyticsCardSkeleton extends StatelessWidget {
  final bool shimmer;

  const AnalyticsCardSkeleton({super.key, this.shimmer = true});

  @override
  Widget build(BuildContext context) {
    const card = _SkeletonCard(
      padding: EdgeInsets.all(18),
      radius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 160, height: 12),
          SizedBox(height: 18),
          _BarRowSkeleton(widthFactor: 0.85),
          SizedBox(height: 12),
          _BarRowSkeleton(widthFactor: 0.55),
          SizedBox(height: 12),
          _BarRowSkeleton(widthFactor: 0.7),
        ],
      ),
    );

    return shimmer ? const Shimmer(child: card) : card;
  }
}

class _BarRowSkeleton extends StatelessWidget {
  final double widthFactor;

  const _BarRowSkeleton({required this.widthFactor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 72, child: SkeletonBox(height: 10)),
        const SizedBox(width: 8),
        Expanded(
          child: SkeletonLine(widthFactor: widthFactor, height: 8, radius: 4),
        ),
        const SizedBox(width: 10),
        const SizedBox(width: 20, child: SkeletonBox(height: 10)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Agreements
// ---------------------------------------------------------------------------

/// Mirrors `AgreementCard` shape and spacing.
class AgreementCardSkeleton extends StatelessWidget {
  final bool shimmer;

  /// Title bar width, varied down a list so rows don't line up.
  final double titleWidthFactor;

  const AgreementCardSkeleton({
    super.key,
    this.shimmer = true,
    this.titleWidthFactor = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    final card = _SkeletonCard(
      padding: const EdgeInsets.all(16),
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + title/role + status pill
          Row(
            children: [
              const SkeletonCircle(diameter: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(widthFactor: titleWidthFactor, height: 14),
                    const SizedBox(height: 6),
                    const SkeletonBox(width: 120, height: 10),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const SkeletonBox(width: 64, height: 22, radius: 11),
            ],
          ),
          const SizedBox(height: 14),
          // Amount + conditions progress
          Row(
            children: const [
              SkeletonBox(width: 110, height: 22),
              Spacer(),
              SkeletonBox(width: 84, height: 10),
              SizedBox(width: 8),
              SkeletonBox(width: 48, height: 5, radius: 3),
            ],
          ),
        ],
      ),
    );

    return shimmer ? Shimmer(child: card) : card;
  }
}

/// N agreement cards under a single sweep, with the 12px gap the real list uses.
class AgreementListSkeleton extends StatelessWidget {
  final int count;

  const AgreementListSkeleton({super.key, this.count = 4});

  static const _widthFactors = <double>[0.7, 0.52, 0.8, 0.62, 0.74, 0.45];

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        children: [
          for (var i = 0; i < count; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == count - 1 ? 0 : 12),
              child: AgreementCardSkeleton(
                shimmer: false,
                titleWidthFactor: _widthFactors[i % _widthFactors.length],
              ),
            ),
        ],
      ),
    );
  }
}

/// The two party rows on the agreement detail screen — mirrors `_PartyRow`.
class PartyRowSkeleton extends StatelessWidget {
  final bool shimmer;

  const PartyRowSkeleton({super.key, this.shimmer = true});

  @override
  Widget build(BuildContext context) {
    const row = Row(
      children: [
        SkeletonCircle(diameter: 40),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(widthFactor: 0.28, height: 10),
              SizedBox(height: 6),
              SkeletonLine(widthFactor: 0.5),
            ],
          ),
        ),
      ],
    );

    return shimmer ? const Shimmer(child: row) : row;
  }
}

// ---------------------------------------------------------------------------
// Conditions
// ---------------------------------------------------------------------------

/// Mirrors `_ConditionCard` on the agreement detail screen.
class ConditionCardSkeleton extends StatelessWidget {
  final bool shimmer;
  final double titleWidthFactor;

  /// The real card only renders the "Required from" pill when the condition has
  /// an assignee, so the skeleton varies it too.
  final bool showAssignee;

  const ConditionCardSkeleton({
    super.key,
    this.shimmer = true,
    this.titleWidthFactor = 0.6,
    this.showAssignee = true,
  });

  @override
  Widget build(BuildContext context) {
    final card = _SkeletonCard(
      padding: const EdgeInsets.all(14),
      radius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SkeletonBox(width: 36, height: 36, radius: 10),
              const SizedBox(width: 12),
              Expanded(child: SkeletonLine(widthFactor: titleWidthFactor)),
              const SizedBox(width: 8),
              const SkeletonBox(width: 56, height: 20, radius: 10),
              const SizedBox(width: 8),
              const SkeletonBox(width: 8, height: 14, radius: 3),
            ],
          ),
          if (showAssignee) ...[
            const SizedBox(height: 10),
            const SkeletonBox(width: 150, height: 24, radius: 8),
          ],
        ],
      ),
    );

    return shimmer ? Shimmer(child: card) : card;
  }
}

class ConditionListSkeleton extends StatelessWidget {
  final int count;

  const ConditionListSkeleton({super.key, this.count = 3});

  static const _widthFactors = <double>[0.6, 0.42, 0.7, 0.5];

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        children: [
          for (var i = 0; i < count; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == count - 1 ? 0 : 10),
              child: ConditionCardSkeleton(
                shimmer: false,
                titleWidthFactor: _widthFactors[i % _widthFactors.length],
                // Mixed, because the real list is mixed.
                showAssignee: i.isEven,
              ),
            ),
        ],
      ),
    );
  }
}

/// Whole-screen skeleton for the condition detail screen, laid out on the same
/// grid as the real content: status badge, title, description, assignee card,
/// then the assets list.
class ConditionDetailSkeleton extends StatelessWidget {
  const ConditionDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const SkeletonBox(width: 84, height: 24, radius: 12),
          const SizedBox(height: 12),
          const SkeletonLine(widthFactor: 0.75, height: 22, radius: 8),
          const SizedBox(height: 12),
          const SkeletonLine(widthFactor: 1, height: 12),
          const SizedBox(height: 8),
          const SkeletonLine(widthFactor: 0.6, height: 12),
          const SizedBox(height: 16),
          // "Required from" card
          _SkeletonCard(
            padding: const EdgeInsets.all(14),
            radius: 12,
            child: Row(
              children: const [
                SkeletonCircle(diameter: 36),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(widthFactor: 0.3, height: 10),
                      SizedBox(height: 6),
                      SkeletonLine(widthFactor: 0.45),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const AssetListSkeleton(count: 2, shimmer: false),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Assets
// ---------------------------------------------------------------------------

/// Mirrors `_AssetCard` on the condition detail screen.
class AssetCardSkeleton extends StatelessWidget {
  final bool shimmer;
  final double nameWidthFactor;

  const AssetCardSkeleton({
    super.key,
    this.shimmer = true,
    this.nameWidthFactor = 0.65,
  });

  @override
  Widget build(BuildContext context) {
    final card = _SkeletonCard(
      padding: const EdgeInsets.all(14),
      radius: 12,
      child: Row(
        children: [
          const SkeletonBox(width: 48, height: 48, radius: 10),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(widthFactor: nameWidthFactor),
                const SizedBox(height: 8),
                const SkeletonLine(widthFactor: 0.3, height: 10),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const SkeletonBox(width: 64, height: 20, radius: 10),
        ],
      ),
    );

    return shimmer ? Shimmer(child: card) : card;
  }
}

class AssetListSkeleton extends StatelessWidget {
  final int count;
  final bool shimmer;

  const AssetListSkeleton({super.key, this.count = 2, this.shimmer = true});

  static const _widthFactors = <double>[0.65, 0.45, 0.72];

  @override
  Widget build(BuildContext context) {
    final list = Column(
      children: [
        for (var i = 0; i < count; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == count - 1 ? 0 : 10),
            child: AssetCardSkeleton(
              shimmer: false,
              nameWidthFactor: _widthFactors[i % _widthFactors.length],
            ),
          ),
      ],
    );

    return shimmer ? Shimmer(child: list) : list;
  }
}

// ---------------------------------------------------------------------------
// Notifications
// ---------------------------------------------------------------------------

/// Mirrors `NotificationTile` — note it's a bottom-bordered row, not a card, so
/// the skeleton carries the same divider.
class NotificationTileSkeleton extends StatelessWidget {
  final bool shimmer;
  final double titleWidthFactor;

  /// Unread tiles show a dot and a tinted background; the skeleton mixes both so
  /// the transition into real data isn't a jolt.
  final bool unread;

  const NotificationTileSkeleton({
    super.key,
    this.shimmer = true,
    this.titleWidthFactor = 0.55,
    this.unread = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final tile = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unread
            ? colors.primarySurface.withValues(alpha: 0.5)
            : colors.surface,
        border: Border(bottom: BorderSide(color: colors.cardBorder)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 42, height: 42, radius: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SkeletonLine(widthFactor: titleWidthFactor),
                    ),
                    if (unread) ...[
                      const SizedBox(width: 8),
                      const SkeletonCircle(diameter: 8),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                const SkeletonLine(height: 10),
                const SizedBox(height: 6),
                const SkeletonLine(widthFactor: 0.8, height: 10),
                const SizedBox(height: 8),
                const SkeletonLine(widthFactor: 0.18, height: 9),
              ],
            ),
          ),
        ],
      ),
    );

    return shimmer ? Shimmer(child: tile) : tile;
  }
}

class NotificationListSkeleton extends StatelessWidget {
  final int count;

  const NotificationListSkeleton({super.key, this.count = 7});

  static const _widthFactors = <double>[0.55, 0.4, 0.66, 0.48, 0.6, 0.35];

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        children: [
          for (var i = 0; i < count; i++)
            NotificationTileSkeleton(
              shimmer: false,
              titleWidthFactor: _widthFactors[i % _widthFactors.length],
              // The unread ones cluster at the top, as they do in the real list.
              unread: i < 2,
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Wallet & transactions
// ---------------------------------------------------------------------------

/// Balance placeholder for `WalletCard`.
///
/// Sits on the wallet gradient, so it tints white instead of using the grey
/// surface colour — the default would look like a rendering fault.
class WalletBalanceSkeleton extends StatelessWidget {
  final bool compact;

  const WalletBalanceSkeleton({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final onGradient = Colors.white.withValues(alpha: 0.22);

    return Shimmer(
      baseColor: onGradient,
      highlightColor: Colors.white.withValues(alpha: 0.45),
      child: SkeletonBox(
        width: compact ? 150 : 180,
        height: compact ? 30 : 34,
        radius: 10,
        color: onGradient,
      ),
    );
  }
}

/// One transaction row, matching `TransactionTile`'s metrics.
class TransactionTileSkeleton extends StatelessWidget {
  final bool shimmer;

  /// Fraction of the available width the title bar occupies. Varying this per
  /// row is what stops the stack reading as a grid.
  final double titleWidthFactor;

  const TransactionTileSkeleton({
    super.key,
    this.shimmer = true,
    this.titleWidthFactor = 0.62,
  });

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const SkeletonBox(width: 44, height: 44, radius: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(widthFactor: titleWidthFactor),
                const SizedBox(height: 8),
                const SkeletonLine(widthFactor: 0.28, height: 10),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const SkeletonBox(width: 68, height: 14),
        ],
      ),
    );

    return shimmer ? Shimmer(child: row) : row;
  }
}

/// N transaction rows under a single sweep, divided like the real list.
class TransactionListSkeleton extends StatelessWidget {
  final int count;

  /// Mirrors the `Divider(height: 1)` the real list puts between rows.
  final bool showDividers;

  const TransactionListSkeleton({
    super.key,
    this.count = 6,
    this.showDividers = true,
  });

  static const _widthFactors = <double>[0.62, 0.45, 0.74, 0.53, 0.68, 0.4];

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        children: [
          for (var i = 0; i < count; i++) ...[
            TransactionTileSkeleton(
              shimmer: false,
              titleWidthFactor: _widthFactors[i % _widthFactors.length],
            ),
            if (showDividers && i < count - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}
