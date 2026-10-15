import 'package:get/get.dart';

class DashboardController extends GetxController {
  static DashboardController get to =>
      Get.isRegistered<DashboardController>()
          ? Get.find<DashboardController>()
          : Get.put(DashboardController());


  final currentNavIndex = 0.obs;
}
