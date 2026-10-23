import 'package:eldoriaCare/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eldoriaCare/data_handler/staff_service.dart';
import 'package:eldoriaCare/screens/auth/join_staff/controller.dart';
import 'package:eldoriaCare/widget/my_button.dart';

class JoinStaffScreen extends StatelessWidget {
  JoinStaffScreen({super.key});

  final c = Get.put(JoiningController());

  @override
  Widget build(BuildContext context) {
    SizeConfig.initWithContext(context);
    final c = Get.put(JoiningController());

    return Scaffold(
      backgroundColor: ThemeColors.appBackgroundDeep,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 4.8.w, vertical: 2.h),
                child: Obx(() {
                  switch (c.currentStep.value) {
                    case 0:
                      return _buildStep0PhoneVerification(context);
                    case 1:
                      return _buildStep1YourDetails(context);
                    case 2:
                      return _buildStep2WorkProfile();
                    case 3:
                      return _buildStep3Documents();
                    case 4:
                      return _buildStep4Review();
                    default:
                      return const SizedBox.shrink();
                  }
                }),
              ),
            ),

            // ── Sticky Bottom Navigation Bar (Steps 1 to 4) ─────
            Obx(
              () => c.currentStep.value == 0
                  ? const SizedBox.shrink()
                  : _buildBottomBar(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top Header / App Bar ────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ThemeColors.sceneDarkNavy,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: ThemeColors.textWhite,
          size: 20.sp,
        ),
        onPressed: c.prevStep,
      ),
      title: Obx(() {
        if (c.currentStep.value == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Join Eldoria',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.sp,
                ),
              ),
              Text(
                'Phone verification',
                style: TextStyle(
                  color: ThemeColors.textFaint,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              c.editingId != null && c.editingId!.isNotEmpty
                  ? 'Update application'
                  : 'Join Eldoria',
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontWeight: FontWeight.w800,
                fontSize: 18.sp,
              ),
            ),
            Text(
              'Step ${c.currentStep.value} of 4 · ${c.stepTitles[c.currentStep.value - 1]}',
              style: TextStyle(
                color: ThemeColors.textFaint,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }),
    );
  }

  // ── Step Progress Indicator ─────────────────────────────────────────
  Widget _buildProgressBar() {
    return Obx(() {
      if (c.currentStep.value == 0) {
        return const SizedBox.shrink();
      }

      return Container(
        color: ThemeColors.sceneDarkNavy,
        padding: EdgeInsets.fromLTRB(4.8.w, 0.4.h, 4.8.w, 1.4.h),
        child: Row(
          children: List.generate(c.stepTitles.length, (index) {
            final isActive = index < c.currentStep.value;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 6,
                margin: EdgeInsets.symmetric(horizontal: 0.8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: isActive ? null : const Color(0xFF20324E),
                  gradient: isActive
                      ? const LinearGradient(
                          colors: [
                            ThemeColors.brandBlueLight,
                            ThemeColors.goldenAmber,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  // ── Step 0: Phone Verification (First Step) ─────────────────────────
  Widget _buildStep0PhoneVerification(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        1.h.vs,
        Container(
          padding: EdgeInsets.all(4.8.w),
          decoration: BoxDecoration(
            color: ThemeColors.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ThemeColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 13.w,
                height: 13.w,
                decoration: BoxDecoration(
                  color: ThemeColors.glowAmberCard,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ThemeColors.goldenAmber.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  Icons.phone_android_rounded,
                  color: ThemeColors.goldenAmber,
                  size: 22.sp,
                ),
              ),
              2.h.vs,
              Text(
                'Verify your mobile number',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 17.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              0.8.h.vs,
              Text(
                'Enter your 10-digit mobile number. We will send an OTP to verify your identity before starting your onboarding application.',
                style: TextStyle(
                  color: ThemeColors.textMuted,
                  fontSize: 13.sp,
                  height: 1.35,
                ),
              ),
              2.2.h.vs,

              // Mobile Input Field
              _buildLabel('Mobile number'),
              6.vs,
              Container(
                decoration: BoxDecoration(
                  color: ThemeColors.inputBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ThemeColors.lineBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.6.w,
                        vertical: 1.6.h,
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
                        enabled: !c.isOtpSent.value,
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: '98765 43210',
                          hintStyle: TextStyle(
                            color: ThemeColors.textPlaceholder,
                            fontSize: 14.sp,
                          ),
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 3.6.w,
                          ),
                        ),
                      ),
                    ),
                    if (c.isOtpSent.value)
                      IconButton(
                        tooltip: 'Edit number',
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: ThemeColors.goldenAmber,
                          size: 20,
                        ),
                        onPressed: c.changeNumber,
                      ),
                  ],
                ),
              ),

              // If OTP not yet sent
              if (!c.isOtpSent.value) ...[
                2.2.h.vs,
                MyButton(
                  label: 'Send OTP',
                  isLoading: c.isSendingOtp.value,
                  color: ThemeColors.goldenAmber,
                  onPressed: c.sendOtp,
                ),
              ],

              // If OTP is sent
              if (c.isOtpSent.value) ...[
                2.h.vs,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabel('Enter 6-digit OTP'),
                    TextButton(
                      onPressed: c.changeNumber,
                      child: Text(
                        'Change number',
                        style: TextStyle(
                          color: ThemeColors.goldenAmber,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                6.vs,
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
                    hintText: '• • • • • •',
                    hintStyle: TextStyle(
                      color: ThemeColors.textPlaceholder,
                      letterSpacing: 4,
                      fontSize: 16.sp,
                    ),
                    filled: true,
                    fillColor: ThemeColors.inputBg,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 3.6.w,
                      vertical: 1.5.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: ThemeColors.lineBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: ThemeColors.lineBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: ThemeColors.goldenAmber,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                1.5.h.vs,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Didn\'t receive OTP?',
                      style: TextStyle(
                        color: ThemeColors.textMuted,
                        fontSize: 12.5.sp,
                      ),
                    ),
                    Obx(
                      () => TextButton(
                        onPressed: c.otpCountdown.value == 0 ? c.sendOtp : null,
                        child: Text(
                          c.otpCountdown.value > 0
                              ? 'Resend in ${c.otpCountdown.value}s'
                              : 'Resend OTP',
                          style: TextStyle(
                            color: c.otpCountdown.value == 0
                                ? ThemeColors.goldenAmber
                                : ThemeColors.textMuted,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                1.5.h.vs,
                MyButton(
                  label: 'Verify & Continue',
                  isLoading: c.isVerifyingOtp.value,
                  color: ThemeColors.goldenAmber,
                  onPressed: c.verifyOtp,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ── Step 1: Your Details (User Details) ──────────────────────────────
  Widget _buildStep1YourDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Full Name
        _buildTextField(
          controller: c.nameCtrl,
          label: 'Full name (as on ID)',
          hintText: 'e.g. Prerna Pandey',
        ),
        14.vs,

        // Verified Read-Only Mobile Number Field
        _buildLabel('Mobile number'),
        6.vs,
        Container(
          decoration: BoxDecoration(
            color: ThemeColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ThemeColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.6.w,
                  vertical: 1.6.h,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: ThemeColors.lineBorder),
                  ),
                ),
                child: Text(
                  '+91',
                  style: TextStyle(
                    color: ThemeColors.textMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: c.phoneCtrl,
                  readOnly: true,
                  enableInteractiveSelection: false,
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: '98765 43210',
                    hintStyle: TextStyle(
                      color: ThemeColors.textPlaceholder,
                      fontSize: 14.sp,
                    ),
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 3.6.w),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 3.w),
                padding: EdgeInsets.symmetric(
                  horizontal: 2.4.w,
                  vertical: 0.5.h,
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.successGreenBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ThemeColors.successGreenBorder.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: ThemeColors.successGreen,
                      size: 14.sp,
                    ),
                    4.hs,
                    Text(
                      'Verified',
                      style: TextStyle(
                        color: ThemeColors.successGreen,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        6.vs,
        Text(
          '✓ Mobile number verified via OTP · Locked for this account',
          style: TextStyle(
            color: ThemeColors.successGreen,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        14.vs,

        _buildTextField(
          controller: c.emailCtrl,
          label: 'Email (optional)',
          hintText: 'e.g. prerna.pandey@gmail.com',
          keyboardType: TextInputType.emailAddress,
        ),
        14.vs,

        // DOB & Gender Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DOB Picker
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Date of birth'),
                  6.vs,
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().subtract(
                          const Duration(days: 365 * 24),
                        ),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now().subtract(
                          const Duration(days: 365 * 18),
                        ),
                      );
                      if (picked != null) {
                        c.dobCtrl.text = DateFormat(
                          'yyyy-MM-dd',
                        ).format(picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.2.w,
                        vertical: 1.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.inputBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ThemeColors.lineBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              c.dobCtrl.text.isEmpty
                                  ? 'Select date'
                                  : c.dobCtrl.text,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: c.dobCtrl.text.isEmpty
                                    ? ThemeColors.textPlaceholder
                                    : ThemeColors.textWhite,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 16.sp,
                            color: ThemeColors.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            12.hs,

            // Gender Selector
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Gender'),
                  6.vs,
                  Obx(
                    () => Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.2.w),
                      decoration: BoxDecoration(
                        color: ThemeColors.inputBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ThemeColors.lineBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: c.selectedGender.value,
                          dropdownColor: ThemeColors.cardSurface,
                          hint: Text(
                            'Select',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: ThemeColors.textPlaceholder,
                            ),
                          ),
                          isExpanded: true,
                          style: TextStyle(
                            color: ThemeColors.textWhite,
                            fontSize: 14.sp,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'other',
                              child: Text('Other'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) c.selectedGender.value = val;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        14.vs,

        // City & Area Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('City'),
                  6.vs,
                  Obx(
                    () => Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.2.w),
                      decoration: BoxDecoration(
                        color: ThemeColors.inputBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ThemeColors.lineBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: c.selectedCity.value,
                          dropdownColor: ThemeColors.cardSurface,
                          isExpanded: true,
                          style: TextStyle(
                            color: ThemeColors.textWhite,
                            fontSize: 14.sp,
                          ),
                          items: StaffService.defaultCities.map((city) {
                            final cityName = city['name'] ?? '';
                            return DropdownMenuItem(
                              value: cityName,
                              child: Text(cityName),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) c.selectedCity.value = val;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            12.hs,
            Expanded(
              child: _buildTextField(
                controller: c.areaCtrl,
                label: 'Area / locality',
                hintText: 'e.g. Kandivali East, Kandivali West',
              ),
            ),
          ],
        ),
        14.vs,

        // Full Residential Address
        _buildTextField(
          controller: c.addressCtrl,
          label: 'Full address',
          hintText:
              'Flat 402, Gundecha Greens, Thakur Village Road, Next to NG Suncity...',
          maxLines: 3,
        ),
      ],
    );
  }

  // ── Step 2: Work Profile ────────────────────────────────────
  Widget _buildStep2WorkProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Role Chips
        _buildLabel('Role you\'re applying for'),
        8.vs,
        Obx(
          () => Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: StaffService.roles.map((r) {
              final isSel = c.selectedRole.value == r;
              return ChoiceChip(
                label: Text(r),
                selected: isSel,
                onSelected: (_) => c.selectedRole.value = r,
                selectedColor: ThemeColors.chipSelectedBg,
                backgroundColor: ThemeColors.cardSurface,
                labelStyle: TextStyle(
                  color: isSel ? ThemeColors.textWhite : ThemeColors.textMuted,
                  fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                  fontSize: 13.sp,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSel
                        ? ThemeColors.goldenAmber
                        : ThemeColors.cardBorder,
                    width: isSel ? 1.5 : 1.0,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        16.vs,

        _buildTextField(
          controller: c.qualificationCtrl,
          label: 'Highest qualification',
          hintText: 'e.g. GNM Nurse',
        ),
        14.vs,

        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: c.regNoCtrl,
                label: 'Council reg. no. (if any)',
                hintText: 'e.g. MNC-2018-847292',
              ),
            ),
            12.hs,
            Expanded(
              child: _buildTextField(
                controller: c.experienceCtrl,
                label: 'Experience',
                hintText: 'e.g. 4 years in ICU and Elder Care',
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
        18.vs,

        // Skills (Multi-select)
        _buildLabel('Skills'),
        8.vs,
        Obx(
          () => Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: StaffService.skills.map((skill) {
              final isSel = c.selectedSkills.contains(skill);
              return FilterChip(
                label: Text(skill),
                selected: isSel,
                onSelected: (selected) {
                  if (selected) {
                    c.selectedSkills.add(skill);
                  } else {
                    c.selectedSkills.remove(skill);
                  }
                },
                selectedColor: ThemeColors.chipSelectedBg,
                checkmarkColor: ThemeColors.goldenAmber,
                backgroundColor: ThemeColors.cardSurface,
                labelStyle: TextStyle(
                  color: isSel ? ThemeColors.textWhite : ThemeColors.textMuted,
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12.5.sp,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSel
                        ? ThemeColors.goldenAmber
                        : ThemeColors.cardBorder,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        18.vs,

        // Languages (Multi-select)
        _buildLabel('Languages you speak'),
        8.vs,
        Obx(
          () => Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: StaffService.languages.map((lang) {
              final isSel = c.selectedLanguages.contains(lang);
              return FilterChip(
                label: Text(lang),
                selected: isSel,
                onSelected: (selected) {
                  if (selected) {
                    c.selectedLanguages.add(lang);
                  } else {
                    c.selectedLanguages.remove(lang);
                  }
                },
                selectedColor: ThemeColors.chipSelectedBg,
                checkmarkColor: ThemeColors.goldenAmber,
                backgroundColor: ThemeColors.cardSurface,
                labelStyle: TextStyle(
                  color: isSel ? ThemeColors.textWhite : ThemeColors.textMuted,
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12.5.sp,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSel
                        ? ThemeColors.goldenAmber
                        : ThemeColors.cardBorder,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        18.vs,

        // Available For (Multi-select)
        _buildLabel('Available for'),
        8.vs,
        Obx(
          () => Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: StaffService.availabilityOptions.map((opt) {
              final optId = opt['id']!;
              final optLabel = opt['label']!;
              final isSel = c.selectedAvailability.contains(optId);
              return FilterChip(
                label: Text(optLabel),
                selected: isSel,
                onSelected: (selected) {
                  if (selected) {
                    c.selectedAvailability.add(optId);
                  } else {
                    c.selectedAvailability.remove(optId);
                  }
                },
                selectedColor: ThemeColors.chipSelectedBg,
                checkmarkColor: ThemeColors.goldenAmber,
                backgroundColor: ThemeColors.cardSurface,
                labelStyle: TextStyle(
                  color: isSel ? ThemeColors.textWhite : ThemeColors.textMuted,
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12.5.sp,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSel
                        ? ThemeColors.goldenAmber
                        : ThemeColors.cardBorder,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        20.vs,

        // Emergency Contact Card
        Container(
          padding: EdgeInsets.all(3.6.w),
          decoration: BoxDecoration(
            color: ThemeColors.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ThemeColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Emergency contact',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.sp,
                ),
              ),
              12.vs,
              _buildTextField(
                controller: c.emNameCtrl,
                label: 'Name',
                hintText: 'e.g. Anshika Patil',
              ),
              10.vs,
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: c.emPhoneCtrl,
                      label: 'Mobile',
                      hintText: 'e.g. 9876543299',
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  10.hs,
                  Expanded(
                    child: _buildTextField(
                      controller: c.emRelationCtrl,
                      label: 'Relation',
                      hintText: 'e.g. Frient, Sister, Husband',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        16.vs,

        // Notes & Preferences
        _buildTextField(
          controller: c.notesCtrl,
          label: 'Notes & preferences (optional)',
          hintText: 'e.g. Preferred location: Western suburbs',
          maxLines: 2,
        ),
      ],
    );
  }

  // ── Step 3: Documents ───────────────────────────────────────────────
  Widget _buildStep3Documents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(3.2.w),
          decoration: BoxDecoration(
            color: ThemeColors.infoBoxBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ThemeColors.cardBorder),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.privacy_tip_outlined,
                color: ThemeColors.goldenAmber,
                size: 20,
              ),
              10.hs,
              Expanded(
                child: Text(
                  'Your documents are encrypted and only accessible to the Eldoria clinical review team for verification.',
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: ThemeColors.textLight,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        16.vs,

        ...StaffService.requiredDocs.map((docDef) {
          final key = docDef['key'] as String;
          final label = docDef['label'] as String;
          final hint = docDef['hint'] as String;
          final isReq = docDef['required'] as bool;

          return Obx(() {
            final isUploaded = c.uploadedDocs.containsKey(key);
            final uploadedData = c.uploadedDocs[key];

            return Container(
              margin: EdgeInsets.only(bottom: 1.5.h),
              padding: EdgeInsets.all(3.6.w),
              decoration: BoxDecoration(
                color: ThemeColors.cardSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isUploaded
                      ? ThemeColors.successGreenBorder
                      : ThemeColors.cardBorder,
                  width: isUploaded ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: isUploaded
                          ? ThemeColors.successGreenBg
                          : ThemeColors.surface2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isUploaded
                          ? Icons.check_circle_rounded
                          : (key == 'photo'
                                ? Icons.account_circle_rounded
                                : Icons.description_rounded),
                      color: isUploaded
                          ? ThemeColors.successGreen
                          : ThemeColors.goldenAmber,
                      size: 20.sp,
                    ),
                  ),
                  12.hs,

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: ThemeColors.textWhite,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            6.hs,
                            if (isReq)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 1.8.w,
                                  vertical: 0.2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: ThemeColors.goldenAmberBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Required',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w800,
                                    color: ThemeColors.goldenAmberLight,
                                  ),
                                ),
                              )
                            else
                              Text(
                                'Optional',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: ThemeColors.textMuted,
                                ),
                              ),
                          ],
                        ),
                        3.vs,
                        Text(
                          isUploaded
                              ? '${uploadedData?['name']} · ${((uploadedData?['size'] ?? 1024) / 1024).round()} KB'
                              : hint,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isUploaded
                                ? ThemeColors.successGreen
                                : ThemeColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Upload Button
                  OutlinedButton(
                    onPressed: () =>
                        c.pickDocument(key, imageOnly: key == 'photo'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      side: BorderSide(
                        color: isUploaded
                            ? ThemeColors.cardBorder
                            : ThemeColors.goldenAmber,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isUploaded ? 'Replace' : 'Upload',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        color: isUploaded
                            ? ThemeColors.textMuted
                            : ThemeColors.goldenAmber,
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        }),
      ],
    );
  }

  // ── Step 4: Review & Submit ─────────────────────────────────────────
  Widget _buildStep4Review() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Summary Table Card
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: ThemeColors.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ThemeColors.cardBorder),
          ),
          child: Column(
            children: [
              _buildReviewRow('Name', c.nameCtrl.text),
              _buildReviewRow('Mobile', '+91 ${c.phoneCtrl.text}'),
              if (c.emailCtrl.text.isNotEmpty)
                _buildReviewRow('Email', c.emailCtrl.text),
              _buildReviewRow(
                'Age & Gender',
                '${c.calculatedAge} yrs · ${c.selectedGender.value.capitalizeFirst}',
              ),
              _buildReviewRow(
                'City & Area',
                '${c.selectedCity.value} · ${c.areaCtrl.text}',
              ),
              _buildReviewRow('Address', c.addressCtrl.text),
              _buildReviewRow(
                'Role & Exp.',
                '${c.selectedRole.value} · ${c.experienceCtrl.text}',
              ),
              _buildReviewRow(
                'Qualification',
                '${c.qualificationCtrl.text}${c.regNoCtrl.text.isNotEmpty ? ' · Reg: ${c.regNoCtrl.text}' : ''}',
              ),
              _buildReviewRow('Skills', c.selectedSkills.join(', ')),
              _buildReviewRow('Languages', c.selectedLanguages.join(', ')),
              _buildReviewRow('Available', c.selectedAvailability.join(', ')),
              _buildReviewRow(
                'Emergency',
                '${c.emNameCtrl.text} (${c.emRelationCtrl.text}) · +91 ${c.emPhoneCtrl.text}',
              ),
              if (c.notesCtrl.text.isNotEmpty)
                _buildReviewRow('Notes', c.notesCtrl.text),
              _buildReviewRow('Token', c.verificationToken.value),
            ],
          ),
        ),
        16.vs,

        // Uploaded Documents Strip
        Container(
          padding: EdgeInsets.all(3.6.w),
          decoration: BoxDecoration(
            color: ThemeColors.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ThemeColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Documents (${c.uploadedDocs.length})',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5.sp,
                ),
              ),
              10.vs,
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: c.uploadedDocs.entries.map((entry) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.5.w,
                      vertical: 0.8.h,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.successGreenBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 14.sp,
                          color: ThemeColors.successGreen,
                        ),
                        5.hs,
                        Text(
                          entry.key.capitalizeFirst ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: ThemeColors.successGreen,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        16.vs,

        // Declaration Checkbox
        Obx(
          () => InkWell(
            onTap: () => c.declarationAgreed.toggle(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 0.5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: c.declarationAgreed.value,
                    onChanged: (val) =>
                        c.declarationAgreed.value = val ?? false,
                    activeColor: ThemeColors.goldenAmber,
                    checkColor: ThemeColors.deepNavy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 1.h),
                      child: Text(
                        'I confirm these details and documents are true, and I agree to identity and background verification by Eldoria Care at Home.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: ThemeColors.textSoftBlue,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                color: ThemeColors.textSlateMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: ThemeColors.textWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Sticky Bar ───────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.8.w, vertical: 1.5.h),
      decoration: const BoxDecoration(
        color: ThemeColors.sceneDarkNavy,
        border: Border(top: BorderSide(color: ThemeColors.cardBorder)),
      ),
      child: Obx(
        () => Row(
          children: [
            if (c.currentStep.value > 1) ...[
              OutlinedButton(
                onPressed: c.prevStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: ThemeColors.textWhite,
                  side: const BorderSide(color: ThemeColors.whiteBorder40),
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 1.8.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              12.hs,
            ],
            Expanded(
              child: MyButton(
                label: c.currentStep.value == 4
                    ? (c.editingId != null && c.editingId!.isNotEmpty
                          ? 'Resubmit application'
                          : 'Submit application')
                    : 'Continue',
                color: c.currentStep.value == 4
                    ? ThemeColors.goldenAmber
                    : null,
                isLoading: c.isSubmitting.value,
                onPressed: c.nextStep,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper Widgets ──────────────────────────────────────────────────
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: ThemeColors.textWhite,
        fontSize: 13.5.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        6.vs,
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(color: ThemeColors.textWhite, fontSize: 14.5.sp),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: ThemeColors.textPlaceholder,
              fontSize: 13.5.sp,
            ),
            filled: true,
            fillColor: ThemeColors.inputBg,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 3.6.w,
              vertical: 1.5.h,
            ),
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
          ),
        ),
      ],
    );
  }
}
