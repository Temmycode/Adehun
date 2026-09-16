import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_tokens.dart';

/// A one-shot confetti burst painted over [child]. Plays once when built with
/// `play: true`; skipped entirely under reduced motion.
class ConfettiBurst extends StatefulWidget {
  final Widget child;
  final bool play;
  final int particles;

  const ConfettiBurst({
    super.key,
    required this.child,
    this.play = true,
    this.particles = 36,
  });

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  late final List<_Particle> _particles;

  static const _palette = [
    AppColors.primary,
    AppColors.primaryLight,
    AppColors.accent,
    AppColors.gold,
    AppColors.accentLight,
    Color(0xFF9DBCE8),
  ];

  @override
  void initState() {
    super.initState();
    final rng = math.Random();
    _particles = List.generate(widget.particles, (i) {
      final angle = -math.pi / 2 + (rng.nextDouble() - 0.5) * math.pi * 1.1;
      final speed = 0.55 + rng.nextDouble() * 0.6;
      return _Particle(
        color: _palette[i % _palette.length],
        angle: angle,
        speed: speed,
        size: 5 + rng.nextDouble() * 5,
        spin: (rng.nextDouble() - 0.5) * 10,
        wobble: rng.nextDouble() * math.pi * 2,
        isCircle: rng.nextBool(),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.play && !AppMotion.reduced(context) && !_controller.isAnimating &&
        _controller.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.play || AppMotion.reduced(context)) return widget.child;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, _) => CustomPaint(
                painter: _ConfettiPainter(_particles, _controller.value),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Particle {
  final Color color;
  final double angle;
  final double speed;
  final double size;
  final double spin;
  final double wobble;
  final bool isCircle;

  const _Particle({
    required this.color,
    required this.angle,
    required this.speed,
    required this.size,
    required this.spin,
    required this.wobble,
    required this.isCircle,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;

  _ConfettiPainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    if (t == 0) return;
    final origin = Offset(size.width / 2, size.height / 2);
    final reach = math.max(size.width, size.height) * 0.9;
    final eased = Curves.easeOutCubic.transform(t);
    final gravity = t * t * reach * 0.6;
    final fade = t < 0.7 ? 1.0 : (1 - (t - 0.7) / 0.3).clamp(0.0, 1.0);

    for (final p in particles) {
      final dist = eased * reach * p.speed;
      final dx = math.cos(p.angle) * dist + math.sin(t * 6 + p.wobble) * 6;
      final dy = math.sin(p.angle) * dist + gravity;
      final pos = origin + Offset(dx, dy);
      final paint = Paint()..color = p.color.withValues(alpha: fade);

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(p.spin * t);
      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
            const Radius.circular(1.5),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
