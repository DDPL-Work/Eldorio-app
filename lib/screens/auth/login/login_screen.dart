import 'package:eldoriaCare/utils/const.dart';
import 'package:eldoriaCare/widget/animation/ecg_animation.dart';
import 'package:eldoriaCare/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/screens/auth/login/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/ticker_text.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController c = Get.isRegistered<LoginController>()
      ? Get.find<LoginController>()
      : Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    SizeConfig.initWithContext(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: ThemeColors.transparentColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: ThemeColors.appBackground,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Hero Scene with ECG & Ticker ──────────────────────────
              _buildHeroScene(),

              // ── Login / OTP Card (overlapping with -32 offset) ─────────
              _buildFormCard(),

              3.h.vs,
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero Scene ────────────────────────────────────────────────────────
  Widget _buildHeroScene() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(6.w, 8.h, 6.w, 7.h),
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
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.sceneShadow,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo with Golden Aura
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeColors.textWhite,
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.goldenAmber.withValues(alpha: 0.35),
                  blurRadius: 22,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: ThemeColors.textWhite.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: EdgeInsets.all(2.w),
            child: ClipOval(
              child: Image.asset(
                'assets/icons/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => const Icon(
                  Icons.favorite_rounded,
                  color: ThemeColors.brandNavy,
                  size: 38,
                ),
              ),
            ),
          ),

          2.5.h.vs,

          Text(
            'Trusted care for your loved ones, at home.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThemeColors.textWhite,
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              shadows: const [
                Shadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),

          1.5.h.vs,

          // Animated Cycling Ticker
          TickerText(
            items: const [
              'Verified nurses & caregivers',
              'Elder care · Physiotherapy · Nursing',
              'Live visit updates on your phone',
              'Care desk on call & WhatsApp',
            ],
            style: TextStyle(
              color: ThemeColors.goldenAmberLight,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),

          2.h.vs,

          // ECG Wave Graphic
          SizedBox(width: 90.w, height: 3.h, child: const EcgWaveAnimation()),
        ],
      ),
    );
  }

  // ── Form Card (Single Obx boundary) ───────────────────────────────────
  Widget _buildFormCard() {
    return Transform.translate(
      offset: const Offset(0, -32),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Container(
          padding: EdgeInsets.all(5.5.w),
          decoration: BoxDecoration(
            color: ThemeColors.cardSurface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: ThemeColors.cardBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Obx(
            () => c.isOtpStep.value ? _buildOtpStep() : _buildDetailsStep(),
          ),
        ),
      ),
    );
  }

  // ── Step 1: Name, Phone, City Details ──────────────────────────────────
  Widget _buildDetailsStep() {
    final bool isSignUp = c.isSignUp.value;
    final bool isLoading = c.isLoading.value;
    final String error = c.errorMessage.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Mode Selector: Log In vs Sign Up
        Container(
          height: 5.h,
          padding: EdgeInsets.all(0.4.h),
          decoration: BoxDecoration(
            color: ThemeColors.surface2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ThemeColors.cardBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => c.setSignUpMode(false),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: !isSignUp
                          ? ThemeColors.goldenAmber
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        color: !isSignUp
                            ? ThemeColors.deepNavy
                            : ThemeColors.textMuted,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => c.setSignUpMode(true),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSignUp
                          ? ThemeColors.goldenAmber
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: isSignUp
                            ? ThemeColors.deepNavy
                            : ThemeColors.textMuted,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        2.h.vs,

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSignUp ? 'Create Account' : 'Welcome Back',
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontSize: 16.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                0.3.h.vs,
                Text(
                  isSignUp
                      ? 'Sign up for Eldoria Care'
                      : 'Log in with mobile OTP',
                  style: TextStyle(
                    color: ThemeColors.textMuted,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ],
        ),

        1.8.h.vs,

        // Optional Name Field for Sign Up
        if (isSignUp) ...[
          Text(
            'Your name',
            style: TextStyle(
              color: ThemeColors.textMuted,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          0.8.h.vs,
          TextField(
            controller: c.nameController,
            style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.5.sp),
            decoration: _inputDecoration(hint: 'e.g. Priya Mehta'),
          ),
          1.8.h.vs,
        ],

        // Phone Field with +91 prefix
        Text(
          'Mobile number',
          style: TextStyle(
            color: ThemeColors.textMuted,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        0.8.h.vs,
        Row(
          children: [
            Container(
              height: 5.8.h,
              padding: EdgeInsets.symmetric(horizontal: 3.5.w),
              decoration: BoxDecoration(
                color: ThemeColors.inputBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ThemeColors.lineBorder),
              ),
              alignment: Alignment.center,
              child: Text(
                '+91',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            2.5.w.hs,
            Expanded(
              child: TextField(
                controller: c.phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 13.5.sp,
                ),
                decoration: _inputDecoration(
                  hint: '98765 43210',
                ).copyWith(counterText: ''),
              ),
            ),
          ],
        ),

        1.8.h.vs,
        if (isSignUp) ...[
          // City Selector Dropdown
          Text(
            'Your city',
            style: TextStyle(
              color: ThemeColors.textMuted,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          0.8.h.vs,
          CityDropdown(
            height: 5.8.h,
            width: double.infinity,
            color: ThemeColors.inputBg,
            selectedCity: c.selectedCity.value,
            onChanged: (val) {
              if (val != null) c.selectedCity.value = val;
            },
          ),
        ],

        if (error.isNotEmpty) ...[
          1.2.h.vs,
          Text(
            error,
            style: TextStyle(
              color: ThemeColors.errorRedColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],

        2.5.h.vs,

        // Submit Button: "Send OTP"
        _buildGradientButton(
          label: 'Send OTP',
          onTap: c.sendOtp,
          isLoading: isLoading,
        ),
      ],
    );
  }

  // ── Step 2: 6-Digit OTP Step ──────────────────────────────────────────
  Widget _buildOtpStep() {
    final bool isLoading = c.isLoading.value;
    final String error = c.errorMessage.value;
    final int resendSeconds = c.resendSeconds.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enter OTP',
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            InkWell(
              onTap: c.changeNumber,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.all(1.w),
                child: Row(
                  children: [
                    const Icon(
                      Icons.edit_rounded,
                      color: ThemeColors.goldenAmber,
                      size: 14,
                    ),
                    1.w.hs,
                    Text(
                      'Edit',
                      style: TextStyle(
                        color: ThemeColors.goldenAmber,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        0.5.h.vs,
        Text(
          'Sent to +91 ${c.phoneController.text.trim()}',
          style: TextStyle(color: ThemeColors.textMuted, fontSize: 12.sp),
        ),

        1.8.h.vs,

        // Notice box
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.2.h),
          decoration: BoxDecoration(
            color: ThemeColors.infoBlueBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ThemeColors.brandBlue.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: ThemeColors.infoBlueFg,
                size: 18,
              ),
              2.5.w.hs,
              Expanded(
                child: Text(
                  'Enter the 6-digit verification code sent to your mobile number.',
                  style: TextStyle(
                    color: ThemeColors.infoBlueFg,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        2.h.vs,

        // OTP Field
        Text(
          '6-digit OTP',
          style: TextStyle(
            color: ThemeColors.textMuted,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        0.8.h.vs,
        TextField(
          controller: c.otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ThemeColors.textWhite,
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 10,
          ),
          decoration: _inputDecoration(
            hint: '••••••',
          ).copyWith(counterText: ''),
        ),

        1.5.h.vs,

        // Resend OTP countdown row
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Didn't receive code? ",
                style: TextStyle(
                  color: ThemeColors.textMuted,
                  fontSize: 11.5.sp,
                ),
              ),
              if (resendSeconds > 0)
                Text(
                  'Resend in ${resendSeconds}s',
                  style: TextStyle(
                    color: ThemeColors.goldenAmberLight,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                )
              else
                InkWell(
                  onTap: isLoading ? null : c.resendOtp,
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      color: ThemeColors.goldenAmber,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ),

        if (error.isNotEmpty) ...[
          1.2.h.vs,
          Text(
            error,
            style: TextStyle(
              color: ThemeColors.errorRedColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],

        2.2.h.vs,

        // Verify button
        _buildGradientButton(
          label: 'Verify & continue',
          onTap: c.verifyOtp,
          isLoading: isLoading,
        ),

        1.2.h.vs,

        // Change number button
        Center(
          child: TextButton(
            onPressed: c.changeNumber,
            child: Text(
              'Change mobile number',
              style: TextStyle(
                color: ThemeColors.goldenAmber,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required String label,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 5.6.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              ThemeColors.goldenAmberLight,
              ThemeColors.goldenAmber,
              ThemeColors.goldenAmberDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.goldenAmber.withValues(alpha: 0.45),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: ThemeColors.deepNavy,
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    color: ThemeColors.deepNavy,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: ThemeColors.textPlaceholder),
      filled: true,
      fillColor: ThemeColors.inputBg,
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ThemeColors.lineBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ThemeColors.lineBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: ThemeColors.goldenAmber,
          width: 1.5,
        ),
      ),
    );
  }
}
