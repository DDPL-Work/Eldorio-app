import 'dart:math' as math;
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:eldoriaCare/utils/preference.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Animation Controllers ──────────────────────────────────────────
  late AnimationController _mainAnimController;
  late AnimationController _pulseGlowController;
  late AnimationController _ecgController;
  late AnimationController _driftController;

  // ── Entrance Animations ─────────────────────────────────────────────
  late Animation<double> _logoScale;
  late Animation<double> _logoRotate;
  late Animation<double> _logoOpacity;

  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;

  late Animation<double> _ecgOpacity;

  late Animation<double> _taglineOpacity;
  late Animation<Offset> _taglineSlide;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    Helper.init();

    // 1. Main entrance timeline (0.0 to 1.0 mapped across 2400ms)
    _mainAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // 2. Logo entrance (0ms -> 1100ms) with elastic bounce
    _logoScale = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0.0, 0.46, curve: Curves.easeOutBack),
      ),
    );

    _logoRotate = Tween<double>(begin: -0.4, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0.0, 0.46, curve: Curves.easeOutCubic),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    // 3. Title entrance (700ms -> 1400ms)
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0.29, 0.58, curve: Curves.easeOut),
      ),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainAnimController,
            curve: const Interval(0.29, 0.58, curve: Curves.easeOutCubic),
          ),
        );

    // 4. ECG pulse line entrance (400ms -> 1200ms)
    _ecgOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0.18, 0.50, curve: Curves.easeIn),
      ),
    );

    // 5. Tagline entrance (1100ms -> 1800ms)
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0.46, 0.75, curve: Curves.easeOut),
      ),
    );

    _taglineSlide =
        Tween<Offset>(begin: const Offset(0, 0.30), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainAnimController,
            curve: const Interval(0.46, 0.75, curve: Curves.easeOutCubic),
          ),
        );

    // Continuous subtle breathing glow on logo (1.1s onwards, repeats indefinitely)
    _pulseGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    // Continuous ECG traveling pulse line
    _ecgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // Continuous floating blobs/ambient drift controller
    _driftController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 14000),
    );

    // Start timelines
    _mainAnimController.forward();

    // Trigger looping animations after entrance
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _ecgController.repeat();
    });

    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) _pulseGlowController.repeat(reverse: true);
    });

    _driftController.repeat();

    _requestNotificationPermission();
    _handleNavigation();
  }

  Future<void> _requestNotificationPermission() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          await Permission.notification.request();
        }
      }
    } catch (_) {
      // Non-fatal permission request
    }
  }

  void _handleNavigation() {
    // 3.1s animation matching the reference: animation: introOut .6s ease-in 3.1s forwards
    Future.delayed(const Duration(milliseconds: 3400), () {
      _navigateNext();
    });
  }

  void _navigateNext() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    if (Preference.isLogin) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _mainAnimController.dispose();
    _pulseGlowController.dispose();
    _ecgController.dispose();
    _driftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.initWithContext(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: ThemeColors.transparentColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: ThemeColors.sceneDarkNavy,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: ThemeColors.sceneDarkNavy,
        body: Stack(
          children: [
            // ── Background Gradient (linear-gradient(140deg, #071A33 0%, #0E2F5A 42%, #1B4F8E 100%)) ──
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.8, -1.0),
                    end: Alignment(0.8, 1.0),
                    stops: [0.0, 0.42, 1.0],
                    colors: [
                      ThemeColors.sceneDarkNavy,
                      ThemeColors.brandNavy,
                      ThemeColors.brandNavySoft,
                    ],
                  ),
                ),
              ),
            ),

            // ── Ambient Drifting Light Blobs ─────────────────────────────
            _buildDriftingBlobs(),

            // ── Rising Care Floating Icons ──────────────────────────────
            _buildRisingFloaties(),

            // ── Central Hero Content ────────────────────────────────────
            Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 1. Logo with elastic bounce entrance & glowing aura
                      _buildAnimatedLogo(),

                      3.5.h.vs,

                      // 2. Animated Title: Eldoria+ Care at Home
                      _buildAnimatedTitle(),

                      1.8.h.vs,

                      // 3. Heartbeat Pulse Line (ECG)
                      _buildAnimatedEcg(),

                      1.8.h.vs,

                      // 4. Tagline: "Trusted nursing & elder care, at home"
                      _buildAnimatedTagline(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Ambient Drifting Blobs ──────────────────────────────────────────
  Widget _buildDriftingBlobs() {
    return AnimatedBuilder(
      animation: _driftController,
      builder: (context, child) {
        final double t = _driftController.value;
        final double offsetX1 = math.sin(t * math.pi * 2) * 25;
        final double offsetY1 = math.cos(t * math.pi * 2) * 20;

        final double offsetX2 = math.cos(t * math.pi * 2) * -30;
        final double offsetY2 = math.sin(t * math.pi * 2) * 22;

        return Stack(
          children: [
            // Blob 1: Deep Blue (Top-Left)
            Positioned(
              top: -80 + offsetY1,
              left: -70 + offsetX1,
              child: Container(
                width: 65.w,
                height: 65.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.brandBlue.withValues(alpha: 0.45),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 55, sigmaY: 55),
                  child: Container(color: ThemeColors.transparentColor),
                ),
              ),
            ),

            // Blob 2: Warm Amber (Bottom-Right)
            Positioned(
              bottom: -90 + offsetY2,
              right: -60 + offsetX2,
              child: Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.goldenAmber.withValues(alpha: 0.25),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 55, sigmaY: 55),
                  child: Container(color: ThemeColors.transparentColor),
                ),
              ),
            ),

            // Blob 3: Light Cyan/Sky Blue (Mid-Right)
            Positioned(
              top: 28.h,
              right: 12.w,
              child: Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.lightBlue.withValues(alpha: 0.20),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
                  child: Container(color: ThemeColors.transparentColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Rising Floating Care Icons ──────────────────────────────────────
  Widget _buildRisingFloaties() {
    final floaties = [
      _FloatySpec(icon: Icons.add_rounded, left: 0.08, size: 5.w, speed: 8),
      _FloatySpec(
        icon: Icons.favorite_rounded,
        left: 0.26,
        size: 5.5.w,
        speed: 10,
      ),
      _FloatySpec(
        icon: Icons.monitor_heart_rounded,
        left: 0.46,
        size: 6.w,
        speed: 7,
      ),
      _FloatySpec(
        icon: Icons.local_hospital_rounded,
        left: 0.64,
        size: 4.5.w,
        speed: 9,
      ),
      _FloatySpec(icon: Icons.shield_rounded, left: 0.82, size: 5.5.w, speed: 11),
    ];

    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _mainAnimController,
          builder: (context, child) {
            return Stack(
              children: floaties.map((f) {
                return _buildSingleFloaty(f);
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSingleFloaty(_FloatySpec f) {
    return AnimatedBuilder(
      animation: _driftController,
      builder: (context, child) {
        final double progress = (_driftController.value * f.speed) % 1.0;
        final double bottom = -30 + (progress * (100.h + 80));
        final double opacity = progress < 0.15
            ? progress / 0.15 * 0.25
            : progress > 0.82
            ? (1.0 - progress) / 0.18 * 0.25
            : 0.25;

        final double rotate = progress * 0.8;

        return Positioned(
          left: 100.w * f.left,
          bottom: bottom,
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Transform.rotate(
              angle: rotate,
              child: Icon(f.icon, color: ThemeColors.textWhite, size: f.size),
            ),
          ),
        );
      },
    );
  }

  // ── Animated Circular Logo ──────────────────────────────────────────
  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_mainAnimController, _pulseGlowController]),
      builder: (context, child) {
        final double scale = _logoScale.value;
        final double rotate = _logoRotate.value;
        final double opacity = _logoOpacity.value;

        // Pulsing glow aura values
        final double glowVal = _pulseGlowController.value;
        final double auraRadius = 18 + (glowVal * 28);
        final double auraOpacity = 0.25 + (glowVal * 0.35);

        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.rotate(
            angle: rotate,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.textWhite,
                  boxShadow: [
                    // Outer warm amber glow aura
                    BoxShadow(
                      color: ThemeColors.goldenAmber.withValues(alpha: auraOpacity),
                      blurRadius: auraRadius,
                      spreadRadius: 2,
                    ),
                    // Inner soft white glow ring
                    BoxShadow(
                      color: ThemeColors.textWhite.withValues(
                        alpha: 0.18 + glowVal * 0.15,
                      ),
                      blurRadius: 10,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(3.w),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icons/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback in case logo asset name is variant
                      return Image.asset(
                        'assets/icons/horizontal_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => Icon(
                          Icons.favorite_rounded,
                          size: 16.w,
                          color: ThemeColors.brandNavy,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Animated App Title ──────────────────────────────────────────────
  Widget _buildAnimatedTitle() {
    return AnimatedBuilder(
      animation: _mainAnimController,
      builder: (context, child) {
        return SlideTransition(
          position: _titleSlide,
          child: Opacity(
            opacity: _titleOpacity.value.clamp(0.0, 1.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 27.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  fontFamily: 'Inter',
                ),
                children: const [
                  TextSpan(
                    text: 'Eldoria ',
                    style: TextStyle(color: ThemeColors.textWhite),
                  ),
                  TextSpan(
                    text: '+',
                    style: TextStyle(
                      color: ThemeColors.goldenAmber,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ' Care at Home',
                    style: TextStyle(color: ThemeColors.textWhite),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Animated ECG Heartbeat Pulse Line ───────────────────────────────
  Widget _buildAnimatedEcg() {
    return AnimatedBuilder(
      animation: Listenable.merge([_mainAnimController, _ecgController]),
      builder: (context, child) {
        return Opacity(
          opacity: _ecgOpacity.value.clamp(0.0, 1.0),
          child: SizedBox(
            width: math.min(520, 88.w),
            height: 6.h,
            child: CustomPaint(
              painter: _EcgPulsePainter(progress: _ecgController.value),
            ),
          ),
        );
      },
    );
  }

  // ── Animated Tagline ────────────────────────────────────────────────
  Widget _buildAnimatedTagline() {
    return AnimatedBuilder(
      animation: _mainAnimController,
      builder: (context, child) {
        return SlideTransition(
          position: _taglineSlide,
          child: Opacity(
            opacity: _taglineOpacity.value.clamp(0.0, 1.0),
            child: Text(
              'Trusted nursing & elder care, at home',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ThemeColors.textFaint,
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Floaty Icon Specification Model ──────────────────────────────────
class _FloatySpec {
  final IconData icon;
  final double left;
  final double size;
  final double speed;

  const _FloatySpec({
    required this.icon,
    required this.left,
    required this.size,
    required this.speed,
  });
}

// ── Custom Painter: ECG Pulse Path Line ──────────────────────────────
class _EcgPulsePainter extends CustomPainter {
  final double progress;

  _EcgPulsePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / 600.0;
    final double scaleY = size.height / 64.0;

    final Path rawPath = Path();
    rawPath.moveTo(0 * scaleX, 32 * scaleY);
    rawPath.lineTo(120 * scaleX, 32 * scaleY);
    rawPath.relativeLineTo(10 * scaleX, -7 * scaleY);
    rawPath.relativeLineTo(9 * scaleX, 7 * scaleY);
    rawPath.lineTo(200 * scaleX, 32 * scaleY);
    rawPath.relativeLineTo(9 * scaleX, -26 * scaleY);
    rawPath.relativeLineTo(11 * scaleX, 52 * scaleY);
    rawPath.relativeLineTo(11 * scaleX, -40 * scaleY);
    rawPath.relativeLineTo(9 * scaleX, 14 * scaleY);
    rawPath.lineTo(330 * scaleX, 32 * scaleY);
    rawPath.relativeLineTo(10 * scaleX, -7 * scaleY);
    rawPath.relativeLineTo(9 * scaleX, 7 * scaleY);
    rawPath.lineTo(430 * scaleX, 32 * scaleY);
    rawPath.relativeLineTo(9 * scaleX, -26 * scaleY);
    rawPath.relativeLineTo(11 * scaleX, 52 * scaleY);
    rawPath.relativeLineTo(11 * scaleX, -40 * scaleY);
    rawPath.relativeLineTo(9 * scaleX, 14 * scaleY);
    rawPath.lineTo(600 * scaleX, 32 * scaleY);

    // 1. Subtle background track (dim amber)
    final Paint trackPaint = Paint()
      ..color = ThemeColors.goldenAmber.withValues(alpha: 0.18)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(rawPath, trackPaint);

    // 2. Animated active traveling pulse segment
    final pathMetrics = rawPath.computeMetrics().toList();
    if (pathMetrics.isEmpty) return;

    final metric = pathMetrics.first;
    final double totalLength = metric.length;

    // Window of active glowing pulse moving along the wave
    const double pulseWindow = 0.38;
    double startFraction = (progress * 1.35) - pulseWindow;
    double endFraction = progress * 1.35;

    startFraction = startFraction.clamp(0.0, 1.0);
    endFraction = endFraction.clamp(0.0, 1.0);

    if (endFraction > startFraction) {
      final double startDist = startFraction * totalLength;
      final double endDist = endFraction * totalLength;
      final Path subPath = metric.extractPath(startDist, endDist);

      // Neon drop shadow / outer blur
      final Paint glowPaint = Paint()
        ..color = ThemeColors.goldenAmber.withValues(alpha: 0.85)
        ..strokeWidth = 4.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);

      canvas.drawPath(subPath, glowPaint);

      // Crisp main golden-amber stroke
      final Paint leadPaint = Paint()
        ..color = ThemeColors.goldenAmber
        ..strokeWidth = 2.6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(subPath, leadPaint);

      // Traveling bright tip dot at the leading edge
      final Tangent? tangent = metric.getTangentForOffset(endDist);
      if (tangent != null && endFraction < 0.98) {
        final Paint dotPaint = Paint()
          ..color = ThemeColors.textWhite
          ..style = PaintingStyle.fill;
        canvas.drawCircle(tangent.position, 2.8, dotPaint);

        final Paint dotGlow = Paint()
          ..color = ThemeColors.goldenAmber.withValues(alpha: 0.9)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
        canvas.drawCircle(tangent.position, 5.0, dotGlow);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EcgPulsePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
