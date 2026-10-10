import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/staff_model.dart';
import 'package:eldoriaCare/screens/auth/login/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/my_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final LoginController c = Get.put(LoginController());
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.initWithContext(context);

    return Scaffold(
      backgroundColor: ThemeColors.appBackgroundDeep,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── 1. Top Scene Hero Banner (Static / Pinned at top) ────
          _buildHeroScene(context),

          // ── 2. Content Body (Scrollable) ────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // A. Active Application Banner (if applicant has applied)
                    Obx(() {
                      final app = c.activeApplicant.value;
                      if (app != null && app.applied && !app.isApproved) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 1.8.h),
                          child: _buildApplicationStatusCard(app),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    // B. "New to Eldoria?" Card
                    _buildJoinCard(context),

                    2.5.h.vs,

                    // C. Approved Staff Sign In Header
                    _buildSignInHeader(context),

                    1.2.h.vs,

                    // D. Demo Notice Banner
                    _buildDemoNotice(),

                    1.5.h.vs,

                    // E. Staff List or Phone Sign In View
                    Obx(() {
                      if (c.isLoading.value && c.staffList.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: ThemeColors.goldenAmber,
                            ),
                          ),
                        );
                      }

                      if (c.showPhoneLogin.value) {
                        return _buildPhoneLoginForm(context);
                      }

                      return _buildStaffListView(context);
                    }),

                    1.8.h.vs,

                    // F. Secondary Option: Phone / OTP Toggle
                    Obx(() {
                      return Center(
                        child: TextButton(
                          onPressed: () => c.showPhoneLogin.toggle(),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.h,
                            ),
                          ),
                          child: Text(
                            c.showPhoneLogin.value
                                ? 'Pick from approved staff list'
                                : 'Sign in with phone number & OTP',
                            style: TextStyle(
                              color: ThemeColors.textSlateMuted,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),

                    3.h.vs,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Top Scene Hero Banner ───────────────────────────────────────────
  Widget _buildHeroScene(BuildContext context) {
    final mq = MediaQuery.of(context);
    final topPadding = mq.padding.top;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeColors.sceneDarkNavy,
            ThemeColors.brandNavy,
            ThemeColors.brandNavySoft,
          ],
          stops: [0.0, 0.45, 1.0],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(7.w),
          bottomRight: Radius.circular(7.w),
        ),
        boxShadow: const [
          BoxShadow(
            color: ThemeColors.sceneShadow,
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 6.h,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _ReferenceEcgPainter(
                    progress: _pulseController.value,
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              top: topPadding + 1.8.h,
              bottom: 3.8.h,
              left: 5.w,
              right: 5.w,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo with soft pulse glow
                Container(
                  width: 17.w,
                  height: 17.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ThemeColors.textWhite,
                    boxShadow: [
                      BoxShadow(
                        color: ThemeColors.shadowColorDark,
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: ThemeColors.glowAmber,
                        blurRadius: 22,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(1.8.w),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icons/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.medical_services_rounded,
                        color: ThemeColors.brandNavy,
                        size: 8.w,
                      ),
                    ),
                  ),
                ),
                3.5.w.hs,

                // Title & Subtitle matching Reference in Image 1
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Eldoria Staff',
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontSize: 23.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      0.4.h.vs,
                      Text(
                        'For nurses, caregivers & physios',
                        style: TextStyle(
                          color: ThemeColors.goldenAmber,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── "Your Application" Status Card ──────────────────────────────────
  Widget _buildApplicationStatusCard(StaffModel app) {
    Color badgeBg;
    Color badgeFg;
    String badgeText;

    if (app.isApproved) {
      badgeBg = ThemeColors.successGreenBg;
      badgeFg = ThemeColors.successGreen;
      badgeText = 'Approved';
    } else if (app.isChanges) {
      badgeBg = ThemeColors.infoBlueBg;
      badgeFg = ThemeColors.infoBlueFg;
      badgeText = 'Changes requested';
    } else if (app.isRejected) {
      badgeBg = ThemeColors.errorRedBg;
      badgeFg = ThemeColors.errorRedColor;
      badgeText = 'Not approved';
    } else {
      badgeBg = ThemeColors.goldenAmberBg;
      badgeFg = ThemeColors.goldenAmberLight;
      badgeText = 'Under review';
    }

    return InkWell(
      onTap: () => c.goToTrack(app.id),
      borderRadius: BorderRadius.circular(4.w),
      child: Container(
        padding: EdgeInsets.all(3.5.w),
        decoration: BoxDecoration(
          color: ThemeColors.cardSurface,
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(color: ThemeColors.goldenAmber, width: 1.8),
          boxShadow: const [
            BoxShadow(
              color: ThemeColors.glowAmberCard,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 5.5.w,
              backgroundColor: ThemeColors.brandNavy,
              child: Text(
                app.initials,
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                ),
              ),
            ),
            3.w.hs,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your application',
                    style: TextStyle(
                      color: ThemeColors.textWhite,
                      fontWeight: FontWeight.w800,
                      fontSize: 15.sp,
                    ),
                  ),
                  0.3.h.vs,
                  Text(
                    '${app.role} · ${app.cityName}',
                    style: TextStyle(
                      color: ThemeColors.textMuted,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  color: badgeFg,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── "New to Eldoria?" Card ──────────────────────────────────────────
  Widget _buildJoinCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeColors.brandNavy,
            ThemeColors.brandNavySoft,
            ThemeColors.brandBlueDark,
          ],
        ),
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: const [
          BoxShadow(
            color: ThemeColors.shadowColorDark,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Ambient amber corner glow
          Positioned(
            right: -6.w,
            top: -6.w,
            width: 32.w,
            height: 32.w,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    ThemeColors.radialGlowAmber,
                    ThemeColors.transparentColor,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(4.5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New to Eldoria?',
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                0.6.h.vs,
                Text(
                  'Nurses, caregivers and physios can apply in 5 minutes. Fill in your details, upload documents and we review your application.',
                  style: TextStyle(
                    color: ThemeColors.textSoftBlue,
                    fontSize: 13.sp,
                    height: 1.35,
                  ),
                ),
                2.h.vs,

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: c.goToJoin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeColors.goldenAmber,
                          foregroundColor: ThemeColors.accentInk,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 1.6.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        icon: Icon(
                          Icons.add_rounded,
                          size: 4.8.w,
                          color: ThemeColors.accentInk,
                        ),
                        label: Text(
                          'Join as staff',
                          style: TextStyle(
                            color: ThemeColors.accentInk,
                            fontWeight: FontWeight.w800,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    2.5.w.hs,
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => c.goToTrack(),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: ThemeColors.trackButtonBg,
                          side: const BorderSide(
                            color: ThemeColors.whiteBorder25,
                            width: 1.2,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 1.6.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        child: Text(
                          'Track my application',
                          style: TextStyle(
                            color: ThemeColors.textWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Approved Staff Sign In Header ───────────────────────────────────
  Widget _buildSignInHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0.8.h, bottom: 0.3.h),
      child: Text(
        'APPROVED STAFF · SIGN IN',
        style: TextStyle(
          color: ThemeColors.textSlateMuted,
          fontSize: 12.5.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // ── Demo Notice Banner ──────────────────────────────────────────────
  Widget _buildDemoNotice() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: ThemeColors.goldenAmberBg, // Dark warm amber from reference
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Text(
        'Demo mode: pick your name to sign in. Real OTP login comes with the Android build.',
        style: TextStyle(
          color: ThemeColors.goldenAmberLight,
          // Golden amber text from reference
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
      ),
    );
  }

  // ── List of Approved Staff ──────────────────────────────────────────
  Widget _buildStaffListView(BuildContext context) {
    if (c.staffList.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 3.5.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: ThemeColors.cardSurface,
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(color: ThemeColors.cardBorder),
        ),
        child: Column(
          children: [
            Icon(
              Icons.people_outline_rounded,
              size: 10.w,
              color: ThemeColors.textSlateMuted,
            ),
            1.h.vs,
            Text(
              'No approved staff yet',
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
            0.5.h.vs,
            Text(
              'Apply with "Join as staff" above, or add staff in the Admin panel.',
              style: TextStyle(color: ThemeColors.textMuted, fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: c.staffList.length,
      separatorBuilder: (context, index) => 1.h.vs,
      itemBuilder: (context, index) {
        final staff = c.staffList[index];
        return _buildStaffItemTile(staff);
      },
    );
  }

  Widget _buildStaffItemTile(StaffModel staff) {
    return Material(
      color: ThemeColors.cardSurface, // Reference dark navy card
      borderRadius: BorderRadius.circular(4.w),
      child: InkWell(
        onTap: () => c.loginWithStaff(staff),
        borderRadius: BorderRadius.circular(4.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
            border: Border.all(
              color: ThemeColors.cardBorder, // Reference dark line
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              // Avatar with warm skin/amber tone background (--skin: #E7C27F)
              Container(
                width: 11.w,
                height: 11.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors
                      .skinTone, // Warm amber background from reference
                ),
                alignment: Alignment.center,
                child: Text(
                  staff.initials,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15.sp,
                    color:
                        ThemeColors.brandNavy, // Dark navy text from reference
                  ),
                ),
              ),
              3.5.w.hs,

              // Staff Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staff.name,
                      style: TextStyle(
                        color: ThemeColors.textWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.5.sp,
                      ),
                    ),
                    0.3.h.vs,
                    Text(
                      '${staff.role} · ${staff.cityName}${staff.area != null && staff.area!.isNotEmpty ? ' · ${staff.area}' : ''}',
                      style: TextStyle(
                        color: ThemeColors.textMuted,
                        fontSize: 12.5.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Trailing chevron
              Icon(
                Icons.chevron_right_rounded,
                size: 5.5.w,
                color: ThemeColors.textFaint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Phone / OTP Sign In Form ────────────────────────────────────────
  Widget _buildPhoneLoginForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(4.5.w),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Sign in with registered mobile',
            style: TextStyle(
              color: ThemeColors.textWhite,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
          0.5.h.vs,
          Text(
            'Enter the 10-digit mobile number associated with your approved staff profile.',
            style: TextStyle(color: ThemeColors.textMuted, fontSize: 13.sp),
          ),
          2.h.vs,
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.inputBg,
              borderRadius: BorderRadius.circular(3.w),
              border: Border.all(color: ThemeColors.lineBorder),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.5.w,
                    vertical: 1.8.h,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(color: ThemeColors.lineBorder),
                    ),
                  ),
                  child: Text(
                    '+91',
                    style: TextStyle(
                      color: ThemeColors.textWhite,
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: c.phoneCtrl,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: TextStyle(
                      color: ThemeColors.textWhite,
                      fontSize: 15.5.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    decoration: InputDecoration(
                      hintText: '98765 43210',
                      hintStyle: const TextStyle(
                        color: ThemeColors.textSlateMuted,
                      ),
                      counterText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 3.5.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
          1.5.h.vs,
          Obx(() {
            if (!c.isOtpSent.value) {
              return MyButton(
                label: 'Get OTP',
                isLoading: c.isLoading.value,
                onPressed: c.sendOtp,
                variant: ButtonVariant.primary,
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                0.8.h.vs,
                TextField(
                  controller: c.otpCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter OTP',
                    hintStyle: const TextStyle(
                      color: ThemeColors.textSlateMuted,
                    ),
                    counterText: '',
                    filled: true,
                    fillColor: ThemeColors.inputBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3.w),
                      borderSide: const BorderSide(
                        color: ThemeColors.lineBorder,
                      ),
                    ),
                  ),
                ),
                1.5.h.vs,
                MyButton(
                  label: 'Verify & Sign In',
                  isLoading: c.isLoading.value,
                  onPressed: c.verifyOtp,
                ),
                1.h.vs,
                TextButton(
                  onPressed: c.sendOtp,
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: ThemeColors.goldenAmber,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _ReferenceEcgPainter extends CustomPainter {
  final double progress;

  _ReferenceEcgPainter({required this.progress});

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

    // 1. Solid golden baseline wave
    final Paint trackPaint = Paint()
      ..color = ThemeColors.goldenAmber.withValues(alpha: 0.85)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(rawPath, trackPaint);

    // 2. Neon drop-shadow glow behind wave
    final Paint glowPaint = Paint()
      ..color = ThemeColors.goldenAmber.withValues(alpha: 0.45)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    canvas.drawPath(rawPath, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _ReferenceEcgPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
