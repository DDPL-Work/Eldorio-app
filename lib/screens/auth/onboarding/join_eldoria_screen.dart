import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eldoriaCare/data_handler/staff_service.dart';
import 'package:eldoriaCare/screens/auth/onboarding/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/my_button.dart';

class JoinEldoriaScreen extends StatelessWidget {
  const JoinEldoriaScreen({super.key});

  static const List<String> stepTitles = [
    'Your details',
    'Work profile',
    'Documents',
    'Review & submit',
  ];

  static const Color bgColor = ThemeColors.appBackgroundDeep;
  static const Color cardColor = ThemeColors.cardSurface;
  static const Color cardBorderColor = ThemeColors.cardBorder;
  static const Color inputBgColor = ThemeColors.inputBg;
  static const Color inputBorderColor = ThemeColors.lineBorder;
  static const Color textMutedColor = ThemeColors.textMuted;
  static const Color textLabelColor = ThemeColors.textSlateMuted;

  @override
  Widget build(BuildContext context) {
    SizeConfig.initWithContext(context);
    final c = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: bgColor,
      appBar: _buildAppBar(c),
      body: SafeArea(
        child: Column(
          children: [
            // ── Step Progress Indicator ─────────────────────────
            _buildProgressBar(c),

            // ── Step Content Form ───────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 4.8.w, vertical: 2.h),
                child: Obx(() {
                  switch (c.currentStep.value) {
                    case 1:
                      return _buildStep1YourDetails(c, context);
                    case 2:
                      return _buildStep2WorkProfile(c);
                    case 3:
                      return _buildStep3Documents(c);
                    case 4:
                      return _buildStep4Review(c);
                    default:
                      return const SizedBox.shrink();
                  }
                }),
              ),
            ),

            // ── Sticky Bottom Navigation Bar ────────────────────
            _buildBottomBar(c),
          ],
        ),
      ),
    );
  }

  // ── Top Header / App Bar ────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(OnboardingController c) {
    return AppBar(
      backgroundColor: ThemeColors.sceneDarkNavy,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: ThemeColors.textWhite, size: 20.sp),
        onPressed: c.prevStep,
      ),
      title: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              c.editingId != null ? 'Update application' : 'Join Eldoria',
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontWeight: FontWeight.w800,
                fontSize: 18.sp,
              ),
            ),
            Text(
              'Step ${c.currentStep.value} of 4 · ${stepTitles[c.currentStep.value - 1]}',
              style: TextStyle(
                color: ThemeColors.textFaint,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step Progress Indicator ─────────────────────────────────────────
  Widget _buildProgressBar(OnboardingController c) {
    return Obx(
      () => Container(
        height: 0.6.h,
        color: ThemeColors.stepProgressTrack,
        child: Row(
          children: List.generate(4, (index) {
            final isActive = index < c.currentStep.value;
            return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 0.4.w),
                decoration: BoxDecoration(
                  color: isActive
                      ? ThemeColors.goldenAmber
                      : ThemeColors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Step 1: Your Details ────────────────────────────────────────────
  Widget _buildStep1YourDetails(
    OnboardingController c,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          controller: c.nameCtrl,
          label: 'Full name (as on ID)',
          hintText: 'e.g. Sunita Ramesh Patil',
        ),
        14.vs,

        // Mobile Phone with +91 Prefix
        _buildLabel('Mobile number'),
        6.vs,
        Container(
          decoration: BoxDecoration(
            color: inputBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: inputBorderColor),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.6.w, vertical: 1.6.h),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: inputBorderColor),
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
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: '98765 43210',
                    hintStyle: TextStyle(color: ThemeColors.textPlaceholder, fontSize: 14.sp),
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 3.6.w),
                  ),
                ),
              ),
            ],
          ),
        ),
        14.vs,

        _buildTextField(
          controller: c.emailCtrl,
          label: 'Email (optional)',
          hintText: 'e.g. sunita@example.com',
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
                        initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                      );
                      if (picked != null) {
                        c.dobCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.2.w, vertical: 1.6.h),
                      decoration: BoxDecoration(
                        color: inputBgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: inputBorderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              c.dobCtrl.text.isEmpty ? 'Select date' : c.dobCtrl.text,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: c.dobCtrl.text.isEmpty
                                    ? ThemeColors.textPlaceholder
                                    : ThemeColors.textWhite,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.calendar_today_rounded, size: 16.sp, color: textMutedColor),
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
                        color: inputBgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: inputBorderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: c.selectedGender.value,
                          dropdownColor: cardColor,
                          hint: Text(
                            'Select',
                            style: TextStyle(fontSize: 14.sp, color: ThemeColors.textPlaceholder),
                          ),
                          isExpanded: true,
                          style: TextStyle(color: ThemeColors.textWhite, fontSize: 14.sp),
                          items: ['Female', 'Male', 'Other'].map((g) {
                            return DropdownMenuItem(value: g, child: Text(g));
                          }).toList(),
                          onChanged: (val) => c.selectedGender.value = val,
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
                        color: inputBgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: inputBorderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: c.selectedCity.value,
                          dropdownColor: cardColor,
                          isExpanded: true,
                          style: TextStyle(color: ThemeColors.textWhite, fontSize: 14.sp),
                          items: StaffService.defaultCities.map((city) {
                            return DropdownMenuItem(
                              value: city['id'],
                              child: Text(city['name'] ?? ''),
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
                hintText: 'e.g. Andheri West',
              ),
            ),
          ],
        ),
        14.vs,

        // Full Residential Address
        _buildTextField(
          controller: c.addressCtrl,
          label: 'Full address',
          hintText: 'Flat / house no., building name, street, pincode',
          maxLines: 3,
        ),
      ],
    );
  }

  // ── Step 2: Work Profile ────────────────────────────────────
  Widget _buildStep2WorkProfile(OnboardingController c) {
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
                backgroundColor: cardColor,
                labelStyle: TextStyle(
                  color: isSel ? ThemeColors.textWhite : textMutedColor,
                  fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                  fontSize: 13.sp,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSel ? ThemeColors.goldenAmber : cardBorderColor,
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
          hintText: 'e.g. GNM Nursing, 2019',
        ),
        14.vs,

        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: c.regNoCtrl,
                label: 'Council reg. no. (if any)',
                hintText: 'e.g. MNC-204511',
              ),
            ),
            12.hs,
            Expanded(
              child: _buildTextField(
                controller: c.experienceCtrl,
                label: 'Experience (years)',
                hintText: 'e.g. 5',
                keyboardType: TextInputType.number,
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
                backgroundColor: cardColor,
                labelStyle: TextStyle(
                  color: isSel ? ThemeColors.textWhite : textMutedColor,
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12.5.sp,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSel ? ThemeColors.goldenAmber : cardBorderColor,
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
                backgroundColor: cardColor,
                labelStyle: TextStyle(
                  color: isSel ? ThemeColors.textWhite : textMutedColor,
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12.5.sp,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSel ? ThemeColors.goldenAmber : cardBorderColor,
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
            children: StaffService.availabilities.map((avail) {
              final isSel = c.selectedAvailability.contains(avail);
              return FilterChip(
                label: Text(avail),
                selected: isSel,
                onSelected: (selected) {
                  if (selected) {
                    c.selectedAvailability.add(avail);
                  } else {
                    c.selectedAvailability.remove(avail);
                  }
                },
                selectedColor: ThemeColors.chipSelectedBg,
                checkmarkColor: ThemeColors.goldenAmber,
                backgroundColor: cardColor,
                labelStyle: TextStyle(
                  color: isSel ? ThemeColors.textWhite : textMutedColor,
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12.5.sp,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSel ? ThemeColors.goldenAmber : cardBorderColor,
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
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cardBorderColor),
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
                hintText: 'e.g. Ramesh Patil',
              ),
              10.vs,
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: c.emPhoneCtrl,
                      label: 'Mobile',
                      hintText: '10-digit number',
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  10.hs,
                  Expanded(
                    child: _buildTextField(
                      controller: c.emRelationCtrl,
                      label: 'Relation',
                      hintText: 'e.g. Brother, Husband',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Step 3: Documents ───────────────────────────────────────────────
  Widget _buildStep3Documents(OnboardingController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(3.2.w),
          decoration: BoxDecoration(
            color: ThemeColors.infoBoxBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cardBorderColor),
          ),
          child: Row(
            children: [
              Icon(Icons.privacy_tip_outlined, color: ThemeColors.goldenAmber, size: 20.sp),
              10.hs,
              Expanded(
                child: Text(
                  'Upload a clear photo or PDF of each document. Documents are encrypted and visible only to the Eldoria Care Desk.',
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: textMutedColor,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        16.vs,

        // Document Upload Tiles
        ...StaffService.requiredDocs.map((docDef) {
          final key = docDef['key'] as String;
          final label = docDef['label'] as String;
          final hint = docDef['hint'] as String;
          final isReq = docDef['required'] as bool;

          return Obx(() {
            final isUploaded = c.uploadedDocs.containsKey(key);
            final isUploading = c.uploadingKeys[key] == true;
            final uploadedData = c.uploadedDocs[key];

            return Container(
              margin: EdgeInsets.only(bottom: 1.5.h),
              padding: EdgeInsets.all(3.2.w),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isUploaded ? ThemeColors.successGreenBorder : cardBorderColor,
                  width: isUploaded ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  // Icon / Thumbnail preview
                  Container(
                    width: 13.w,
                    height: 13.w,
                    decoration: BoxDecoration(
                      color: isUploaded
                          ? ThemeColors.successGreenBg
                          : ThemeColors.inputBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isUploading
                        ? Center(
                            child: SizedBox(
                              width: 5.w,
                              height: 5.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ThemeColors.goldenAmber,
                              ),
                            ),
                          )
                        : Icon(
                            isUploaded ? Icons.check_circle_rounded : Icons.description_outlined,
                            color: isUploaded ? ThemeColors.successGreen : textMutedColor,
                            size: 26.sp,
                          ),
                  ),
                  12.hs,

                  // Label & Hint
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                color: ThemeColors.textWhite,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                              ),
                            ),
                            6.hs,
                            if (isReq)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 1.6.w, vertical: 0.3.h),
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
                                style: TextStyle(fontSize: 11.sp, color: textMutedColor),
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
                            color: isUploaded ? ThemeColors.successGreen : textMutedColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Upload Button
                  OutlinedButton(
                    onPressed: () => c.pickDocument(key, imageOnly: key == 'photo'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      side: BorderSide(
                        color: isUploaded ? cardBorderColor : ThemeColors.goldenAmber,
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
                        color: isUploaded ? textMutedColor : ThemeColors.goldenAmber,
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
  Widget _buildStep4Review(OnboardingController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Summary Table Card
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cardBorderColor),
          ),
          child: Column(
            children: [
              _buildReviewRow('Name', c.nameCtrl.text),
              _buildReviewRow('Mobile', '+91 ${c.phoneCtrl.text}'),
              if (c.emailCtrl.text.isNotEmpty)
                _buildReviewRow('Email', c.emailCtrl.text),
              _buildReviewRow(
                'Age & Gender',
                '${c.calculatedAge} yrs · ${c.selectedGender.value ?? ''}',
              ),
              _buildReviewRow('Location', '${c.areaCtrl.text}, ${c.selectedCity.value.capitalizeFirst}'),
              _buildReviewRow('Role', '${c.selectedRole.value} · ${c.experienceCtrl.text} yrs exp'),
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
            ],
          ),
        ),
        16.vs,

        // Uploaded Documents Strip
        Container(
          padding: EdgeInsets.all(3.6.w),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cardBorderColor),
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
                    padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.8.h),
                    decoration: BoxDecoration(
                      color: ThemeColors.successGreenBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 14.sp, color: ThemeColors.successGreen),
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
                    onChanged: (val) => c.declarationAgreed.value = val ?? false,
                    activeColor: ThemeColors.goldenAmber,
                    checkColor: ThemeColors.deepNavy,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
                color: textLabelColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Sticky Bar ───────────────────────────────────────────────
  Widget _buildBottomBar(OnboardingController c) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.8.w, vertical: 1.5.h),
      decoration: const BoxDecoration(
        color: ThemeColors.sceneDarkNavy,
        border: Border(
          top: BorderSide(color: cardBorderColor),
        ),
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
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Back', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp)),
              ),
              12.hs,
            ],
            Expanded(
              child: MyButton(
                label: c.currentStep.value == 4
                    ? (c.editingId != null ? 'Resubmit application' : 'Submit application')
                    : 'Continue',
                color: c.currentStep.value == 4 ? ThemeColors.goldenAmber : null,
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
            hintStyle: TextStyle(color: ThemeColors.textPlaceholder, fontSize: 13.5.sp),
            filled: true,
            fillColor: inputBgColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 3.6.w, vertical: 1.5.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: inputBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: inputBorderColor),
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
