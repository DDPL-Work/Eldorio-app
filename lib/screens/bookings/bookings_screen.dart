import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/screens/bookings/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/service_icon.dart';
import 'package:eldoriaCare/widget/status_pill.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(BookingsController());

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
        if (c.isLoading.value && c.bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: ThemeColors.goldenAmber),
                2.h.vs,
                Text(
                  'Loading bookings...',
                  style: TextStyle(
                    color: ThemeColors.textMuted,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        if (c.isEmpty) {
          return _buildEmptyState(context, c);
        }

        final active = c.activeBookings;
        final past = c.pastBookings;
        final enquiries = c.enquiries;

        return RefreshIndicator(
          onRefresh: () => c.fetchBookings(showLoading: false),
          color: ThemeColors.goldenAmber,
          backgroundColor: ThemeColors.cardSurface,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // ── Active Bookings Section ─────────────────────────────────
              if (active.isNotEmpty) ...[
                _buildSectionHeader('ACTIVE BOOKINGS (${active.length})'),
                1.h.vs,
                ...active.map((b) => _buildBookingCard(context, c, b)),
                2.h.vs,
              ],

              // ── Past Bookings Section ───────────────────────────────────
              if (past.isNotEmpty) ...[
                _buildSectionHeader('PAST BOOKINGS (${past.length})'),
                1.h.vs,
                ...past.map((b) => _buildBookingCard(context, c, b)),
                2.h.vs,
              ],

              // ── Help Requests Section ───────────────────────────────────
              if (enquiries.isNotEmpty) ...[
                _buildSectionHeader('HELP REQUESTS (${enquiries.length})'),
                1.h.vs,
                ...enquiries.map((e) => _buildHelpCard(context, c, e)),
                2.h.vs,
              ],
            ],
          ),
        );
      }),
    );
  }

  // ── Section Header ────────────────────────────────────────────────────────
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

  // ── Booking Card ──────────────────────────────────────────────────────────
  Widget _buildBookingCard(
    BuildContext context,
    BookingsController c,
    BookingItem b,
  ) {
    final assignedStaff = b.assignedStaff;
    final staffInitials = c.getStaffInitials(b);
    final hasAvatar = c.hasStaffAvatar(b);
    final priceStr = c.getPriceString(b);

    return Container(
      margin: EdgeInsets.only(bottom: 1.4.h),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: ThemeColors.shadowColorDark,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => c.onBookingTapped(b),
          child: Padding(
            padding: EdgeInsets.all(3.8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar + Title & Date + Status Pill
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar (Staff Initials or Service Icon)
                    if (hasAvatar)
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: ThemeColors.goldenAmberBg,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ThemeColors.goldenAmber,
                            width: 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          staffInitials,
                          style: TextStyle(
                            color: ThemeColors.goldenAmber,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      )
                    else
                      ServiceIcon(
                        iconKey: c.getServiceIcon(b.service),
                        size: 5.5.w,
                        containerSize: 12.w,
                      ),

                    3.w.hs,

                    // Booking Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  b.effectiveServiceName,
                                  style: TextStyle(
                                    color: ThemeColors.textWhite,
                                    fontSize: 13.5.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          0.4.h.vs,
                          Text(
                            '${c.formatDate(b.date)}, ${b.time} · for ${b.patientName}${b.relation.isNotEmpty ? ' (${b.relation})' : ''}',
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

                1.h.vs,

                // Divider line
                Divider(
                  color: ThemeColors.lineBorder.withValues(alpha: 0.4),
                  height: 1,
                ),

                1.h.vs,

                // Bottom Metadata Chips: Code, Location, Price
                Row(
                  children: [
                    // Code Pill
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.2.w,
                        vertical: 0.3.h,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.surface2,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        b.code.isNotEmpty ? b.code : '#${b.id}',
                        style: TextStyle(
                          color: ThemeColors.goldenAmber,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    2.w.hs,

                    // Location / City
                    Expanded(
                      child: Text(
                        b.area.isNotEmpty
                            ? '${b.area}, ${b.city}'
                            : (b.address.isNotEmpty ? b.address : b.city),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ThemeColors.textMuted,
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    if (priceStr.isNotEmpty) ...[
                      1.w.hs,
                      Text(
                        priceStr,
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ],
                ),

                // Assigned Staff Info Snippet (if staff is assigned)
                if (assignedStaff != null) ...[
                  0.8.h.vs,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.5.w,
                      vertical: 0.6.h,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.brandBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ThemeColors.brandBlueLight.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_pin_rounded,
                          size: 13.sp,
                          color: ThemeColors.brandBlueLight,
                        ),
                        1.5.w.hs,
                        Expanded(
                          child: Text(
                            'Caregiver: ${assignedStaff.name}${assignedStaff.qualification.isNotEmpty ? ' · ${assignedStaff.qualification}' : ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ThemeColors.brandBlueLight,
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (assignedStaff.docs == 'verified') ...[
                          Icon(
                            Icons.verified_rounded,
                            size: 11.sp,
                            color: ThemeColors.successGreen,
                          ),
                          1.w.hs,
                          Text(
                            'Verified',
                            style: TextStyle(
                              color: ThemeColors.successGreen,
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],

                // Care Tasks badge if tasks are provided
                if (b.tasks.isNotEmpty) ...[
                  0.6.h.vs,
                  Row(
                    children: [
                      Icon(
                        Icons.check_box_outlined,
                        size: 11.sp,
                        color: ThemeColors.textMuted,
                      ),
                      1.5.w.hs,
                      Text(
                        '${b.tasks.length} care task${b.tasks.length == 1 ? '' : 's'} included',
                        style: TextStyle(
                          color: ThemeColors.textMuted,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Help Enquiry Card ─────────────────────────────────────────────────────
  Widget _buildHelpCard(
    BuildContext context,
    BookingsController c,
    HelpEnquiryItem e,
  ) {
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
          onTap: () => c.onEnquiryTapped(e),
          child: Padding(
            padding: EdgeInsets.all(3.8.w),
            child: Row(
              children: [
                // Help Avatar
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: const BoxDecoration(
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
                        '${e.code} · ${c.formatTimeAgo(e.createdAt)}',
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

  // ── Empty State ───────────────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context, BookingsController c) {
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
                onPressed: c.onBookServicePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.goldenAmber,
                  foregroundColor: ThemeColors.deepNavy,
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 1.3.h,
                  ),
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
}
