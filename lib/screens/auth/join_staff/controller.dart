import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:eldoriaCare/data_handler/staff_service.dart';
import 'package:eldoriaCare/model/staff_model.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/toasty.dart';

class JoiningController extends GetxController {
  static JoiningController get to => Get.find();

  final staffService = StaffService.instance;
  final picker = ImagePicker();

  // ── Step State ─────────────────────────────────────────────
  final currentStep = 1.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;

  // ── Application ID (if editing existing application) ──────
  String? editingId;

  // ── Step 1 Form Controllers ────────────────────────────────
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final selectedGender = RxnString();
  final selectedCity = 'mumbai'.obs;
  final areaCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  // ── Step 2 Form Controllers ────────────────────────────────
  final selectedRole = RxnString();
  final qualificationCtrl = TextEditingController();
  final regNoCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final selectedSkills = <String>[].obs;
  final selectedLanguages = <String>[].obs;
  final selectedAvailability = <String>[].obs;

  final emNameCtrl = TextEditingController();
  final emPhoneCtrl = TextEditingController();
  final emRelationCtrl = TextEditingController();

  // ── Step 3 Documents ───────────────────────────────────────
  // Map of docKey -> Map with {'name': String, 'size': int, 'path': String}
  final uploadedDocs = <String, Map<String, dynamic>>{}.obs;
  final uploadingKeys = <String, bool>{}.obs;

