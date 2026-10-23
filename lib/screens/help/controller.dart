import 'dart:convert';
import 'package:eldoriaCare/utils/const.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/logger.dart';
import 'package:eldoriaCare/utils/preference.dart';
import 'package:eldoriaCare/utils/toasty.dart';

class HelpController extends GetxController {
  static HelpController get to => Get.find();

  // ── Text Controllers ────────────────────────────────────────────────────
  final descController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();

  // ── Selections ──────────────────────────────────────────────────────────
  final RxString selectedPatientType = 'Elderly parent'.obs;
  final RxString selectedCity = 'mumbai'.obs;
  final RxString selectedDuration = '1 month or more'.obs;
  final RxString selectedTiming = 'Daytime'.obs;

  // ── Files & Submitting States ───────────────────────────────────────────
  final RxList<HelpFileItem> attachedFiles = <HelpFileItem>[].obs;
  final RxBool isUploading = false.obs;
  final RxBool isSubmitting = false.obs;

  // ── Enquiry Details for Done Screen ─────────────────────────────────────
  final Rxn<HelpEnquiryItem> currentEnquiry = Rxn<HelpEnquiryItem>();
  final RxBool isEnquiryLoading = false.obs;

  // ── Preset Data ─────────────────────────────────────────────────────────
  final List<String> patientTypes = const [
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

  final List<String> durations = const [
    'One visit',
    'A few days',
    '1–2 weeks',
    '1 month or more',
    'Not sure yet',
  ];

  final List<String> timings = const [
    'Morning',
    'Afternoon',
    'Evening',
    'Night',
    'Daytime',
    '24 hours',
    'Flexible',
  ];

  @override
  void onInit() {
    super.onInit();
    _initDefaults();
    final args = Get.arguments;
    if (args != null && args.toString().isNotEmpty) {
      loadEnquiry(args.toString());
    }
  }

  @override
  void onClose() {
    descController.dispose();
    ageController.dispose();
    addressController.dispose();
    super.onClose();
  }

  void _initDefaults() {
    final user = Preference.user.userInfo;
    if (user != null) {
      if (user.city != null && user.city!.trim().isNotEmpty) {
        final c = user.city!.trim().toLowerCase();
        final match = Const.cities.firstWhereOrNull(
          (city) => city.id.toLowerCase() == c || city.name.toLowerCase() == c,
        );
        if (match != null) {
          selectedCity.value = match.id;
        }
      }
      if (user.address != null && user.address!.trim().isNotEmpty) {
        addressController.text = user.address!.trim();
      }
    }
  }

  // ── Helper Getters & Methods ────────────────────────────────────────────
  String cityName(String cityId) {
    final matched = Const.cities.firstWhereOrNull(
      (c) => c.id.toLowerCase() == cityId.toLowerCase() || c.name.toLowerCase() == cityId.toLowerCase(),
    );
    if (matched != null) return matched.name;
    if (cityId.isEmpty) return 'City';
    return cityId[0].toUpperCase() + cityId.substring(1);
  }

  String formatTimestamp(int timestamp) {
    if (timestamp <= 0) return '';
    final d = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('d MMM, h:mm a').format(d);
  }

  String getServiceName(String? id) {
    if (id == null || id.isEmpty) return '';
    const serviceMap = {
      'senior': 'Senior Citizen Care',
      'caregiver': 'Elderly Care',
      'nursing': 'Home Nursing',
      'generalnursing': 'General Nursing Care',
      'icu': 'ICU Care at Home',
      'medication': 'Medication Support',
      'injection': 'Injection Support',
      'wound': 'Wound Dressing',
      'catheter': 'Catheter Care',
      'ryles': 'Ryles Tube Care',
      'vitals': 'Vital Monitoring',
      'livein': 'Live-in Caregiver',
      'bedridden': 'Bedridden Patient Care',
      'dementia': 'Dementia Care',
      'stroke': 'Stroke Patient Care',
      'paralysis': 'Paralysis Care',
      'postsurgery': 'Post-Surgery Care',
      'cancer': 'Cancer Patient Care',
      'palliative': 'Palliative Care',
      'parkinsons': 'Parkinson’s Care',
      'alzheimers': 'Alzheimer’s / Dementia Care',
    };
    return serviceMap[id.toLowerCase()] ?? (id[0].toUpperCase() + id.substring(1));
  }

  void selectPatientType(String type) {
    selectedPatientType.value = type;
  }

  void selectCity(String cityId) {
    selectedCity.value = cityId;
  }

  void selectDuration(String duration) {
    selectedDuration.value = duration;
  }

  void selectTiming(String timing) {
    selectedTiming.value = timing;
  }

  // ── File Attachment Logic ───────────────────────────────────────────────
  Future<void> pickFile() async {
    if (attachedFiles.length >= 3 || isUploading.value) return;

    try {
      isUploading.value = true;
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        final f = result.files.first;
        attachedFiles.add(
          HelpFileItem(
            id: 'f_${DateTime.now().millisecondsSinceEpoch}',
            name: f.name,
            type: f.extension?.toLowerCase() == 'pdf' ? 'application/pdf' : 'image/jpeg',
            size: f.size,
            path: f.path,
          ),
        );
        Toasty.success('File attached');
      }
    } catch (e) {
      Logger.e(tag: 'Pick File Error', value: e);
      Toasty.failed('Could not attach file');
    } finally {
      isUploading.value = false;
    }
  }

