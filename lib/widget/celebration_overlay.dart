import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class CelebrationOverlay extends StatefulWidget {
  final String bookingCode;
  final VoidCallback onDismiss;

  const CelebrationOverlay({
    super.key,
    required this.bookingCode,
    required this.onDismiss,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _checkAnim;
  late Animation<double> _confettiAnim;

  static const List<Color> _confettiColors = [
    Color(0xFFF2A01F),
    Color(0xFF2F7BD9),
    Color(0xFF1E7A4C),
    Color(0xFFE8577A),
    Color(0xFF62B6FF),
    Color(0xFFF8B544),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3100),
    );

    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOutBack),
      ),
    );

    _checkAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.12, 0.40, curve: Curves.easeOutCubic),
      ),
    );

    _confettiAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.05, 0.55, curve: Curves.easeOutQuad),
      ),
    );

    _controller.forward();

    // Auto dismiss after 3.1s matching HTML celebrateTimer
    Future.delayed(const Duration(milliseconds: 3100), () {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: Material(
        color: Colors.black.withValues(alpha: 0.72),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Confetti Particles (26 pieces matching HTML)
                  ...List.generate(26, (i) {
                    final double angle = (i / 26) * math.pi * 2;
                    final double baseR = 120.0 + (i % 4) * 40.0;
                    final double progress = _confettiAnim.value;
                    final double currentR = baseR * progress;

                    final double x = math.cos(angle) * currentR;
                    final double y = (math.sin(angle) * currentR) + (progress * 60);
                    final double rot = (i * 47) % 360 * (math.pi / 180) + (progress * 2);
                    final double opacity = (1.0 - progress * 0.7).clamp(0.0, 1.0);

                    return Transform.translate(
                      offset: Offset(x, y),
                      child: Transform.rotate(
                        angle: rot,
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            width: (i % 2 == 0) ? 9 : 6,
                            height: (i % 2 == 0) ? 14 : 7,
                            decoration: BoxDecoration(
                              color: _confettiColors[i % _confettiColors.length],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  // Central Celebration Modal Box
                  Transform.scale(
                    scale: _scaleAnim.value,
                    child: Container(
                      width: 82.w,
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.cardSurface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: ThemeColors.cardBorder,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                          BoxShadow(
                            color: ThemeColors.goldenAmber.withValues(alpha: 0.15),
                            blurRadius: 40,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Animated Circular Checkmark SVG/Painter
                          SizedBox(
                            width: 76,
                            height: 76,
                            child: CustomPaint(
                              painter: _CheckmarkPainter(progress: _checkAnim.value),
                            ),
                          ),

                          2.2.h.vs,

                          // Title: "Booking requested!"
                          Text(
                            'Booking requested!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ThemeColors.textWhite,
                              fontSize: 18.5.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),

                          1.2.h.vs,

                          // Subtitle: Request code & message
                          Text(
                            'Request ${widget.bookingCode} has reached our care team. You\'ll get an alert as soon as a caregiver is assigned.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ThemeColors.textMuted,
                              fontSize: 12.5.sp,
                              height: 1.45,
                            ),
                          ),

                          2.5.h.vs,

                          // Tap to view button
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.2.h,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeColors.surface2,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: ThemeColors.cardBorder),
                            ),
                            child: Text(
                              'View booking details',
                              style: TextStyle(
                                color: ThemeColors.goldenAmber,
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;

  _CheckmarkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);
    final double radius = (w / 2) - 4;

    // Background circle track
    final Paint circlePaint = Paint()
      ..color = ThemeColors.successGreen.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, circlePaint);

    final Paint borderPaint = Paint()
      ..color = ThemeColors.successGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6
      ..strokeCap = StrokeCap.round;

    // Draw circle arc
    final double circleProgress = (progress * 1.6).clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * circleProgress,
      false,
      borderPaint,
    );

    // Draw checkmark path
    if (progress > 0.45) {
      final double checkProgress = ((progress - 0.45) / 0.55).clamp(0.0, 1.0);
      final Path path = Path();

      final Offset p1 = Offset(w * 0.28, h * 0.52);
      final Offset p2 = Offset(w * 0.44, h * 0.67);
      final Offset p3 = Offset(w * 0.72, h * 0.38);

      final Paint checkPaint = Paint()
        ..color = ThemeColors.successGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      if (checkProgress <= 0.45) {
        final double subP = checkProgress / 0.45;
        path.moveTo(p1.dx, p1.dy);
        path.lineTo(
          p1.dx + (p2.dx - p1.dx) * subP,
          p1.dy + (p2.dy - p1.dy) * subP,
        );
      } else {
        final double subP = (checkProgress - 0.45) / 0.55;
        path.moveTo(p1.dx, p1.dy);
        path.lineTo(p2.dx, p2.dy);
        path.lineTo(
          p2.dx + (p3.dx - p2.dx) * subP,
          p2.dy + (p3.dy - p2.dy) * subP,
        );
      }

      canvas.drawPath(path, checkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
