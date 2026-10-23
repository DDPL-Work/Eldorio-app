import 'package:eldoriaCare/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/screens/help/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/care_desk_buttons.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HelpController());

    return Scaffold(
      backgroundColor: ThemeColors.appBackground,
      appBar: AppBar(
        backgroundColor: ThemeColors.appBar,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ThemeColors.textWhite,
          ),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Not sure what you need?',
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            0.2.h.vs,
            Text(
              'Tell us about the patient and we\'ll call you.',
              style: TextStyle(color: ThemeColors.textMuted, fontSize: 10.5.sp),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        children: [
          // ── Care Desk Call / WhatsApp Buttons ─────────────────────────────
          const CareDeskButtons(isAccentCall: false),

          2.2.h.vs,

          // ── Requirement Description Textarea ──────────────────────────────
          _buildSectionTitle('Describe the requirement'),
          0.8.h.vs,
          TextField(
            controller: c.descController,
            maxLines: 4,
            style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.sp),
            decoration: _inputDecoration(
              hint:
                  'e.g. My father had a stroke last month and needs help with bathing and walking.',
            ),
          ),

          2.h.vs,

          // ── Patient Type Chips ────────────────────────────────────────────
          _buildSectionTitle('Patient type'),
          1.h.vs,
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: c.patientTypes.map((type) {
                  final isSelected = c.selectedPatientType.value == type;
                  return Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (val) => c.selectPatientType(type),
                      selectedColor: ThemeColors.brandNavy,
                      backgroundColor: ThemeColors.cardSurface,
                      side: BorderSide(
                        color: isSelected
                            ? ThemeColors.goldenAmber
                            : ThemeColors.cardBorder,
                        width: isSelected ? 1.4 : 1,
                      ),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? ThemeColors.goldenAmber
                            : ThemeColors.textLight,
                        fontSize: 11.sp,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          2.h.vs,

          // ── Grid: Age & City ──────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Patient age'),
                    0.8.h.vs,
                    TextField(
                      controller: c.ageController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: ThemeColors.textWhite,
                        fontSize: 13.sp,
                      ),
                      decoration: _inputDecoration(hint: 'e.g. 76'),
                    ),
                  ],
                ),
              ),
              3.w.hs,
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('City'),
                    0.8.h.vs,
                    CityDropdown(
                      height: 5.6.h,
                      width: double.infinity,
                      color: ThemeColors.inputBg,
                      selectedCity: c.selectedCity.value,
                      onChanged: (val) {
                        if (val != null) c.selectCity(val);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          2.h.vs,

          // ── Area / Address ────────────────────────────────────────────────
          _buildSectionTitle('Area / address'),
          0.8.h.vs,
          TextField(
            controller: c.addressController,
            style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.sp),
            decoration: _inputDecoration(
              hint: 'e.g. Lokhandwala, Andheri West',
            ),
          ),

          2.h.vs,

          // ── Duration Chips ────────────────────────────────────────────────
          _buildSectionTitle('How long do you need care?'),
          1.h.vs,
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: c.durations.map((dur) {
                  final isSelected = c.selectedDuration.value == dur;
                  return Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: ChoiceChip(
                      label: Text(dur),
                      selected: isSelected,
                      onSelected: (val) => c.selectDuration(dur),
                      selectedColor: ThemeColors.brandNavy,
                      backgroundColor: ThemeColors.cardSurface,
                      side: BorderSide(
                        color: isSelected
                            ? ThemeColors.goldenAmber
                            : ThemeColors.cardBorder,
                        width: isSelected ? 1.4 : 1,
                      ),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? ThemeColors.goldenAmber
                            : ThemeColors.textLight,
                        fontSize: 11.sp,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          2.h.vs,

          // ── Preferred Timing Chips ────────────────────────────────────────
          _buildSectionTitle('Preferred timing'),
          1.h.vs,
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: c.timings.map((timing) {
                  final isSelected = c.selectedTiming.value == timing;
                  return Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: ChoiceChip(
                      label: Text(timing),
                      selected: isSelected,
                      onSelected: (val) => c.selectTiming(timing),
                      selectedColor: ThemeColors.brandNavy,
                      backgroundColor: ThemeColors.cardSurface,
                      side: BorderSide(
                        color: isSelected
                            ? ThemeColors.goldenAmber
                            : ThemeColors.cardBorder,
                        width: isSelected ? 1.4 : 1,
                      ),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? ThemeColors.goldenAmber
                            : ThemeColors.textLight,
                        fontSize: 11.sp,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          2.5.h.vs,

          // ── Documents / Photo (Optional) ──────────────────────────────────
          _buildSectionTitle('Document or photo (optional)'),
          0.4.h.vs,
          Text(
            'Prescription, discharge summary or a photo of the equipment needed. Up to 3 files.',
            style: TextStyle(color: ThemeColors.textMuted, fontSize: 11.sp),
          ),
          1.4.h.vs,

          // Attached file thumbnails + Add file button
          Obx(
            () => Wrap(
              spacing: 3.w,
              runSpacing: 1.5.h,
              children: [
                ...c.attachedFiles.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final file = entry.value;
                  return _buildFileThumbnail(c, idx, file);
                }),
                if (c.attachedFiles.length < 3) _buildAddFileButton(c),
              ],
            ),
          ),

          10.h.vs,
        ],
      ),

      // ── Sticky Bottom Footer Bar ──────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: ThemeColors.cardSurface,
          border: const Border(
            top: BorderSide(color: ThemeColors.cardBorder, width: 1),
          ),
          boxShadow: const [
            BoxShadow(
              color: ThemeColors.shadowColorDark,
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 5.6.h,
            child: Obx(
              () => ElevatedButton(
                onPressed: c.isSubmitting.value ? null : c.submitHelp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.goldenAmber,
                  foregroundColor: ThemeColors.deepNavy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
                child: c.isSubmitting.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ThemeColors.deepNavy,
                        ),
                      )
                    : Text(
                        'Send to Eldoria care team',
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Presentational UI Helpers ─────────────────────────────────────────────
  Widget _buildFileThumbnail(HelpController c, int index, HelpFileItem file) {
    return Container(
      width: 24.w,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(
            file.type == 'application/pdf'
                ? Icons.picture_as_pdf_rounded
                : Icons.image_rounded,
            color: ThemeColors.goldenAmber,
            size: 32,
          ),
          0.4.h.vs,
          Text(
            file.name,
            style: TextStyle(color: ThemeColors.textWhite, fontSize: 9.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          0.4.h.vs,
          InkWell(
            onTap: () => c.removeFile(index),
            child: Text(
              'Remove',
              style: TextStyle(
                color: ThemeColors.errorRedColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddFileButton(HelpController c) {
    return InkWell(
      onTap: c.pickFile,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 24.w,
        height: 11.h,
        decoration: BoxDecoration(
          color: ThemeColors.inputBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ThemeColors.lineBorder,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => Icon(
                c.isUploading.value
                    ? Icons.hourglass_top_rounded
                    : Icons.upload_file_rounded,
                color: ThemeColors.goldenAmber,
                size: 26,
              ),
            ),
            0.5.h.vs,
            Obx(
              () => Text(
                c.isUploading.value ? 'Uploading…' : 'Add file',
                style: TextStyle(
                  color: ThemeColors.textLight,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: ThemeColors.textWhite,
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: ThemeColors.textPlaceholder),
      filled: true,
      fillColor: ThemeColors.inputBg,
      contentPadding: EdgeInsets.symmetric(horizontal: 3.8.w, vertical: 1.4.h),
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
          width: 1.4,
        ),
      ),
    );
  }
}
