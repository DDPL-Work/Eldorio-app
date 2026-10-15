import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/client_data_controller.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/toasty.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/care_desk_buttons.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final clientData = ClientDataController.to;

  final descController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();

  String selectedPatientType = 'Elderly parent';
  String selectedCity = 'mumbai';
  String selectedDuration = '1 month or more';
  String selectedTiming = 'Daytime';

  final List<HelpFileItem> attachedFiles = [];
  bool isUploading = false;
  bool isSubmitting = false;

  final List<String> patientTypes = [
    'Elderly parent',
    'Bedridden patient',
    'After surgery / hospital',
    'Stroke / paralysis',
    'Dementia / memory loss',
    'Newborn / baby',
    'New mother',
    'Needs medical equipment',
    'Other',
  ];

  final List<String> durations = [
    'One visit',
    'A few days',
    '1–2 weeks',
    '1 month or more',
    'Not sure yet',
  ];

  final List<String> timings = [
    'Morning',
    'Afternoon',
    'Evening',
    'Night',
    'Daytime',
    '24 hours',
    'Flexible',
  ];

  @override
  void initState() {
    super.initState();
    selectedCity = clientData.clientCity.value;
    addressController.text = clientData.clientAddress.value;
  }

  @override
  void dispose() {
    descController.dispose();
    ageController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    if (attachedFiles.length >= 3 || isUploading) return;

    try {
      setState(() => isUploading = true);
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        final f = result.files.first;
        setState(() {
          attachedFiles.add(
            HelpFileItem(
              id: 'f_${DateTime.now().millisecondsSinceEpoch}',
              name: f.name,
              type: f.extension == 'pdf' ? 'application/pdf' : 'image/jpeg',
              size: f.size,
              path: f.path,
            ),
          );
        });
        Toasty.success('File attached');
      }
    } catch (_) {
      Toasty.failed('Could not attach file');
    } finally {
      if (mounted) setState(() => isUploading = false);
    }
  }

  Future<void> _submitHelp() async {
    final desc = descController.text.trim();
    if (desc.length < 10) {
      Toasty.failed('Describe what you need in a few words (at least 10 characters).');
      return;
    }

    if (selectedPatientType.isEmpty) {
      Toasty.failed('Select the patient type.');
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final id = await clientData.createHelpRequest(
        description: desc,
        patientType: selectedPatientType,
        patientAge: ageController.text.trim(),
        city: selectedCity,
        address: addressController.text.trim(),
        duration: selectedDuration,
        timing: selectedTiming,
        files: attachedFiles,
      );

      Get.offNamed('${AppRoutes.dashboard}/helpdone', arguments: id);
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.appBackground,
      appBar: AppBar(
        backgroundColor: ThemeColors.appBar,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ThemeColors.textWhite),
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
              style: TextStyle(
                color: ThemeColors.textMuted,
                fontSize: 10.5.sp,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        children: [
          // Care Desk Call / WhatsApp Buttons
          const CareDeskButtons(isAccentCall: false),

          2.2.h.vs,

          // Requirement Description Textarea
          _buildSectionTitle('Describe the requirement'),
          0.8.h.vs,
          TextField(
            controller: descController,
            maxLines: 4,
            style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.sp),
            decoration: _inputDecoration(
              hint: 'e.g. My father had a stroke last month and needs help with bathing and walking.',
            ),
          ),

          2.h.vs,

          // Patient Type Chips
          _buildSectionTitle('Patient type'),
          1.h.vs,
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: patientTypes.map((type) {
              final isSelected = selectedPatientType == type;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (val) {
                  setState(() => selectedPatientType = type);
                },
                selectedColor: ThemeColors.brandNavy,
                backgroundColor: ThemeColors.cardSurface,
                side: BorderSide(
                  color: isSelected ? ThemeColors.goldenAmber : ThemeColors.cardBorder,
                  width: isSelected ? 1.4 : 1,
                ),
                labelStyle: TextStyle(
                  color: isSelected ? ThemeColors.goldenAmber : ThemeColors.textLight,
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              );
            }).toList(),
          ),

          2.h.vs,

          // Grid: Age & City
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
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.sp),
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
                    Container(
                      height: 5.6.h,
                      padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                      decoration: BoxDecoration(
                        color: ThemeColors.inputBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ThemeColors.lineBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCity,
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
                            if (val != null) setState(() => selectedCity = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          2.h.vs,

          // Area / Address
          _buildSectionTitle('Area / address'),
          0.8.h.vs,
          TextField(
            controller: addressController,
            style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.sp),
            decoration: _inputDecoration(hint: 'e.g. Lokhandwala, Andheri West'),
          ),

          2.h.vs,

          // Duration Chips
          _buildSectionTitle('How long do you need care?'),
          1.h.vs,
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: durations.map((dur) {
              final isSelected = selectedDuration == dur;
              return ChoiceChip(
                label: Text(dur),
                selected: isSelected,
                onSelected: (val) {
                  setState(() => selectedDuration = dur);
                },
                selectedColor: ThemeColors.brandNavy,
                backgroundColor: ThemeColors.cardSurface,
                side: BorderSide(
                  color: isSelected ? ThemeColors.goldenAmber : ThemeColors.cardBorder,
                  width: isSelected ? 1.4 : 1,
                ),
                labelStyle: TextStyle(
                  color: isSelected ? ThemeColors.goldenAmber : ThemeColors.textLight,
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              );
            }).toList(),
          ),

          2.h.vs,

          // Preferred Timing Chips
          _buildSectionTitle('Preferred timing'),
          1.h.vs,
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: timings.map((timing) {
              final isSelected = selectedTiming == timing;
              return ChoiceChip(
                label: Text(timing),
                selected: isSelected,
                onSelected: (val) {
                  setState(() => selectedTiming = timing);
                },
                selectedColor: ThemeColors.brandNavy,
                backgroundColor: ThemeColors.cardSurface,
                side: BorderSide(
                  color: isSelected ? ThemeColors.goldenAmber : ThemeColors.cardBorder,
                  width: isSelected ? 1.4 : 1,
                ),
                labelStyle: TextStyle(
                  color: isSelected ? ThemeColors.goldenAmber : ThemeColors.textLight,
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              );
            }).toList(),
          ),

          2.5.h.vs,

          // Documents / Photo (Optional)
          _buildSectionTitle('Document or photo (optional)'),
          0.4.h.vs,
          Text(
            'Prescription, discharge summary or a photo of the equipment needed. Up to 3 files.',
            style: TextStyle(color: ThemeColors.textMuted, fontSize: 11.sp),
          ),
          1.4.h.vs,

          // Attached file thumbnails + add file button
          Wrap(
            spacing: 3.w,
            runSpacing: 1.5.h,
            children: [
              ...attachedFiles.asMap().entries.map((entry) {
                final idx = entry.key;
                final file = entry.value;

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
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontSize: 9.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      0.4.h.vs,
                      InkWell(
                        onTap: () {
                          setState(() => attachedFiles.removeAt(idx));
                        },
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
              }),

              if (attachedFiles.length < 3)
                InkWell(
                  onTap: _pickFile,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 24.w,
                    height: 11.h,
                    decoration: BoxDecoration(
                      color: ThemeColors.inputBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ThemeColors.lineBorder, style: BorderStyle.solid),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isUploading ? Icons.hourglass_top_rounded : Icons.upload_file_rounded,
                          color: ThemeColors.goldenAmber,
                          size: 26,
                        ),
                        0.5.h.vs,
                        Text(
                          isUploading ? 'Uploading…' : 'Add file',
                          style: TextStyle(
                            color: ThemeColors.textLight,
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          10.h.vs,
        ],
      ),

      // Sticky Bottom Footer Bar
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: ThemeColors.cardSurface,
          border: const Border(
            top: BorderSide(color: ThemeColors.cardBorder, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.shadowColorDark,
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 5.6.h,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : _submitHelp,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.goldenAmber,
                foregroundColor: ThemeColors.deepNavy,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 4,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: ThemeColors.deepNavy),
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
        borderSide: const BorderSide(color: ThemeColors.goldenAmber, width: 1.4),
      ),
    );
  }
}
