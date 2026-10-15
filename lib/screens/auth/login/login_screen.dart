import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/client_data_controller.dart';
import 'package:eldoriaCare/screens/auth/login/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/ticker_text.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController c = Get.put(LoginController());
  final ClientDataController clientData = ClientDataController.to;

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
          child: Column(
            children: [
              // ── Hero Scene with ECG & Ticker ──────────────────────────
              _buildHeroScene(context),

              // ── Login / OTP Card (overlapping with -36 offset) ─────────
              _buildFormCard(context),

              3.h.vs,
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero Scene ────────────────────────────────────────────────────────
  Widget _buildHeroScene(BuildContext context) {
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

          // Main Headline: "Trusted care for your loved ones, at home."
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
          SizedBox(
            width: 70.w,
            height: 3.h,
            child: CustomPaint(
              painter: _StaticEcgPainter(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Form Card ─────────────────────────────────────────────────────────
  Widget _buildFormCard(BuildContext context) {
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
            () => c.isOtpStep.value ? _buildOtpStep(context) : _buildDetailsStep(context),
          ),
        ),
      ),
    );
  }

  // ── Step 1: Name, Phone, City Details ──────────────────────────────────
  Widget _buildDetailsStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row with "Use demo account" button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Log in or sign up',
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            InkWell(
              onTap: c.useDemoAccount,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.8.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: ThemeColors.surface2,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ThemeColors.cardBorder),
                ),
                child: Text(
                  'Use demo account',
                  style: TextStyle(
                    color: ThemeColors.goldenAmber,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),

        2.2.h.vs,

        // Name Field
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
                style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.5.sp),
                decoration: _inputDecoration(hint: '98765 43210'),
              ),
            ),
          ],
        ),

        1.8.h.vs,

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
        Obx(
          () => Container(
            height: 5.8.h,
            padding: EdgeInsets.symmetric(horizontal: 3.5.w),
            decoration: BoxDecoration(
              color: ThemeColors.inputBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeColors.lineBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: c.selectedCity.value,
                dropdownColor: ThemeColors.cardSurface,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: ThemeColors.goldenAmber),
                isExpanded: true,
                items: clientData.cities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city.id,
                    child: Text(
                      city.name,
                      style: TextStyle(
                        color: ThemeColors.textWhite,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) c.selectedCity.value = val;
                },
              ),
            ),
          ),
        ),

        if (c.errorMessage.value.isNotEmpty) ...[
          1.2.h.vs,
          Text(
            c.errorMessage.value,
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
        ),
      ],
    );
  }

  // ── Step 2: 6-Digit OTP Step ──────────────────────────────────────────
  Widget _buildOtpStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter OTP',
          style: TextStyle(
            color: ThemeColors.textWhite,
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        0.5.h.vs,
        Text(
          'Sent to +91 ${c.phoneController.text.trim()}',
          style: TextStyle(
            color: ThemeColors.textMuted,
            fontSize: 12.sp,
          ),
        ),

        1.8.h.vs,

        // Notice box matching HTML
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.2.h),
          decoration: BoxDecoration(
            color: ThemeColors.infoBlueBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ThemeColors.brandBlue.withValues(alpha: 0.4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, color: ThemeColors.infoBlueFg, size: 18),
              2.5.w.hs,
              Expanded(
                child: Text(
                  'Demo mode: SMS isn\'t connected yet. Use OTP 123456.',
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
          decoration: _inputDecoration(hint: '••••••').copyWith(
            counterText: '',
          ),
        ),

        if (c.errorMessage.value.isNotEmpty) ...[
          1.2.h.vs,
          Text(
            c.errorMessage.value,
            style: TextStyle(
              color: ThemeColors.errorRedColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],

        2.5.h.vs,

        // Verify button
        _buildGradientButton(
          label: 'Verify & continue',
          onTap: c.verifyOtp,
          isLoading: c.isLoading.value,
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
        borderSide: const BorderSide(color: ThemeColors.goldenAmber, width: 1.5),
      ),
    );
  }
}

class _StaticEcgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / 300.0;
    final double scaleY = size.height / 32.0;

    final Path path = Path();
    path.moveTo(0 * scaleX, 16 * scaleY);
    path.lineTo(60 * scaleX, 16 * scaleY);
    path.relativeLineTo(6 * scaleX, -5 * scaleY);
    path.relativeLineTo(6 * scaleX, 5 * scaleY);
    path.lineTo(100 * scaleX, 16 * scaleY);
    path.relativeLineTo(6 * scaleX, -18 * scaleY);
    path.relativeLineTo(8 * scaleX, 36 * scaleY);
    path.relativeLineTo(8 * scaleX, -26 * scaleY);
    path.relativeLineTo(6 * scaleX, 8 * scaleY);
    path.lineTo(190 * scaleX, 16 * scaleY);
    path.relativeLineTo(6 * scaleX, -5 * scaleY);
    path.relativeLineTo(6 * scaleX, 5 * scaleY);
    path.lineTo(230 * scaleX, 16 * scaleY);
    path.relativeLineTo(6 * scaleX, -18 * scaleY);
    path.relativeLineTo(8 * scaleX, 36 * scaleY);
    path.relativeLineTo(8 * scaleX, -26 * scaleY);
    path.relativeLineTo(6 * scaleX, 8 * scaleY);
    path.lineTo(300 * scaleX, 16 * scaleY);

    final Paint paint = Paint()
      ..color = ThemeColors.goldenAmber.withValues(alpha: 0.5)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
