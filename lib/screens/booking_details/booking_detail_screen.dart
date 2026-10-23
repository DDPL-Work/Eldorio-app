import 'package:eldoriaCare/screens/booking_details/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/status_pill.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(BookingDetailController());

    return Obx(() {
      final b = c.booking.value;

      return Scaffold(
        backgroundColor: ThemeColors.appBackground,
        appBar: AppBar(
          backgroundColor: ThemeColors.appBar,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ThemeColors.textWhite,
            ),
            onPressed: () => Get.back(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking ${b?.code ?? ''}',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (b != null) ...[
                0.2.h.vs,
                Text(
                  b.serviceName,
                  style: TextStyle(
                    color: ThemeColors.textMuted,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
        body: _buildBody(context, c, b),
      );
    });
  }

  Widget _buildBody(
    BuildContext context,
    BookingDetailController c,
    BookingItem? b,
  ) {
    if (c.isLoading.value && b == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: ThemeColors.goldenAmber),
            2.h.vs,
            Text(
              'Loading booking details...',
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

    if (b == null) {
      return Center(
        child: Text(
          'Booking not found',
          style: TextStyle(color: ThemeColors.textMuted, fontSize: 14.sp),
        ),
      );
    }

    final staff = b.assignedStaff != null
        ? StaffItem(
            id: b.assignedStaff!.staffId,
            name: b.assignedStaff!.name,
            phone: b.assignedStaff!.phone,
            role: b.assignedStaff!.qualification.isNotEmpty
                ? b.assignedStaff!.qualification
                : 'Care Specialist',
            city: b.assignedStaff!.city,
            area: b.assignedStaff!.area,
            docs: b.assignedStaff!.docs,
            onDuty: b.assignedStaff!.onDuty,
          )
        : c.getStaff(b.staffId);

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      children: [
        // Status row: Pill + Date, Time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatusPill(status: b.status),
            Text(
              '${c.formatDate(b.date)}, ${b.time}',
              style: TextStyle(
                color: ThemeColors.textMuted,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        2.h.vs,

        // Staff / Caregiver Card or Assigning Notice
        if (staff != null)
          _buildStaffCard(context, c, b, staff)
        else
          _buildAssigningNotice(context),

        2.2.h.vs,

        // Status Timeline
        _buildTimelineCard(context, c, b),

        2.2.h.vs,

        // Booking Details Card (Patient, Plan, Address, Notes, Estimate)
        _buildDetailsCard(context, c, b),

        // Visit Report Card (if completed and visit data present)
        if (b.status == 'completed' && b.visit != null) ...[
          2.2.h.vs,
          _buildVisitReportCard(context, c, b),
        ],

        // Cancel Booking Action
        if (b.canCancel) ...[
          2.5.h.vs,
          _buildCancelAction(context, c, b),
        ],

        3.h.vs,
      ],
    );
  }

  // ── Caregiver Card ────────────────────────────────────────────────────
  Widget _buildStaffCard(
    BuildContext context,
    BookingDetailController c,
    BookingItem b,
    StaffItem staff,
  ) {
    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ThemeColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: ThemeColors.shadowColorDark,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar with initials
              Container(
                width: 13.w,
                height: 13.w,
                decoration: BoxDecoration(
                  color: ThemeColors.goldenAmberBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: ThemeColors.goldenAmber, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  staff.initials,
                  style: TextStyle(
                    color: ThemeColors.goldenAmber,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              3.5.w.hs,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staff.name,
                      style: TextStyle(
                        color: ThemeColors.textWhite,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    0.3.h.vs,
                    Text(
                      staff.role,
                      style: TextStyle(
                        color: ThemeColors.textMuted,
                        fontSize: 12.sp,
                      ),
                    ),
                    if (staff.docs == 'verified') ...[
                      0.4.h.vs,
                      Row(
                        children: [
                          const Icon(
                            Icons.shield_rounded,
                            color: ThemeColors.successGreen,
                            size: 14,
                          ),
                          1.w.hs,
                          Text(
                            'ID & background verified',
                            style: TextStyle(
                              color: ThemeColors.successGreen,
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          2.h.vs,

          // Call and WhatsApp buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => c.makePhoneCall(staff.phone),
                  icon: const Icon(Icons.phone_rounded, size: 16),
                  label: const Text('Call'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ThemeColors.textWhite,
                    side: const BorderSide(color: ThemeColors.cardBorder),
                    padding: EdgeInsets.symmetric(vertical: 1.2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              3.w.hs,
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => c.openWhatsApp(
                    staff.phone,
                    text:
                        'Hello ${staff.name}, regarding booking ${b.code}.',
                  ),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: const Text('WhatsApp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.whatsAppGreen,
                    foregroundColor: ThemeColors.textWhite,
                    padding: EdgeInsets.symmetric(vertical: 1.2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),

          1.2.h.vs,
          Text(
            'Staff number: +91 ${staff.phone}',
            style: TextStyle(
              color: ThemeColors.textMuted,
              fontSize: 10.5.sp,
            ),
          ),
        ],
      ),
    );
  }

  // ── "Assigning your caregiver" Card ───────────────────────────────────
  Widget _buildAssigningNotice(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 9.w,
                height: 9.w,
                decoration: const BoxDecoration(
                  color: ThemeColors.surface2,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_search_rounded,
                  color: ThemeColors.goldenAmber,
                  size: 20,
                ),
              ),
              2.5.w.hs,
              Text(
                'Assigning your caregiver',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          1.h.vs,
          Text(
            'Our care desk will confirm and assign a verified nurse or caregiver. You\'ll get an alert here.',
            style: TextStyle(
              color: ThemeColors.textMuted,
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ── Status Timeline Card ──────────────────────────────────────────────
  Widget _buildTimelineCard(
    BuildContext context,
    BookingDetailController c,
    BookingItem b,
  ) {
    final isCancelled = b.status == 'cancelled';

    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status',
            style: TextStyle(
              color: ThemeColors.textWhite,
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          1.5.h.vs,
          if (isCancelled)
            Container(
              padding: EdgeInsets.all(3.5.w),
              decoration: BoxDecoration(
                color: ThemeColors.errorRedBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'This booking was cancelled${b.cancelReason != null ? ': ${b.cancelReason}' : ''}.',
                style: TextStyle(
                  color: ThemeColors.errorRedColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else ...[
            ...BookingDetailController.flowSteps.asMap().entries.map((entry) {
              final index = entry.key;
              final stepKey = entry.value;
              final currentIndex =
                  BookingDetailController.flowSteps.indexOf(b.status);

              final isDone = index < currentIndex ||
                  (index == currentIndex && b.status == 'completed');
              final isCurrent = index == currentIndex && !isDone;

              final historyEntry =
                  b.history.firstWhereOrNull((h) => h.status == stepKey);

              return _buildTimelineStep(
                label: BookingDetailController.flowLabels[stepKey] ?? stepKey,
                isDone: isDone,
                isCurrent: isCurrent,
                isLast: index == BookingDetailController.flowSteps.length - 1,
                subtitle: historyEntry != null && index <= currentIndex
                    ? '${c.formatTimeAgo(historyEntry.at)}${historyEntry.by != 'client' ? ' · by ${historyEntry.by}' : ''}'
                    : null,
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String label,
    required bool isDone,
    required bool isCurrent,
    required bool isLast,
    String? subtitle,
  }) {
    Color nodeColor = ThemeColors.surface2;
    Color iconColor = ThemeColors.textMuted;
    Color lineColor = ThemeColors.lineBorder;

    if (isDone) {
      nodeColor = ThemeColors.successGreen;
      iconColor = ThemeColors.deepNavy;
      lineColor = ThemeColors.successGreen;
    } else if (isCurrent) {
      nodeColor = ThemeColors.goldenAmber;
      iconColor = ThemeColors.deepNavy;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rail Column (Node + Vertical Line)
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: nodeColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCurrent
                      ? ThemeColors.goldenAmber
                      : ThemeColors.cardBorder,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: isDone
                  ? Icon(Icons.check_rounded, color: iconColor, size: 13)
                  : (isCurrent
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: ThemeColors.deepNavy,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: lineColor.withValues(alpha: 0.6),
              ),
          ],
        ),

        3.w.hs,

        // Step Label & Timestamp
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isDone || isCurrent
                        ? ThemeColors.textWhite
                        : ThemeColors.textMuted,
                    fontSize: 12.5.sp,
                    fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  0.3.h.vs,
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: ThemeColors.textMuted,
                      fontSize: 10.5.sp,
                    ),
                  ),
                ],
                if (!isLast) 1.2.h.vs,
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Booking Details Card ──────────────────────────────────────────────
  Widget _buildDetailsCard(
    BuildContext context,
    BookingDetailController c,
    BookingItem b,
  ) {
    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            'Patient',
            '${b.patientName}${b.patientAge.isNotEmpty ? ', ${b.patientAge}' : ''} (${b.relation})',
          ),
          1.2.h.vs,
          _buildDetailRow('Plan', b.plan),
          1.2.h.vs,
          _buildDetailRow('Address', '${b.address}, ${c.cityName(b.city)}'),
          if (b.notes.isNotEmpty) ...[
            1.2.h.vs,
            _buildDetailRow('Notes', b.notes),
          ],
          if (b.fromEnquiry != null && b.fromEnquiry!.isNotEmpty) ...[
            1.2.h.vs,
            _buildDetailRow('Reference', b.fromEnquiry!),
          ],
          1.2.h.vs,
          _buildDetailRow(
            'Estimate',
            b.formattedPrice.isNotEmpty
                ? b.formattedPrice
                : 'Contact for price',
            isAccent: true,
          ),
          if (b.files.isNotEmpty) ...[
            1.8.h.vs,
            Text(
              'Attached Documents (${b.files.length})',
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            0.8.h.vs,
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: b.files.map((f) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.5.w,
                    vertical: 0.6.h,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.surface2,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ThemeColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        f.type.contains('pdf')
                            ? Icons.picture_as_pdf_rounded
                            : Icons.image_rounded,
                        size: 13.sp,
                        color: ThemeColors.goldenAmber,
                      ),
                      1.5.w.hs,
                      Text(
                        f.name,
                        style: TextStyle(
                          color: ThemeColors.textLight,
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
          if (b.tasks.isNotEmpty) ...[
            1.8.h.vs,
            Text(
              'Care Tasks (${b.tasks.length})',
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            0.8.h.vs,
            ...b.tasks.map(
              (task) => Padding(
                padding: EdgeInsets.symmetric(vertical: 0.4.h),
                child: Row(
                  children: [
                    Icon(
                      task.done
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 13.sp,
                      color: task.done
                          ? ThemeColors.successGreen
                          : ThemeColors.goldenAmber,
                    ),
                    2.w.hs,
                    Expanded(
                      child: Text(
                        task.label,
                        style: TextStyle(
                          color: task.done
                              ? ThemeColors.textMuted
                              : ThemeColors.textWhite,
                          fontSize: 11.5.sp,
                          fontWeight:
                              task.done ? FontWeight.w500 : FontWeight.w600,
                          decoration:
                              task.done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAccent = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22.w,
          child: Text(
            label,
            style: TextStyle(
              color: ThemeColors.textMuted,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isAccent ? ThemeColors.goldenAmber : ThemeColors.textWhite,
              fontSize: 12.5.sp,
              fontWeight: isAccent ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ── Visit Report Card ─────────────────────────────────────────────────
  Widget _buildVisitReportCard(
    BuildContext context,
    BookingDetailController c,
    BookingItem b,
  ) {
    final v = b.visit!;

    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visit report',
            style: TextStyle(
              color: ThemeColors.textWhite,
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          1.5.h.vs,
          if (v.bp != null && v.bp!.isNotEmpty) ...[
            _buildDetailRow('BP', '${v.bp} mmHg'),
            1.h.vs,
          ],
          if (v.sugar != null && v.sugar!.isNotEmpty) ...[
            _buildDetailRow('Sugar', '${v.sugar} mg/dL'),
            1.h.vs,
          ],
          if (v.spo2 != null && v.spo2!.isNotEmpty) ...[
            _buildDetailRow('SpO₂', '${v.spo2}%'),
            1.h.vs,
          ],
          if (v.note != null && v.note!.isNotEmpty) ...[
            _buildDetailRow('Nurse notes', v.note!),
            1.h.vs,
          ],
          if (b.checkInAt != null) ...[
            _buildDetailRow('Check-in', c.formatTimestamp(b.checkInAt!)),
            1.h.vs,
          ],
          if (b.checkOutAt != null) ...[
            _buildDetailRow('Check-out', c.formatTimestamp(b.checkOutAt!)),
          ],
        ],
      ),
    );
  }

  // ── Cancel Action ─────────────────────────────────────────────────────
  Widget _buildCancelAction(
    BuildContext context,
    BookingDetailController c,
    BookingItem b,
  ) {
    return Obx(() {
      if (c.showCancelConfirm.value) {
        return Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: ThemeColors.errorRedBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ThemeColors.errorRedColor.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Cancel this booking?',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              1.5.h.vs,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        c.showCancelConfirm.value = false;
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ThemeColors.textWhite,
                        side: const BorderSide(color: ThemeColors.cardBorder),
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Keep it'),
                    ),
                  ),
                  3.w.hs,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        c.cancelBooking(b.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.errorRed,
                        foregroundColor: ThemeColors.textWhite,
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Yes, cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }

      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            c.showCancelConfirm.value = true;
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: ThemeColors.errorRedColor,
            side: BorderSide(
              color: ThemeColors.errorRedColor.withValues(alpha: 0.4),
            ),
            padding: EdgeInsets.symmetric(vertical: 1.4.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Cancel booking',
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    });
  }
}
