import 'package:eldoriaCare/screens/auth/join_staff/controller.dart';
import 'package:eldoriaCare/screens/auth/join_staff/join_staff_screen.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/screens/auth/login/controller.dart';
import 'package:eldoriaCare/screens/auth/login/login_screen.dart';
import 'package:eldoriaCare/screens/auth/track_joining_status/controller.dart';
import 'package:eldoriaCare/screens/auth/track_joining_status/track_application_screen.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/screens/dashboard/dashboard.dart';
import 'package:eldoriaCare/screens/home/controller.dart';

class AppRoutes {
  static const login = '/login';
  static const joinStaff = '/join-staff';
  static const trackJoiningStatus = '/track-application';
  static const home = '/home';

  static final pages = [
    GetPage(
      name: login,
      page: () => LoginScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => LoginController())),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: joinStaff,
      page: () => JoinStaffScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => JoiningController())),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: trackJoiningStatus,
      page: () => const TrackApplicationScreen(),
      binding:
          BindingsBuilder(() => Get.lazyPut(() => JoiningStatusController())),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: home,
      page: () => const Dashboard(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DashboardController());
        Get.lazyPut(() => HomeController());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/dashboard',
      page: () => const Dashboard(),
      binding: BindingsBuilder(() => Get.lazyPut(() => DashboardController())),
      transition: Transition.fadeIn,
    ),
  ];
}
