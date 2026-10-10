import 'package:eldoriaCare/screens/alerts/alerts.dart';
import 'package:eldoriaCare/screens/booking_requests/booking_requests.dart';
import 'package:eldoriaCare/screens/home/home.dart';
import 'package:eldoriaCare/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/screens/dashboard/bottom_nav_bar.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: ThemeColors.appBackground,
      body: Obx(() => _buildBody(c)),
      bottomNavigationBar: BottomNavBar(c: c),
    );
  }

  Widget _buildBody(DashboardController c) {
    switch (c.currentNavIndex.value) {
      case 0:
        return const HomeScreen();
      case 1:
        return const BookingRequestsScreen();
      case 2:
        return const AlertsScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}
