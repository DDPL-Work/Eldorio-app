import 'package:eldoriaCare/utils/helper.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/staff_profile.dart';
import 'package:eldoriaCare/utils/toasty.dart';

class ProfileController extends GetxController {
  final isLoading = false.obs;
  final currentStaff = Rxn<StaffModel>();

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      Helper.logOut();
    } catch (e) {
      Toasty.failed('Failed to sign out');
    } finally {
      isLoading.value = false;
    }
  }
}