  void removeFile(int index) {
    if (index >= 0 && index < attachedFiles.length) {
      attachedFiles.removeAt(index);
    }
  }

  // ── Submission Logic ────────────────────────────────────────────────────
  Future<void> submitHelp() async {
    final desc = descController.text.trim();
    if (desc.length < 10) {
      Toasty.failed('Describe what you need in a few words (at least 10 characters).');
      return;
    }

    if (selectedPatientType.value.isEmpty) {
      Toasty.failed('Select the patient type.');
      return;
    }

    isSubmitting.value = true;

    try {
      final now = DateTime.now();
      final id = 'q_${now.millisecondsSinceEpoch}';
      final code = 'HLP-${now.millisecondsSinceEpoch.toString().substring(7)}';

      final user = Preference.user.userInfo;
      final clientName = user?.name?.trim().isNotEmpty == true ? user!.name!.trim() : 'User';
      final clientPhone = user?.phone?.trim().isNotEmpty == true ? user!.phone!.trim() : '';

      final newEnquiry = HelpEnquiryItem(
        id: id,
        code: code,
        clientName: clientName,
        clientPhone: clientPhone,
        city: selectedCity.value,
        area: addressController.text.trim(),
        address: addressController.text.trim(),
        description: desc,
        patientType: selectedPatientType.value,
        patientAge: ageController.text.trim(),
        duration: selectedDuration.value,
        timing: selectedTiming.value,
        files: List.from(attachedFiles),
        status: 'new',
        history: [
          HistoryEntry(
            status: 'new',
            at: now.millisecondsSinceEpoch,
            by: 'client',
            note: 'Help request submitted',
          ),
        ],
        createdAt: now.millisecondsSinceEpoch,
      );

      // Save enquiry to local storage
      await _saveEnquiry(newEnquiry);

      // Save notification to local storage
      await _saveNotification(
        ClientNotificationItem(
          id: 'n_${now.millisecondsSinceEpoch}',
          to: 'client:$clientPhone',
          title: 'Help request sent',
          body: 'Our care team will call you soon to recommend the right service.',
          enquiryId: id,
          at: now.millisecondsSinceEpoch,
          read: false,
        ),
      );

      currentEnquiry.value = newEnquiry;
      Toasty.success('Request sent to Eldoria care team');

      Get.offNamed(AppRoutes.helpDone, arguments: id);
    } catch (e) {
      Logger.e(tag: 'Submit Help Error', value: e);
      Toasty.failed('Failed to submit request');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> loadEnquiry(String id) async {
    isEnquiryLoading.value = true;
    try {
      final jsonStr = LocalDB.clientEnquiriesJson;
      if (jsonStr.isNotEmpty) {
        final List raw = jsonDecode(jsonStr);
        final list = raw.map((e) => HelpEnquiryItem.fromJson(Map<String, dynamic>.from(e))).toList();
        final match = list.firstWhereOrNull((e) => e.id == id);
        if (match != null) {
          currentEnquiry.value = match;
        }
      }
    } catch (e) {
      Logger.e(tag: 'Load Enquiry Error', value: e);
    } finally {
      isEnquiryLoading.value = false;
    }
  }

  Future<void> _saveEnquiry(HelpEnquiryItem enquiry) async {
    final jsonStr = LocalDB.clientEnquiriesJson;
    final List<HelpEnquiryItem> list = [];
    if (jsonStr.isNotEmpty) {
      final List raw = jsonDecode(jsonStr);
      list.addAll(raw.map((e) => HelpEnquiryItem.fromJson(Map<String, dynamic>.from(e))));
    }
    list.insert(0, enquiry);
    await LocalDB.setClientEnquiriesJson(jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  Future<void> _saveNotification(ClientNotificationItem notification) async {
    final jsonStr = LocalDB.clientNotificationsJson;
    final List<ClientNotificationItem> list = [];
    if (jsonStr.isNotEmpty) {
      final List raw = jsonDecode(jsonStr);
      list.addAll(raw.map((e) => ClientNotificationItem.fromJson(Map<String, dynamic>.from(e))));
    }
    list.insert(0, notification);
    await LocalDB.setClientNotificationsJson(jsonEncode(list.map((e) => e.toJson()).toList()));
  }
}
