import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_tokens.dart';

/// One blurred sphere on its own orbit.
class BlobSpec {
  final double size;
  final Color color;

  /// Distance from the centre, as a fraction of the field's half-width.
  final double orbit;

  /// Where on the orbit it starts, in turns (0 to 1).
  final double phase;
  final double blur;

  const BlobSpec({
    required this.size,
    required this.color,
    required this.orbit,
    required this.phase,
    this.blur = 7,
  });
}

/// Three soft spheres drifting around a shared centre.
///
/// This carried the old auth screen and is the app's one piece of ambient
/// motion. It scales in on first build, then keeps turning slowly. Under
/// reduced motion it renders the same arrangement, still.
class OrbitingBlobs extends StatefulWidget {
  final double size;
  final List<BlobSpec> blobs;

  /// Time for one full turn. Long on purpose: this should read as drift.
  final Duration period;

  const OrbitingBlobs({
    super.key,
    required this.size,
    this.blobs = defaultBlobs,
    this.period = const Duration(seconds: 22),
  });

  /// Green leads, clay answers it, gold fills the gap.
  static const defaultBlobs = [
    BlobSpec(
      size: 0.40,
      color: AppColors.primary,
      orbit: 0.30,
      phase: 0,
      blur: 6,
    ),
    BlobSpec(
      size: 0.33,
      color: AppColors.accent,
      orbit: 0.28,
      phase: 0.5,
      blur: 7,
    ),
    BlobSpec(
      size: 0.28,
      color: AppColors.gold,
      orbit: 0.24,
      phase: 0.3,
      blur: 8,
    ),
  ];

  @override
  State<OrbitingBlobs> createState() => _OrbitingBlobsState();
}

class _OrbitingBlobsState extends State<OrbitingBlobs>
    with TickerProviderStateMixin {
  late final AnimationController _orbit = AnimationController(
    vsync: this,
    duration: widget.period,
  );
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _orbit.stop();
      _entrance.value = 1;
      return;
    }
    if (!_orbit.isAnimating) _orbit.repeat();
    if (_entrance.value == 0) _entrance.forward();
  }

  @override
  void dispose() {
    _orbit.dispose();
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = widget.size;
    final centre = field / 2;

    return SizedBox(
      width: field,
      height: field,
      child: AnimatedBuilder(
        animation: Listenable.merge([_orbit, _entrance]),
        builder: (context, _) {
          final turn = _orbit.value * 2 * math.pi;
          final scale = Curves.easeOutBack.transform(
            _entrance.value.clamp(0.0, 1.0),
          );

          return Transform.scale(
            scale: 0.72 + 0.28 * scale,
            child: Stack(
              alignment: Alignment.center,
              children: [
                for (final blob in widget.blobs)
                  _positioned(blob, field, centre, turn),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _positioned(BlobSpec blob, double field, double centre, double turn) {
    final diameter = field * blob.size;
    final radius = centre * blob.orbit;
    final angle = turn + blob.phase * 2 * math.pi;

    return Positioned(
      left: centre + radius * math.cos(angle) - diameter / 2,
      top: centre + radius * math.sin(angle) - diameter / 2,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blob.blur, sigmaY: blob.blur),
        child: _Sphere(diameter: diameter, color: blob.color),
      ),
    );
  }
}

class _Sphere extends StatelessWidget {
  final double diameter;
  final Color color;

  const _Sphere({required this.diameter, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Lit from the upper left, barely. Enough to read as a sphere rather
        // than a flat disc, without turning into a 2008 glass button.
        gradient: RadialGradient(
          center: const Alignment(-0.35, -0.42),
          radius: 0.95,
          colors: [
            Color.lerp(color, Colors.white, 0.28)!,
            color,
            Color.lerp(color, Colors.black, 0.10)!,
          ],
          stops: const [0.0, 0.52, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.28),
            blurRadius: diameter * 0.3,
            offset: Offset(0, diameter * 0.08),
            spreadRadius: -diameter * 0.05,
          ),
        ],
      ),
    );
  }
}
