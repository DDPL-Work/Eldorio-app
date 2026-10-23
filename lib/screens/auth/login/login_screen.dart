import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/widget/animation/ecg_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/screens/auth/login/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/my_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final c = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
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
                    // B. "New to Eldoria?" Card
                    _buildJoinCard(),

                    2.5.h.vs,

                    // C. Approved Staff Sign In Header
                    _buildSignInHeader(),

                    Obx(() {
                      if (c.isLoading.value) {
                        return Center(
                          heightFactor: 1.5.h,
                          child: CircularProgressIndicator(
                            color: ThemeColors.goldenAmber,
                          ),
                        );
                      }

                      return _buildPhoneLoginForm();
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
            child: EcgWaveAnimation(),
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

  // ── "New to Eldoria?" Card ──────────────────────────────────────────
  Widget _buildJoinCard() {
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
                  'you can apply in 5 minutes. Fill in your details, upload documents and we review your application.',
                  style: TextStyle(
                    color: ThemeColors.textSoftBlue,
                    fontSize: 13.sp,
                    height: 1.35,
                  ),
                ),
                2.h.vs,

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Get.toNamed(AppRoutes.joinStaff),
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
  Widget _buildSignInHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 0.8.h, bottom: 0.3.h),
      child: Text(
        'SIGN IN AS STAFF',
        style: TextStyle(
          color: ThemeColors.textSlateMuted,
          fontSize: 12.5.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // ── Phone / OTP Sign In Form ────────────────────────────────────────
  Widget _buildPhoneLoginForm() {
    return Column(
      children: [
        2.h.vs,
        Container(
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
                'Sign in with registered number',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
              0.5.h.vs,
              Text(
                'Enter the 10-digit mobile number',
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
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 3.5.w,
                          ),
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
                      onPressed: () => c.verifyOtp(c.phoneCtrl.text.trim()),
                    ),
                    2.h.vs,
                    Center(
                      child: InkWell(
                        onTap: c.sendOtp,
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: ThemeColors.goldenAmber,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),

        3.h.vs,
        Center(
          child: InkWell(
            onTap: () => Get.toNamed(AppRoutes.joinStaff),
            overlayColor: WidgetStatePropertyAll(ThemeColors.transparent),
            child: Text(
              'Join as Staff with phone number & OTP',
              style: TextStyle(
                color: ThemeColors.textSlateMuted,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
