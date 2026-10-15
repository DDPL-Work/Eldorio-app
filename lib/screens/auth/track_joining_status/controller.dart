import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/staff_service.dart';
import 'package:eldoriaCare/model/staff_model.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/toasty.dart';

class JoiningStatusController extends GetxController {
  static JoiningStatusController get to =>
      Get.isRegistered<JoiningStatusController>()
          ? Get.find<JoiningStatusController>()
          : Get.put(JoiningStatusController());

  final staffService = StaffService.instance;
  final phoneSearchCtrl = TextEditingController();

  final application = Rxn<StaffModel>();
  final isLoading = true.obs;
  final searchError = RxnString();

  bool get hasApplication => application.value != null;
  String get appBarTitle =>
      hasApplication ? 'My application' : 'Track application';

  @override
  void onInit() {
    super.onInit();
    loadInitialApplication();
  }

  @override
  void onClose() {
    phoneSearchCtrl.dispose();
    super.onClose();
  }

  Future<void> loadInitialApplication() async {
    isLoading.value = true;
    try {
      final args = Get.arguments;
      String? trackId;
      if (args is Map) {
        trackId = args['trackId']?.toString();
      }

      if (trackId != null && trackId.isNotEmpty) {
        application.value = await staffService.getApplicationById(trackId);
      } else {
        application.value = await staffService.getCurrentApplicant();
      }
    } catch (_) {
      // Ignored
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> findApplication() async {
    final rawPhone = phoneSearchCtrl.text.trim();
    if (rawPhone.replaceAll(RegExp(r'\D'), '').length != 10) {
      searchError.value = 'Enter a valid 10-digit mobile number';
      return;
    }

    isLoading.value = true;
    searchError.value = null;

    try {
      final found = await staffService.findApplicationByPhone(rawPhone);
      if (found != null) {
        application.value = found;
      } else {
        searchError.value = 'No application found with this mobile number.';
      }
    } finally {
      isLoading.value = false;
    }
  }

  void editApplication() {
    final app = application.value;
    if (app == null) return;
    Get.toNamed(
      AppRoutes.joinStaff,
      arguments: {'application': app, 'editId': app.id},
    );
  }

  Future<void> signInApproved() async {
    final app = application.value;
    if (app == null) return;
    isLoading.value = true;
    try {
      await staffService.loginAsStaff(app);
      Toasty.success('Welcome to Eldoria Care, ${app.name}!');
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Toasty.failed('Sign in error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void findDifferentApplication() {
    application.value = null;
    phoneSearchCtrl.clear();
    searchError.value = null;
  }

  void startNewApplication() {
    Get.toNamed(AppRoutes.joinStaff);
  }
}
