import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eldoriaCare/data_handler/client_data_controller.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/service_icon.dart';
import 'package:eldoriaCare/widget/status_pill.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = ClientDataController.to;

    return Scaffold(
      backgroundColor: ThemeColors.appBackground,
      appBar: AppBar(
        backgroundColor: ThemeColors.appBar,
        elevation: 0,
        title: Text(
          'My bookings',
          style: TextStyle(
            color: ThemeColors.textWhite,
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Obx(() {
        final active = c.activeBookings;
        final past = c.pastBookings;
        final enquiries = c.enquiries;
        final hasAny = active.isNotEmpty || past.isNotEmpty || enquiries.isNotEmpty;

        if (!hasAny) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: () => c.loadStoredData(),
          color: ThemeColors.goldenAmber,
          backgroundColor: ThemeColors.cardSurface,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            children: [
              // Active Bookings Section
              if (active.isNotEmpty) ...[
                _buildSectionHeader('ACTIVE'),
                1.h.vs,
                ...active.map((b) => _buildBookingCard(context, b)),
                2.h.vs,
              ],

              // Past Bookings Section
              if (past.isNotEmpty) ...[
                _buildSectionHeader('PAST'),
                1.h.vs,
                ...past.map((b) => _buildBookingCard(context, b)),
                2.h.vs,
              ],

              // Help Requests Section
              if (enquiries.isNotEmpty) ...[
                _buildSectionHeader('HELP REQUESTS'),
                1.h.vs,
                ...enquiries.map((e) => _buildHelpCard(context, e)),
                2.h.vs,
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: ThemeColors.textMuted,
        fontSize: 10.5.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingItem b) {
    final c = ClientDataController.to;
    final staff = c.getStaff(b.staffId);
    final service = c.getService(b.service);

    return Container(
      margin: EdgeInsets.only(bottom: 1.4.h),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.shadowColorDark,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.toNamed('${AppRoutes.dashboard}/booking', arguments: b.id);
          },
          child: Padding(
            padding: EdgeInsets.all(3.8.w),
            child: Row(
              children: [
                // Avatar (Staff Initials or Service Icon)
                if (staff != null)
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: ThemeColors.goldenAmberBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: ThemeColors.goldenAmber, width: 1.2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      staff.initials,
                      style: TextStyle(
                        color: ThemeColors.goldenAmber,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                else
                  ServiceIcon(
                    iconKey: service?.icon ?? 'cross',
                    size: 5.5.w,
                    containerSize: 12.w,
                  ),

                3.w.hs,

                // Booking Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${b.serviceName}${staff != null ? ' · ${staff.name.split(' ').first}' : ''}',
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      0.4.h.vs,
                      Text(
                        '${_formatDate(b.date)}, ${b.time} · for ${b.patientName}',
                        style: TextStyle(
                          color: ThemeColors.textMuted,
                          fontSize: 11.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                2.w.hs,

                // Status Pill
                StatusPill(status: b.status),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpCard(BuildContext context, HelpEnquiryItem e) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.4.h),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.toNamed('${AppRoutes.dashboard}/helpdone', arguments: e.id);
          },
          child: Padding(
            padding: EdgeInsets.all(3.8.w),
            child: Row(
              children: [
                // Help Avatar
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: ThemeColors.goldenAmberBg,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.help_outline_rounded,
                    color: ThemeColors.goldenAmber,
                    size: 22,
                  ),
                ),

                3.w.hs,

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${e.patientType.isNotEmpty ? e.patientType : 'Care request'}${e.patientAge.isNotEmpty ? ' · ${e.patientAge} yrs' : ''}',
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      0.4.h.vs,
                      Text(
                        '${e.code} · ${_formatTimeAgo(e.createdAt)}',
                        style: TextStyle(
                          color: ThemeColors.textMuted,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                2.w.hs,

                StatusPill(status: e.status),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: ThemeColors.cardSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ThemeColors.cardBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16.w,
                height: 16.w,
                decoration: const BoxDecoration(
                  color: ThemeColors.surface2,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: ThemeColors.goldenAmber,
                  size: 28,
                ),
              ),
              2.h.vs,
              Text(
                'No bookings yet',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              0.8.h.vs,
              Text(
                'Your requests and visits will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ThemeColors.textMuted,
                  fontSize: 12.5.sp,
                ),
              ),
              2.5.h.vs,
              ElevatedButton(
                onPressed: () {
                  DashboardController.to.currentNavIndex.value = 0;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.goldenAmber,
                  foregroundColor: ThemeColors.deepNavy,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.3.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Book a service',
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final parts = iso.split('-');
      if (parts.length == 3) {
        final d = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final target = DateTime(d.year, d.month, d.day);
        final diff = target.difference(today).inDays;

        if (diff == 0) return 'Today';
        if (diff == 1) return 'Tomorrow';
        if (diff == -1) return 'Yesterday';
        return DateFormat('d MMM').format(d);
      }
    } catch (_) {}
    return iso;
  }

  String _formatTimeAgo(int timestamp) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final diffMin = ((now - timestamp) / 60000).round();
    if (diffMin < 1) return 'Just now';
    if (diffMin < 60) return '${diffMin}m ago';
    final diffHours = (diffMin / 60).round();
    if (diffHours < 24) return '${diffHours}h ago';
    final diffDays = (diffHours / 24).round();
    return '${diffDays}d ago';
  }
}
