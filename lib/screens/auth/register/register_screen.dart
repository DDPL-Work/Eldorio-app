import 'package:eldoriaCare/utils/const.dart';
import 'package:eldoriaCare/widget/animation/ecg_animation.dart';
import 'package:eldoriaCare/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/screens/auth/register/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController c = Get.isRegistered<RegisterController>()
      ? Get.find<RegisterController>()
      : Get.put(RegisterController());

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
              // ── Hero Scene ──────────────────────────────────────────
              _buildHeroScene(),

              // ── Registration Form Card ──────────────────────────────
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
      padding: EdgeInsets.fromLTRB(6.w, 7.h, 6.w, 6.h),
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
          // Back button and title bar
          Row(
            children: [
              InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: ThemeColors.surface2,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ThemeColors.cardBorder),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: ThemeColors.textWhite,
                    size: 16,
                  ),
                ),
              ),
              3.w.hs,
              Text(
                'Complete Registration',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          2.h.vs,

          // Logo with Golden Aura
          Container(
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeColors.textWhite,
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.goldenAmber.withValues(alpha: 0.35),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: EdgeInsets.all(1.5.w),
            child: ClipOval(
              child: Image.asset(
                'assets/icons/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => const Icon(
                  Icons.favorite_rounded,
                  color: ThemeColors.brandNavy,
                  size: 32,
                ),
              ),
            ),
          ),

          1.5.h.vs,

          Text(
            'Welcome to Eldoria Care',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThemeColors.textWhite,
              fontSize: 19.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),

          0.6.h.vs,

          Text(
            'Tell us your location to connect you with trusted caregivers.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThemeColors.goldenAmberLight,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          1.8.h.vs,

          // ECG Wave Graphic
          SizedBox(width: 80.w, height: 2.5.h, child: EcgWaveAnimation()),
        ],
      ),
    );
  }

  // ── Form Card ─────────────────────────────────────────────────────────
  Widget _buildFormCard() {
    return Transform.translate(
      offset: const Offset(0, -28),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Verified Phone Chip
              Obx(
                () => Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.5.w,
                    vertical: 1.2.h,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.successGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ThemeColors.successGreen.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: ThemeColors.successGreen,
                        size: 20,
                      ),
                      2.5.w.hs,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verified Mobile Number',
                              style: TextStyle(
                                color: ThemeColors.successGreen,
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '+91 ${c.phone.value}',
                              style: TextStyle(
                                color: ThemeColors.textWhite,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              2.2.h.vs,

              // Full Name Field (Optional / Personalized)
              Text(
                'Full name',
                style: TextStyle(
                  color: ThemeColors.textMuted,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              0.8.h.vs,
              TextField(
                controller: c.nameController,
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 13.5.sp,
                ),
                decoration: _inputDecoration(hint: 'e.g. Priya Mehta'),
              ),

              1.8.h.vs,

              // City Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'City *',
                    style: TextStyle(
                      color: ThemeColors.textMuted,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Select or type',
                    style: TextStyle(
                      color: ThemeColors.goldenAmber,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              0.8.h.vs,
              Obx(
                () => CityDropdown(
                  height: 5.8.h,
                  width: double.infinity,
                  color: ThemeColors.inputBg,
                  selectedCity: c.selectedCity.value,
                  onChanged: (val) {
                    if (val != null) c.selectedCity.value = val;
                  },
                ),
              ),

              1.8.h.vs,

              // Area Field *
              Text(
                'Area / Locality *',
                style: TextStyle(
                  color: ThemeColors.textMuted,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              0.8.h.vs,
              TextField(
                controller: c.areaController,
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 13.5.sp,
                ),
                decoration: _inputDecoration(
                  hint: 'e.g. Karanpur, Rajpur Road',
                ),
              ),

              Obx(() {
                if (c.errorMessage.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.only(top: 1.5.h),
                  child: Text(
                    c.errorMessage.value,
                    style: TextStyle(
                      color: ThemeColors.errorRedColor,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),

              2.8.h.vs,

              // Register Button
              Obx(
                () => _buildGradientButton(
                  label: 'Complete Registration',
                  onTap: c.registerUser,
                  isLoading: c.isLoading.value,
                ),
              ),
            ],
          ),
        ),
      ),
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
