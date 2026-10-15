import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/client_data_controller.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/screens/alerts/alerts.dart';
import 'package:eldoriaCare/screens/bookings/bookings_screen.dart';
import 'package:eldoriaCare/screens/dashboard/bottom_nav_bar.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/screens/home/home.dart';
import 'package:eldoriaCare/screens/profile/profile_screen.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/celebration_overlay.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.initWithContext(context);
    final c = Get.put(DashboardController());
    final clientData = ClientDataController.to;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: ThemeColors.appBackground,
          body: Obx(() => _buildBody(c)),
          bottomNavigationBar: BottomNavBar(c: c),
        ),

        // Celebration Overlay (Confetti + Checkmark)
        Obx(() {
          final code = clientData.celebratedBookingCode.value;
          if (code == null) return const SizedBox.shrink();

          return CelebrationOverlay(
            bookingCode: code,
            onDismiss: () {
              final activeBooking = clientData.bookings.firstWhereOrNull((b) => b.code == code);
              clientData.celebratedBookingCode.value = null;
              if (activeBooking != null) {
                Get.toNamed('${AppRoutes.dashboard}/booking', arguments: activeBooking.id);
              }
            },
          );
        }),
      ],
    );
  }

  Widget _buildBody(DashboardController c) {
    switch (c.currentNavIndex.value) {
      case 0:
        return const HomeScreen();
      case 1:
        return const BookingsScreen();
      case 2:
        return const AlertsScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}
