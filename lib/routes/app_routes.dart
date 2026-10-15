import 'package:get/get.dart';
import 'package:eldoriaCare/screens/auth/login/controller.dart';
import 'package:eldoriaCare/screens/auth/login/login_screen.dart';
import 'package:eldoriaCare/screens/booking/book_screen.dart';
import 'package:eldoriaCare/screens/booking/booking_detail_screen.dart';
import 'package:eldoriaCare/screens/category/category_screen.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/screens/dashboard/dashboard.dart';
import 'package:eldoriaCare/screens/help/help_done_screen.dart';
import 'package:eldoriaCare/screens/help/help_screen.dart';
import 'package:eldoriaCare/screens/home/controller.dart';

class AppRoutes {
  static const dashboard = '/dashboard';
  static const login = '/login';
  static const home = '/home';

  static const category = '/dashboard/category';
  static const book = '/dashboard/book';
  static const booking = '/dashboard/booking';
  static const help = '/dashboard/help';
  static const helpDone = '/dashboard/helpdone';

  static final pages = [
    GetPage(
      name: login,
      page: () => LoginScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => LoginController())),
      transition: Transition.fadeIn,
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
      name: dashboard,
      page: () => const Dashboard(),
      binding: BindingsBuilder(() => Get.lazyPut(() => DashboardController())),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: category,
      page: () => const CategoryScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: book,
      page: () => const BookScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: booking,
      page: () => const BookingDetailScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: help,
      page: () => const HelpScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: helpDone,
      page: () => const HelpDoneScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
