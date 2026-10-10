import 'package:eldoriaCare/screens/booking_requests/booking_r_details/booking_request_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/alert_model.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/screens/home/visit_details/visit_detail_screen.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = DashboardController.to;

    return Obx(() {
      final list = c.alerts;

      return SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.8.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header Title & Mark All Read ────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(
                      color: ThemeColors.textWhite,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (list.any((a) => !a.isRead))
                    OutlinedButton(
                      onPressed: c.markAllAlertsRead,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ThemeColors.textWhite,
                        side: const BorderSide(
                          color: ThemeColors.whiteBorder40,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.2.w,
                          vertical: 0.8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Mark all read',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              2.h.vs,

              // ── Notifications List ──────────────────────────────
              if (list.isEmpty)
                _buildEmptyAlerts()
              else
                ...list.map((a) => _buildAlertItem(c, a)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAlertItem(DashboardController c, AlertModel a) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.4.h),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: a.isRead ? ThemeColors.cardBorder : ThemeColors.lineBorder,
          width: 1.0,
        ),
      ),
      child: Material(
        color: ThemeColors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            c.markAlertRead(a);
            if (a.bookingId.isNotEmpty) {
              final b = c.bookings.firstWhereOrNull(
                (item) => item.id == a.bookingId,
              );
              if (b != null) {
                if (b.isRequested || b.isConfirmed) {
                  Get.to(() => BookingRequestDetailScreen(booking: b));
                } else {
                  Get.to(() => VisitDetailScreen(booking: b));
                }
              }
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(3.6.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Avatar
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: ThemeColors.infoBlueBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: ThemeColors.infoBlueFg,
                    size: 18.sp,
                  ),
                ),
                3.w.hs,

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.title,
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontWeight: FontWeight.w800,
                          fontSize: 14.5.sp,
                        ),
                      ),
                      0.4.h.vs,
                      Text(
                        a.body,
                        style: TextStyle(
                          color: ThemeColors.textMuted,
                          fontSize: 12.5.sp,
                          height: 1.35,
                        ),
                      ),
                      0.6.h.vs,
                      Text(
                        a.time,
                        style: TextStyle(
                          color: ThemeColors.textPlaceholder,
                          fontSize: 11.5.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // Unread Indicator Dot
                if (!a.isRead) ...[
                  2.w.hs,
                  Container(
                    margin: EdgeInsets.only(top: 0.6.h),
                    width: 2.w,
                    height: 2.w,
                    decoration: const BoxDecoration(
                      color: ThemeColors.goldenAmber,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyAlerts() {
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
            Icons.notifications_off_outlined,
            size: 36.sp,
            color: ThemeColors.textMuted,
          ),
          1.5.h.vs,
          Text(
            'You\'re all caught up',
            style: TextStyle(
              color: ThemeColors.textWhite,
              fontWeight: FontWeight.w800,
              fontSize: 15.sp,
            ),
          ),
          0.8.h.vs,
          Text(
            'Booking updates and alerts will show here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: ThemeColors.textMuted, fontSize: 12.5.sp),
          ),
        ],
      ),
    );
  }
}
