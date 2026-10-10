import 'package:eldoriaCare/screens/booking_requests/booking_r_details/booking_request_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/booking_model.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class BookingRequestsScreen extends StatelessWidget {
  const BookingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = DashboardController.to;

    return Obx(() {
      final staff = c.currentStaff.value;
      final city = staff?.city.capitalizeFirst ?? 'Mumbai';
      final requests = c.openRequests;
      return SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.8.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Booking requests',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              0.8.h.vs,
              Text(
                'Open requests in $city. Confirm them, take the visit yourself or assign a colleague.',
                style: TextStyle(
                  color: ThemeColors.textMuted,
                  fontSize: 13.sp,
                  height: 1.35,
                ),
              ),
              2.h.vs,

              if (requests.isEmpty)
                _buildEmptyRequests(city)
              else
                ...requests.map((b) => _buildRequestCard(b)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRequestCard(BookingModel b) {
    final bool isNew = b.isRequested;

    return Container(
      margin: EdgeInsets.only(bottom: 1.6.h),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNew ? ThemeColors.goldenAmber : ThemeColors.cardBorder,
          width: isNew ? 1.5 : 1.0,
        ),
      ),
      child: Material(
        color: ThemeColors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => Get.to(() => BookingRequestDetailScreen(booking: b)),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    if (isNew)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.8.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.goldenAmberBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'New request',
                          style: TextStyle(
                            color: ThemeColors.goldenAmberLight,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.8.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.infoBlueBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Confirmed · no caregiver',
                          style: TextStyle(
                            color: ThemeColors.infoBlueFg,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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
                  b.isConfirmed && b.confirmedBy != null
                      ? '${b.serviceName} · ${b.plan} · confirmed by ${b.confirmedBy}'
                      : '${b.serviceName} · ${b.plan}',
                  style: TextStyle(
                    color: ThemeColors.textMuted,
                    fontSize: 13.sp,
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

  Widget _buildEmptyRequests(String city) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_rounded, size: 36.sp, color: ThemeColors.textMuted),
          1.5.h.vs,
          Text(
            'No open requests',
            style: TextStyle(
              color: ThemeColors.textWhite,
              fontWeight: FontWeight.w800,
              fontSize: 15.sp,
            ),
          ),
          0.8.h.vs,
          Text(
            'New bookings in $city pop up on your screen and show here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: ThemeColors.textMuted, fontSize: 12.5.sp),
          ),
        ],
      ),
    );
  }
}
