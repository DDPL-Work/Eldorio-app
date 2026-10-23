import 'package:flutter/material.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class EcgWaveAnimation extends StatefulWidget {
  const EcgWaveAnimation({super.key});

  @override
  State<EcgWaveAnimation> createState() => _EcgWaveAnimationState();
}

class _EcgWaveAnimationState extends State<EcgWaveAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _EcgPainter(animationValue: _controller.value),
        );
      },
    );
  }
}

class _EcgPainter extends CustomPainter {
  final double animationValue;

  _EcgPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final sx = size.width / 600.0;
    final sy = size.height / 64.0;

    // SVG path: M0 32 H120 l10 -7 l9 7 H200 l9 -26 l11 52 l11 -40 l9 14 H330 l10 -7 l9 7 H430 l9 -26 l11 52 l11 -40 l9 14 H600
    final fullPath = Path();
    fullPath.moveTo(0 * sx, 32 * sy);
    fullPath.lineTo(120 * sx, 32 * sy);
    fullPath.lineTo(130 * sx, 25 * sy);
    fullPath.lineTo(139 * sx, 32 * sy);
    fullPath.lineTo(200 * sx, 32 * sy);
    fullPath.lineTo(209 * sx, 6 * sy);
    fullPath.lineTo(220 * sx, 58 * sy);
    fullPath.lineTo(231 * sx, 18 * sy);
    fullPath.lineTo(240 * sx, 32 * sy);
    fullPath.lineTo(330 * sx, 32 * sy);
    fullPath.lineTo(340 * sx, 25 * sy);
    fullPath.lineTo(349 * sx, 32 * sy);
    fullPath.lineTo(430 * sx, 32 * sy);
    fullPath.lineTo(439 * sx, 6 * sy);
    fullPath.lineTo(450 * sx, 58 * sy);
    fullPath.lineTo(461 * sx, 18 * sy);
    fullPath.lineTo(470 * sx, 32 * sy);
    fullPath.lineTo(600 * sx, 32 * sy);

    // ── 1. Subtle Background Guide Line ──
    final faintPaint = Paint()
      ..color = ThemeColors.goldenAmber.withValues(alpha: 0.16)
      ..strokeWidth = .8.w
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(fullPath, faintPaint);

    // Calculate progression based on CSS keyframes:
    // 0% -> 72%: line draws from 0 to full length
    // 72% -> 100%: line fades out
    double drawProgress;
    double opacity;

    if (animationValue <= 0.72) {
      drawProgress = (animationValue / 0.72).clamp(0.0, 1.0);
      opacity = 1.0;
    } else {
      drawProgress = 1.0;
      opacity = (1.0 - ((animationValue - 0.72) / 0.28)).clamp(0.0, 1.0);
    }

    final metrics = fullPath.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final metric = metrics.first;
    final currentLength = metric.length * drawProgress;
    final animatedPath = metric.extractPath(0.0, currentLength);

    // ── 2. Glow / Drop-Shadow Pass ──
    final glowPaint = Paint()
      ..color = ThemeColors.goldenAmber.withValues(alpha: 0.55 * opacity)
      ..strokeWidth = 2.w
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2.8.w);
    canvas.drawPath(animatedPath, glowPaint);

    // ── 3. Crisp Foreground Pulse Line ──
    final mainPaint = Paint()
      ..color = ThemeColors.goldenAmber.withValues(alpha: .5)
      ..strokeWidth = .5.w
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(animatedPath, mainPaint);

    // ── 4. Glowing Leading Spark / Pulse Head ──
    if (drawProgress > 0.01 && drawProgress < 0.99 && opacity > 0.1) {
      final tangent = metric.getTangentForOffset(currentLength);
      if (tangent != null) {
        final pos = tangent.position;

        // Wide soft aura
        final auraPaint = Paint()
          ..color = ThemeColors.goldenAmberLight.withValues(alpha: 0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6.w);
        canvas.drawCircle(pos, 8.w, auraPaint);
        // Core bright spark
        final sparkPaint = Paint()
          ..color = ThemeColors.textWhite.withValues(alpha: 0.3);
        canvas.drawCircle(pos, 1.5.w, sparkPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EcgPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
