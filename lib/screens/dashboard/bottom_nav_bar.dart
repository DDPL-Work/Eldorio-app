import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/client_data_controller.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class BottomNavBar extends StatelessWidget {
  final DashboardController c;

  const BottomNavBar({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    final clientData = ClientDataController.to;

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: ThemeColors.cardSurface,
          border: Border(
            top: BorderSide(color: ThemeColors.cardBorder, width: 0.2.w),
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.shadowColorDark,
              blurRadius: 4.w,
              offset: Offset(0, -1.w),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 7.2.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                  badgeCount: 0,
                ),
                _buildNavItem(
                  icon: Icons.calendar_month_rounded,
                  label: 'Bookings',
                  index: 1,
                  badgeCount: 0,
                ),
                _buildNavItem(
                  icon: Icons.notifications_rounded,
                  label: 'Alerts',
                  index: 2,
                  badgeCount: clientData.unreadNotificationsCount,
                ),
                _buildNavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  index: 3,
                  badgeCount: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required int badgeCount,
  }) {
    final bool isActive = c.currentNavIndex.value == index;

    return Expanded(
      child: InkWell(
        onTap: () => c.currentNavIndex.value = index,
        splashColor: ThemeColors.transparent,
        highlightColor: ThemeColors.transparent,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Top Active Indicator Pill
            if (isActive)
              Container(
                height: 0.35.h,
                width: 8.w,
                decoration: BoxDecoration(
                  color: ThemeColors.goldenAmber,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      icon,
                      color: isActive
                          ? ThemeColors.goldenAmber
                          : ThemeColors.textMuted,
                      size: 6.w,
                    ),
                    if (badgeCount > 0)
                      Positioned(
                        right: -2.w,
                        top: -0.6.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.2.w,
                            vertical: 0.1.h,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 4.2.w,
                            minHeight: 4.2.w,
                          ),
                          decoration: const BoxDecoration(
                            color: ThemeColors.goldenAmber,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$badgeCount',
                            style: TextStyle(
                              color: ThemeColors.deepNavy,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                0.4.h.vs,
                Text(
                  label,
                  style: TextStyle(
                    color: isActive
                        ? ThemeColors.goldenAmber
                        : ThemeColors.textMuted,
                    fontSize: 11.5.sp,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
