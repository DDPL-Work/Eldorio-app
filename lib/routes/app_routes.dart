import 'package:get/get.dart';
import 'package:eldoriaCare/screens/alerts/alerts.dart';
import 'package:eldoriaCare/screens/alerts/controller.dart';
import 'package:eldoriaCare/screens/auth/login/controller.dart';
import 'package:eldoriaCare/screens/auth/login/login_screen.dart';
import 'package:eldoriaCare/screens/auth/register/controller.dart';
import 'package:eldoriaCare/screens/auth/register/register_screen.dart';
import 'package:eldoriaCare/screens/book_service/book_service.dart';
import 'package:eldoriaCare/screens/book_service/controller.dart';
import 'package:eldoriaCare/screens/booking_details/booking_detail_screen.dart';
import 'package:eldoriaCare/screens/booking_details/controller.dart';
import 'package:eldoriaCare/screens/bookings/bookings_screen.dart';
import 'package:eldoriaCare/screens/bookings/controller.dart';
import 'package:eldoriaCare/screens/category/category_screen.dart';
import 'package:eldoriaCare/screens/category/controller.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/screens/dashboard/dashboard.dart';
import 'package:eldoriaCare/screens/help/controller.dart';
import 'package:eldoriaCare/screens/help/help_done_screen.dart';
import 'package:eldoriaCare/screens/help/help_screen.dart';
import 'package:eldoriaCare/screens/home/controller.dart';
import 'package:eldoriaCare/screens/profile/controller.dart';
import 'package:eldoriaCare/screens/profile/profile_screen.dart';
import 'package:eldoriaCare/screens/splash/splash.dart';

class AppRoutes {
  // Routes Constants
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const home = '/dashboard';

  static const category = '/category';
  static const book = '/book';
  static const booking = '/booking';
  static const myBookings = '/my-bookings';
  static const help = '/help';
  static const helpDone = '/help-done';
  static const alerts = '/alerts';
  static const profile = '/profile';

  static final pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: login,
      page: () => LoginScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => LoginController())),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: register,
      page: () => RegisterScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => RegisterController())),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: dashboard,
      page: () => const Dashboard(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DashboardController());
        Get.lazyPut(() => HomeController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: category,
      page: () => const CategoryScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => CategoryController())),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: book,
      page: () => const BookServiceScreen(),
      binding: BindingsBuilder(
        () => Get.lazyPut(() => BookServicesController()),
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: booking,
      page: () => const BookingDetailScreen(),
      binding: BindingsBuilder(
        () => Get.lazyPut(() => BookingDetailController()),
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: myBookings,
      page: () => const BookingsScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => BookingsController())),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: help,
      page: () => const HelpScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => HelpController())),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: helpDone,
      page: () => const HelpDoneScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => HelpController())),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: alerts,
      page: () => const AlertsScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => AlertsController())),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => ProfileController())),
      transition: Transition.rightToLeft,
    ),
  ];
}
