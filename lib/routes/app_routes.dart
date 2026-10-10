import 'package:get/get.dart';
import 'package:eldoriaCare/screens/auth/login/controller.dart';
import 'package:eldoriaCare/screens/auth/login/login_screen.dart';
import 'package:eldoriaCare/screens/auth/onboarding/controller.dart';
import 'package:eldoriaCare/screens/auth/onboarding/join_eldoria_screen.dart';
import 'package:eldoriaCare/screens/auth/onboarding/track_application_screen.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/screens/dashboard/dashboard.dart';
import 'package:eldoriaCare/screens/home/controller.dart';

class AppRoutes {
  static const login = '/login';
  static const joinStaff = '/join-staff';
  static const trackApplication = '/track-application';
  static const home = '/home';

  static final pages = [
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => LoginController())),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: joinStaff,
      page: () => const JoinEldoriaScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => OnboardingController())),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: trackApplication,
      page: () => const TrackApplicationScreen(),
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