  // ── Step 4 Declaration ─────────────────────────────────────
  final declarationAgreed = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['application'] is StaffModel) {
      loadFromApplication(args['application'] as StaffModel);
    } else if (args is Map && args['editId'] != null) {
      _loadById(args['editId'].toString());
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    dobCtrl.dispose();
    areaCtrl.dispose();
    addressCtrl.dispose();
    qualificationCtrl.dispose();
    regNoCtrl.dispose();
    experienceCtrl.dispose();
    emNameCtrl.dispose();
    emPhoneCtrl.dispose();
    emRelationCtrl.dispose();
    super.onClose();
  }

  Future<void> _loadById(String id) async {
    final app = await staffService.getApplicationById(id);
    if (app != null) {
      loadFromApplication(app);
    }
  }

  void loadFromApplication(StaffModel app) {
    editingId = app.id;
    nameCtrl.text = app.name;
    phoneCtrl.text = app.phone.replaceAll(RegExp(r'\D'), '');
    emailCtrl.text = app.email ?? '';
    dobCtrl.text = app.dob ?? '';
    selectedGender.value = app.gender;
    selectedCity.value = app.city;
    areaCtrl.text = app.area ?? '';
    addressCtrl.text = app.address ?? '';

    selectedRole.value = app.role;
    qualificationCtrl.text = app.qualification ?? '';
    regNoCtrl.text = app.regNo ?? '';
    experienceCtrl.text = app.experience?.toString() ?? '';
    selectedSkills.assignAll(app.skills);
    selectedLanguages.assignAll(app.languages);
    selectedAvailability.assignAll(app.availability);

    emNameCtrl.text = app.emergencyName ?? '';
    emPhoneCtrl.text = (app.emergencyPhone ?? '').replaceAll(RegExp(r'\D'), '');
    emRelationCtrl.text = app.emergencyRelation ?? '';

    uploadedDocs.clear();
    app.files.forEach((k, v) {
      if (v is Map) {
        uploadedDocs[k] = Map<String, dynamic>.from(v);
      }
    });
  }

  int get calculatedAge {
    if (dobCtrl.text.isEmpty) return 0;
    try {
      final dob = DateTime.parse(dobCtrl.text);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }

  // ── Step Navigation & Validation ───────────────────────────
  void nextStep() {
    errorMessage.value = '';
    final err = validateCurrentStep();
    if (err != null) {
      errorMessage.value = err;
      Toasty.failed(err);
      return;
    }

    if (currentStep.value < 4) {
      currentStep.value++;
    } else {
      submitApplication();
    }
  }

  void prevStep() {
    errorMessage.value = '';
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  String? validateCurrentStep() {
    final step = currentStep.value;

    if (step == 1) {
      if (nameCtrl.text.trim().isEmpty) return 'Enter your full name.';
      final phone = phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
      if (phone.length != 10) return 'Enter a 10-digit mobile number.';
      if (dobCtrl.text.trim().isEmpty) return 'Select your date of birth.';
      final age = calculatedAge;
      if (age < 18 || age > 70) {
        return 'You must be between 18 and 70 years old to apply (current: $age).';
      }
      if (selectedGender.value == null || selectedGender.value!.isEmpty) {
        return 'Select your gender.';
      }
      if (areaCtrl.text.trim().isEmpty) return 'Enter your area / locality.';
      if (addressCtrl.text.trim().isEmpty) return 'Enter your full address.';
    }

    if (step == 2) {
      if (selectedRole.value == null || selectedRole.value!.isEmpty) {
        return 'Select the role you are applying for.';
      }
      if (qualificationCtrl.text.trim().isEmpty) {
        return 'Enter your highest qualification.';
      }
      final exp = int.tryParse(experienceCtrl.text.trim());
      if (exp == null || exp < 0 || exp > 50) {
        return 'Enter valid years of experience (0–50).';
      }
      if (selectedSkills.isEmpty) return 'Pick at least one skill.';
      if (selectedLanguages.isEmpty) {
        return 'Pick at least one language you speak.';
      }
      if (selectedAvailability.isEmpty) return 'Pick when you can work.';
      if (emNameCtrl.text.trim().isEmpty) return 'Enter an emergency contact name.';
      final emPhone = emPhoneCtrl.text.replaceAll(RegExp(r'\D'), '');
      if (emPhone.length != 10) {
        return 'Enter a 10-digit emergency contact mobile number.';
      }
    }

    if (step == 3) {
      // Required docs: photo, idProof, qualification
      for (final docDef in StaffService.requiredDocs) {
        final key = docDef['key'] as String;
        final isReq = docDef['required'] as bool;
        if (isReq && !uploadedDocs.containsKey(key)) {
          return 'Upload: ${docDef['label']}.';
        }
      }
    }

    if (step == 4) {
      if (!declarationAgreed.value) {
        return 'Tick the declaration to submit your application.';
      }
    }

    return null;
  }

  // ── Document Pickers ───────────────────────────────────────
  Future<void> pickDocument(String key, {bool imageOnly = false}) async {
    uploadingKeys[key] = true;
    errorMessage.value = '';

    try {
      if (key == 'photo' || imageOnly) {
        final XFile? file = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
          maxWidth: 1200,
        );
        if (file != null) {
          final size = await file.length();
          uploadedDocs[key] = {
            'name': file.name,
            'size': size,
            'path': file.path,
            'type': 'image/jpeg',
          };
          Toasty.success('Uploaded ${file.name}');
        }
      } else {
        // Can pick either image or PDF
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        );
        if (result != null && result.files.isNotEmpty) {
          final file = result.files.first;
          uploadedDocs[key] = {
            'name': file.name,
            'size': file.size,
            'path': file.path ?? '',
            'type': file.extension == 'pdf' ? 'application/pdf' : 'image/jpeg',
          };
          Toasty.success('Uploaded ${file.name}');
        }
      }
    } catch (e) {
      Toasty.failed('Could not upload file: $e');
    } finally {
      uploadingKeys[key] = false;
    }
  }

  // ── Submit Application ─────────────────────────────────────
  Future<void> submitApplication() async {
    isSubmitting.value = true;
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final isUpdating = editingId != null;
      final appId = editingId ?? 'app_${now.toString().substring(6)}';

      final historyEntry = {
        'status': 'pending',
        'at': now,
        'by': 'applicant',
        'note': isUpdating
            ? 'Application resubmitted with updates'
            : 'Application submitted',
      };

      final newApplication = StaffModel(
        id: appId,
        name: nameCtrl.text.trim(),
        role: selectedRole.value ?? 'Caregiver',
        phone: phoneCtrl.text.replaceAll(RegExp(r'\D'), ''),
        email: emailCtrl.text.trim().isNotEmpty ? emailCtrl.text.trim() : null,
        dob: dobCtrl.text,
        gender: selectedGender.value,
        city: selectedCity.value,
        area: areaCtrl.text.trim(),
        address: addressCtrl.text.trim(),
        qualification: qualificationCtrl.text.trim(),
        regNo: regNoCtrl.text.trim().isNotEmpty ? regNoCtrl.text.trim() : null,
        experience: experienceCtrl.text.trim(),
        skills: selectedSkills.toList(),
        languages: selectedLanguages.toList(),
        availability: selectedAvailability.toList(),
        emergencyName: emNameCtrl.text.trim(),
        emergencyPhone: emPhoneCtrl.text.replaceAll(RegExp(r'\D'), ''),
        emergencyRelation: emRelationCtrl.text.trim(),
        files: Map<String, dynamic>.from(uploadedDocs),
        applied: true,
        approval: 'pending',
        docs: 'pending',
        onDuty: false,
        staffId: 'ljkhlkh'
      );

      await staffService.saveApplication(newApplication);

      Toasty.success(
        isUpdating
            ? 'Application updated successfully!'
            : 'Application submitted to Eldoria Care Desk!',
      );

      // Navigate to Track Application Screen
      Get.offNamed(
        AppRoutes.trackJoiningStatus,
        arguments: {'trackId': appId},
      );
    } catch (e) {
      errorMessage.value = 'Failed to submit application: $e';
      Toasty.failed(errorMessage.value);
    } finally {
      isSubmitting.value = false;
    }
  }
}
