import 'dart:async';
import 'package:eldoriaCare/data_handler/repository.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:eldoriaCare/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:eldoriaCare/data_handler/staff_service.dart';
import 'package:eldoriaCare/model/staff_profile.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/toasty.dart';

class JoiningController extends GetxController {
  static JoiningController get to => Get.find();

  final picker = ImagePicker();

  // ── Step State ─────────────────────────────────────────────
  final currentStep = 0.obs;
  final isSubmitting = false.obs;
  final isSendingOtp = false.obs;
  final isVerifyingOtp = false.obs;
  final isOtpSent = false.obs;
  final isOtpVerified = false.obs;
  final otpCountdown = 0.obs;
  Timer? _resendTimer;

  String? editingId;

  // ── Verification Token ─────────────────────────────────────
  final verificationToken = ''.obs;

  // ── OTP Controllers ────────────────────────────────
  final otpCtrl = TextEditingController();

  // ── Step 1 Form Controllers ────────────────────────────────
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final selectedGender = 'female'.obs;
  final selectedCity = 'Mumbai'.obs;
  final areaCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  // ── Step 2 Form Controllers ────────────────────────────────
  final selectedRole = RxnString('GNM Nurse');
  final qualificationCtrl = TextEditingController();
  final regNoCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final selectedSkills = <String>[].obs;
  final selectedLanguages = <String>[].obs;
  final selectedAvailability = <String>[].obs;

  final emNameCtrl = TextEditingController();
  final emPhoneCtrl = TextEditingController();
  final emRelationCtrl = TextEditingController();

  // ── Notes & Preferences ────────────────────────────────────
  final notesCtrl = TextEditingController();

  // ── Step 3 Documents ───────────────────────────────────────
  final uploadedDocs = <String, Map<String, dynamic>>{}.obs;
  final uploadingKeys = <String, bool>{}.obs;

  // ── Step 4 Declaration ─────────────────────────────────────
  final declarationAgreed = false.obs;

  final List<String> stepTitles = [
    'Your details',
    'Work profile',
    'Documents',
    'Review & submit',
  ];

  @override
  void onInit() {
    super.onInit();
    if (Helper.isTester) {
      phoneCtrl.text = '8126552280';
      loadTestData();
    }
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    otpCtrl.dispose();
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
    notesCtrl.dispose();
    super.onClose();
  }

