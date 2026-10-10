import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/booking_model.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/screens/home/visit_details/visit_detail_screen.dart';
import 'package:eldoriaCare/widget/animation/ecg_animation.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = DashboardController.to;

    return Obx(() {
      if (c.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: ThemeColors.goldenAmber),
        );
      }

      final staff = c.currentStaff.value;
      final staffName = staff?.name.split(' ').first ?? 'Staff';
      final staffRole = staff?.role ?? 'Caregiver';
      final staffCity = staff?.city.capitalizeFirst ?? 'Mumbai';
      final initials = staff?.initials ?? 'SC';

      final todayList = c.todayVisits;
      final overdueList = c.overdueVisits;
      final upcomingList = c.upcomingVisits;
      final completedList = c.completedVisits;
      final openReqs = c.openRequests;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroHeader(
            c,
            initials,
            staffRole,
            staffCity,
            staffName,
            todayList.length,
            upcomingList.length,
            completedList.length,
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(4.8.w, 1.5.h, 4.8.w, 3.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (openReqs.isNotEmpty) ...[
                    _buildOpenRequestsBanner(c, openReqs.length, staffCity),
                    2.2.h.vs,
                  ],

                  if (overdueList.isNotEmpty) ...[
                    _buildSectionTitle('OVERDUE'),
                    1.h.vs,
                    ...overdueList.map((b) => _buildVisitCard(b)),
                    2.h.vs,
                  ],

                  if (todayList.isNotEmpty) ...[
                    _buildSectionTitle('TODAY'),
                    1.h.vs,
                    ...todayList.map((b) => _buildVisitCard(b)),
                    2.h.vs,
                  ],

                  if (upcomingList.isNotEmpty) ...[
                    _buildSectionTitle('UPCOMING'),
                    1.h.vs,
                    ...upcomingList.map((b) => _buildVisitCard(b)),
                    2.h.vs,
                  ],

                  if (completedList.isNotEmpty) ...[
                    _buildSectionTitle('RECENTLY COMPLETED'),
                    1.h.vs,
                    ...completedList.map((b) => _buildVisitCard(b)),
                  ],

                  if (overdueList.isEmpty &&
                      todayList.isEmpty &&
                      upcomingList.isEmpty &&
                      completedList.isEmpty)
                    _buildEmptyVisits(),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildHeroHeader(
      DashboardController c,
      String initials,
      String role,
      String city,
      String firstName,
      int todayCount,
      int upcomingCount,
      int completedCount,
      ) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ThemeColors.brandBlueDark, ThemeColors.sceneDarkNavy],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 2.2.h,
              height: 7.5.h,
              child: const EcgWaveAnimation(),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(4.8.w, 1.5.h, 4.8.w, 2.5.h),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(0.8.w),
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: CircleAvatar(
                            radius: 6.2.w,
                            backgroundColor: ThemeColors.skinTone,
                            child: Text(
                              initials,
                              style: TextStyle(
                                color: ThemeColors.chipSelectedBg,
                                fontWeight: FontWeight.w800,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                        3.5.w.hs,

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$role · $city',
                                style: TextStyle(
                                  color: ThemeColors.textFaint,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              0.3.h.vs,
                              Text(
                                'Hi, $firstName',
                                style: TextStyle(
                                  color: ThemeColors.textWhite,
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    2.h.vs,

                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard('$todayCount', 'Today'),
                        ),
                        2.5.w.hs,
                        Expanded(
                          child: _buildMetricCard('$upcomingCount', 'Upcoming'),
                        ),
                        2.5.w.hs,
                        Expanded(
                          child: _buildMetricCard(
                            '$completedCount',
                            'Completed',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: ThemeColors.glassCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ThemeColors.glassCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: ThemeColors.textWhite,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          0.3.h.vs,
          Text(
            label,
            style: TextStyle(
              color: ThemeColors.textFaint,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenRequestsBanner(
      DashboardController c,
      int count,
      String city,
      ) {
    return InkWell(
      onTap: () => c.currentNavIndex.value = 1,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(3.6.w),
        decoration: BoxDecoration(
          color: ThemeColors.goldenAmberBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ThemeColors.goldenAmber, width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.4.w),
              decoration: BoxDecoration(
                color: ThemeColors.goldenAmber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.notifications_active_rounded,
                color: ThemeColors.deepNavy,
                size: 20.sp,
              ),
            ),
            3.w.hs,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count open booking requests in $city',
                    style: TextStyle(
                      color: ThemeColors.textWhite,
                      fontWeight: FontWeight.w800,
                      fontSize: 13.5.sp,
                    ),
                  ),
                  0.3.h.vs,
                  Text(
                    'Confirm, take the visit or assign a colleague',
                    style: TextStyle(
                      color: ThemeColors.goldenAmberLight,
                      fontSize: 11.5.sp,
                    ),
                  ),
                ],
              ),
            ),
            2.w.hs,
            Text(
              'Request received',
              style: TextStyle(
                color: ThemeColors.goldenAmber,
                fontWeight: FontWeight.w700,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: ThemeColors.textSlateMuted,
        fontWeight: FontWeight.w800,
        fontSize: 12.sp,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildVisitCard(BookingModel b) {
    final bool isCompleted = b.isCompleted;

    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? ThemeColors.successGreenBorder
              : ThemeColors.cardBorder,
          width: isCompleted ? 1.0 : 1.0,
        ),
      ),
      child: Material(
        color: ThemeColors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => Get.to(() => VisitDetailScreen(booking: b)),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${b.date} · ${b.time}',
                      style: TextStyle(
                        color: ThemeColors.textWhite,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.5.sp,
                      ),
                    ),
                    _buildStatusPill(b),
                  ],
                ),
                1.h.vs,

                Text(
                  '${b.patientName}, ${b.patientAge}',
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                  ),
                ),
                0.5.h.vs,

                Text(
                  '${b.serviceName} · ${b.plan}',
                  style: TextStyle(
                    color: ThemeColors.textMuted,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                1.h.vs,

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: ThemeColors.textMuted,
                      size: 16.sp,
                    ),
                    1.5.w.hs,
                    Expanded(
                      child: Text(
                        b.address,
                        style: TextStyle(
                          color: ThemeColors.textMuted,
                          fontSize: 12.5.sp,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPill(BookingModel b) {
    if (b.isCompleted) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.6.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: ThemeColors.successGreenBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Completed',
          style: TextStyle(
            color: ThemeColors.successGreen,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.6.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: ThemeColors.badgeStaffAssignedBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Staff assigned',
          style: TextStyle(
            color: ThemeColors.badgeStaffAssignedFg,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
  }

  Widget _buildEmptyVisits() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 36.sp,
            color: ThemeColors.textMuted,
          ),
          1.5.h.vs,
          Text(
            'No visits assigned yet',
            style: TextStyle(
              color: ThemeColors.textWhite,
              fontWeight: FontWeight.w800,
              fontSize: 15.sp,
            ),
          ),
          0.8.h.vs,
          Text(
            'When the care desk assigns you a visit, it will show here with an alert.',
            textAlign: TextAlign.center,
            style: TextStyle(color: ThemeColors.textMuted, fontSize: 12.5.sp),
          ),
        ],
      ),
    );
  }
}
