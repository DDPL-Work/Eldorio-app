import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/staff_service.dart';
import 'package:eldoriaCare/model/staff_model.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/toasty.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  final staffService = StaffService.instance;

  // ── Observables ───────────────────────────────────────────
  final staffList = <StaffModel>[].obs;
  final activeApplicant = Rxn<StaffModel>();
  final isLoading = false.obs;
  final isOtpSent = false.obs;
  final showPhoneLogin = false.obs;

  // ── Form & Inputs ─────────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  final phoneCtrl = TextEditingController();
  final otpCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    otpCtrl.dispose();
    super.onClose();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final list = await staffService.getApprovedStaffList();
      staffList.assignAll(list);

      final applicant = await staffService.getCurrentApplicant();
      activeApplicant.value = applicant;
    } catch (_) {
      // Graceful fallback
    } finally {
      isLoading.value = false;
    }
  }

  // ── Quick Tap Staff Sign In ────────────────────────────────
  Future<void> loginWithStaff(StaffModel staff) async {
    isLoading.value = true;
    try {
      await staffService.loginAsStaff(staff);
      Toasty.success('Welcome back, ${staff.name}!');
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Toasty.failed('Could not sign in: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Phone / OTP Sign In ────────────────────────────────────
  Future<void> sendOtp() async {
    final raw = phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), '');
    if (raw.length != 10) {
      Toasty.failed('Enter a valid 10-digit mobile number');
      return;
    }

    isLoading.value = true;
    try {
      // Find staff by phone
      final staff = staffList.firstWhereOrNull(
        (s) => s.phone.replaceAll(RegExp(r'\D'), '').endsWith(raw),
      );

      if (staff == null) {
        Toasty.failed(
          'Mobile number not found in approved staff list. Please apply first or check your number.',
        );
        return;
      }

      isOtpSent.value = true;
      otpCtrl.text = '123456'; // Pre-filled demo OTP for ease of test
      Toasty.success('OTP sent to +91 $raw (Demo OTP: 123456)');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    final otp = otpCtrl.text.trim();
    if (otp.length < 4) {
      Toasty.failed('Enter a valid OTP');
      return;
    }

    final raw = phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), '');
    final staff = staffList.firstWhereOrNull(
      (s) => s.phone.replaceAll(RegExp(r'\D'), '').endsWith(raw),
    );

    if (staff != null) {
      await loginWithStaff(staff);
    } else {
      Toasty.failed('Staff record not found');
    }
  }

  // ── Navigation Shortcuts ──────────────────────────────────
  void goToJoin() {
    Get.toNamed(AppRoutes.joinStaff);
  }

  void goToTrack([String? trackId]) {
    Get.toNamed(AppRoutes.trackApplication, arguments: {'trackId': trackId});
  }
}