  void loadTestData() {
    editingId = '';
    isOtpVerified.value = true;
    nameCtrl.text = 'Ajay Rawat';
    emailCtrl.text = 'ajay.rawat@gmail.com';
    phoneCtrl.text = '8126552280';
    dobCtrl.text = '2002-06-15';
    selectedGender.value = 'male';
    selectedCity.value = 'Mumbai';
    areaCtrl.text = 'Kandivali East, Kandivali West';
    addressCtrl.text = 'Flat 402, Gundecha Greens, Mumbai, Maharashtra';

    selectedRole.value = 'GNM Nurse';
    qualificationCtrl.text = 'GNM Nurse';
    regNoCtrl.text = 'MNC-2018-847292';
    experienceCtrl.text = '4 years in ICU and Elder Care';
    selectedSkills.assignAll([
      'Diabetic care',
      'Injections',
      'Post-surgery care',
      'Catheter management',
    ]);
    selectedLanguages.assignAll(['English', 'Hindi', 'Marathi']);
    selectedAvailability.assignAll(['morning', 'night', '24_hour']);

    emNameCtrl.text = 'Anshika Patil';
    emPhoneCtrl.text = '9876543299';
    emRelationCtrl.text = 'Friend';
    notesCtrl.text = 'Preferred location: Western suburbs';

    uploadedDocs['photo'] = {
      'name': 'prerna_profile.jpg',
      'size': 102400,
      'path': '/uploads/staff/photos/prerna_profile.jpg',
      'type': 'image/jpeg',
    };
    uploadedDocs['idProof'] = {
      'name': 'aadhaar_card.pdf',
      'size': 204800,
      'path': '/uploads/staff/docs/aadhaar_card.pdf',
      'type': 'application/pdf',
    };
    uploadedDocs['qualification'] = {
      'name': 'gnm_degree_certificate.pdf',
      'size': 512000,
      'path': '/uploads/staff/docs/gnm_degree_certificate.pdf',
      'type': 'application/pdf',
    };

    declarationAgreed.value = true;
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
    final err = validateCurrentStep();
    if (err != null) {
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
      if (selectedGender.value.isEmpty) {
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
      if (experienceCtrl.text.trim().isEmpty) {
        return 'Enter your experience details.';
      }
      if (selectedSkills.isEmpty) return 'Pick at least one skill.';
      if (selectedLanguages.isEmpty) {
        return 'Pick at least one language you speak.';
      }
      if (selectedAvailability.isEmpty) return 'Pick when you can work.';
      if (emNameCtrl.text.trim().isEmpty) {
        return 'Enter an emergency contact name.';
      }
      final emPhone = emPhoneCtrl.text.replaceAll(RegExp(r'\D'), '');
      if (emPhone.length != 10) {
        return 'Enter a 10-digit emergency contact mobile number.';
      }
      if (emRelationCtrl.text.trim().isEmpty) {
        return 'Enter relationship to emergency contact.';
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

  // ── Build API Payload ──────────────────────────────────────
  Map<String, dynamic> buildPayload() {
    return {
      'verificationToken': verificationToken.value,
      'name': nameCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
      'phone': phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), ''),
      'dob': dobCtrl.text.trim(),
      'gender': selectedGender.value.toLowerCase(),
      'city': selectedCity.value,
      'area': areaCtrl.text.trim(),
      'address': addressCtrl.text.trim(),
      'qualification': qualificationCtrl.text.trim(),
      'regNo': regNoCtrl.text.trim(),
      'experience': experienceCtrl.text.trim(),
      'skills': selectedSkills.toList(),
      'language': selectedLanguages.toList(),
      'availability': selectedAvailability.toList(),
      'emergencyName': emNameCtrl.text.trim(),
      'emergencyPhone': emPhoneCtrl.text.trim().replaceAll(RegExp(r'\D'), ''),
      'emergencyRelation': emRelationCtrl.text.trim(),
      'files': Map<String, dynamic>.from(uploadedDocs),
      'notes': notesCtrl.text.trim(),
    };
  }

  // ── Submit Application ─────────────────────────────────────
  Future<void> submitApplication() async {
    isSubmitting.value = true;
    try {
      final payload = buildPayload();
      Logger.m(tag: 'Staff Register Payload', value: payload);

      final response = await Repository.instance.registerStaff(payload);

      final isSuccess =
          response != null &&
          (response['success'] == true ||
              response['status'] == 'success' ||
              response['data'] != null);

      if (isSuccess) {
        final appId =
            response['data']?['id']?.toString() ??
            response['data']?['staffId']?.toString() ??
            response['id']?.toString() ??
            'app_${DateTime.now().millisecondsSinceEpoch}';

        // Local cache for offline tracking
        final model = StaffModel(
          id: appId,
          staffId:
              response['data']?['staffId']?.toString() ??
              'STF_${DateTime.now().millisecondsSinceEpoch}',
          name: nameCtrl.text.trim(),
          role: selectedRole.value ?? qualificationCtrl.text.trim(),
          phone: phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), ''),
          email: emailCtrl.text.trim(),
          dob: dobCtrl.text.trim(),
          gender: selectedGender.value,
          city: selectedCity.value,
          area: areaCtrl.text.trim(),
          address: addressCtrl.text.trim(),
          qualification: qualificationCtrl.text.trim(),
          regNo: regNoCtrl.text.trim(),
          experience: experienceCtrl.text.trim(),
          skills: selectedSkills.toList(),
          languages: selectedLanguages.toList(),
          availability: selectedAvailability.toList(),
          emergencyName: emNameCtrl.text.trim(),
          emergencyPhone: emPhoneCtrl.text.trim().replaceAll(RegExp(r'\D'), ''),
          emergencyRelation: emRelationCtrl.text.trim(),
          files: Map<String, dynamic>.from(uploadedDocs),
          notes: notesCtrl.text.trim(),
          applied: true,
          approval: 'pending',
          docs: 'pending',
          submittedAt: 'Just now',
        );
        await StaffService.instance.saveApplication(model);

        Toasty.success('Application submitted successfully!');
        Get.offNamed(
          AppRoutes.trackJoiningStatus,
          arguments: {'trackId': appId},
        );
      } else {
        final message =
            response?['message'] ??
            response?['error'] ??
            'Registration failed. Please check your details.';
        Toasty.failed(message.toString());
      }
    } catch (e) {
      Logger.e(tag: 'Register Staff Error', value: e);
      Toasty.failed('Could not submit application: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  void changeNumber() {
    isOtpSent.value = false;
    otpCtrl.clear();
    _resendTimer?.cancel();
    otpCountdown.value = 0;
  }

  void _startCountdown() {
    _resendTimer?.cancel();
    otpCountdown.value = 30;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpCountdown.value > 0) {
        otpCountdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> sendOtp() async {
    final number = phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), '');
    if (number.length != 10) {
      Toasty.failed('Enter a valid 10-digit mobile number');
      return;
    }
    isSendingOtp.value = true;
    try {
      final response = await Repository.instance.sendOtp(
        number,
        'registration',
      );
      if (response == null || response['success'] == false) {
        Toasty.failed(response?['message'] ?? 'Failed to send OTP');
        return;
      } else {
        isOtpSent.value = true;
        _startCountdown();
        if (response['data'] != null) {
          if (response['data']['phone'] != null) {
            phoneCtrl.text = response['data']['phone'].toString();
          }
          if (response['data']['otp'] != null) {
            final otp = response['data']['otp'].toString();
            otpCtrl.text = otp;
            await Clipboard.setData(ClipboardData(text: otp));
            Toasty.success('Demo OTP: $otp (copied to clipboard)');
          } else {
            Toasty.success('OTP sent successfully');
          }
        } else {
          Toasty.success('OTP sent successfully');
        }
      }
    } catch (e) {
      Logger.e(tag: 'Send OTP Error', value: e);
      Toasty.failed('Could not send OTP: $e');
    } finally {
      isSendingOtp.value = false;
    }
  }

  Future<void> verifyOtp() async {
    final number = phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), '');
    final otp = otpCtrl.text.trim();
    if (number.length != 10) {
      Toasty.failed('Enter a valid 10-digit mobile number');
      return;
    }
    if (otp.length != 6) {
      Toasty.failed('Enter a valid 6-digit OTP');
      return;
    }
    isVerifyingOtp.value = true;
    try {
      final response = await Repository.instance.verifyOtp(
        number,
        otp,
        'registration',
      );
      final isSuccess =
          response != null &&
          (response['success'] == true ||
              response['status'] == 'success' ||
              (response['data'] != null &&
                  response['data']['isVerified'] == true));

      if (isSuccess) {
        final token =
            response['data']?['verificationToken']?.toString() ??
            response['verificationToken']?.toString() ??
            '';
        verificationToken.value = token;
        isOtpVerified.value = true;
        _resendTimer?.cancel();
        Toasty.success('Phone verified successfully!');
        currentStep.value = 1;
      } else {
        Toasty.failed(response?['message'] ?? 'Invalid OTP entered');
      }
    } catch (e) {
      Logger.e(tag: 'Error occurred while verifying OTP', value: e);
      Toasty.failed('somethingWentWrong'.t);
    } finally {
      isVerifyingOtp.value = false;
    }
  }
}
