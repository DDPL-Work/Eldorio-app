import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/screens/help/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/care_desk_buttons.dart';
import 'package:eldoriaCare/widget/status_pill.dart';

class HelpDoneScreen extends StatelessWidget {
  const HelpDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<HelpController>() ? HelpController.to : Get.put(HelpController());
    final String enquiryId = Get.arguments?.toString() ?? '';

    if (c.currentEnquiry.value == null && enquiryId.isNotEmpty) {
      c.loadEnquiry(enquiryId);
    }

    return Scaffold(
      backgroundColor: ThemeColors.appBackground,
      appBar: AppBar(
        backgroundColor: ThemeColors.appBar,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ThemeColors.textWhite),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final e = c.currentEnquiry.value;
          return Text(
            e != null ? 'Help request ${e.code}' : 'Help request',
            style: TextStyle(
              color: ThemeColors.textWhite,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          );
        }),
      ),
      body: Obx(() {
        if (c.isEnquiryLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: ThemeColors.goldenAmber),
          );
        }

        final e = c.currentEnquiry.value;
        if (e == null) {
          return Center(
            child: Text(
              'Request not found',
              style: TextStyle(color: ThemeColors.textMuted, fontSize: 14.sp),
            ),
          );
        }

        final recommendedServiceName =
            e.recommended != null ? c.getServiceName(e.recommended) : '';

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          children: [
            // ── Status row: Pill + Timestamp ──────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusPill(status: e.status),
                Text(
                  c.formatTimestamp(e.createdAt),
                  style: TextStyle(
                    color: ThemeColors.textMuted,
                    fontSize: 11.5.sp,
                  ),
                ),
              ],
            ),

            2.h.vs,

            // ── "Request sent to our care team" Banner if new ───────────────
            if (e.status == 'new') ...[
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: ThemeColors.successGreenBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ThemeColors.successGreen.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: ThemeColors.successGreen, size: 26),
                    3.w.hs,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Request sent to our care team',
                            style: TextStyle(
                              color: ThemeColors.successGreen,
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          0.4.h.vs,
                          Text(
                            'We\'ll call you on +91 ${e.clientPhone} to understand the need and recommend the right service.',
                            style: TextStyle(
                              color: ThemeColors.textWhite,
                              fontSize: 11.5.sp,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              2.2.h.vs,
            ],

            // ── Note from Eldoria Care Team / Recommendation ────────────────
            if (e.adminNote != null || recommendedServiceName.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.all(4.5.w),
                decoration: BoxDecoration(
                  color: ThemeColors.cardSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: ThemeColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From the Eldoria care team',
                      style: TextStyle(
                        color: ThemeColors.goldenAmber,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    if (e.adminNote != null && e.adminNote!.isNotEmpty) ...[
                      1.h.vs,
                      Text(
                        e.adminNote!,
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontSize: 13.sp,
                          height: 1.4,
                        ),
                      ),
                    ],
                    if (recommendedServiceName.isNotEmpty) ...[
                      1.5.h.vs,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Recommended: $recommendedServiceName',
                              style: TextStyle(
                                color: ThemeColors.textWhite,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.book, arguments: e.recommended);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeColors.goldenAmber,
                              foregroundColor: ThemeColors.deepNavy,
                              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Book now'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              2.2.h.vs,
            ],

            // ── Converted to booking button ─────────────────────────────────
            if (e.bookingId != null && e.bookingId!.isNotEmpty) ...[
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.booking, arguments: e.bookingId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.brandBlue,
                  foregroundColor: ThemeColors.textWhite,
                  padding: EdgeInsets.symmetric(vertical: 1.4.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('View booking ${e.bookingId}'),
              ),
              2.2.h.vs,
            ],

            // ── Request Summary Card ────────────────────────────────────────
            Container(
              padding: EdgeInsets.all(4.5.w),
              decoration: BoxDecoration(
                color: ThemeColors.cardSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ThemeColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Need', e.description),
                  1.2.h.vs,
                  _buildDetailRow(
                    'Patient',
                    '${e.patientType}${e.patientAge.isNotEmpty ? ' · ${e.patientAge} yrs' : ''}',
                  ),
                  1.2.h.vs,
                  _buildDetailRow('Location', '${e.address}, ${c.cityName(e.city)}'),
                  1.2.h.vs,
                  _buildDetailRow('Duration', e.duration),
                  1.2.h.vs,
                  _buildDetailRow('Timing', e.timing),
                  if (e.files.isNotEmpty) ...[
                    1.2.h.vs,
                    _buildDetailRow(
                      'Files',
                      e.files.map((f) => f.name).join(', '),
                    ),
                  ],
                ],
              ),
            ),

            2.5.h.vs,

            // ── "Want to talk now?" Section ─────────────────────────────────
            Text(
              'Want to talk now?',
              style: TextStyle(
                color: ThemeColors.textMuted,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            1.2.h.vs,
            const CareDeskButtons(),

            3.h.vs,
          ],
        );
      }),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
              color: ThemeColors.textWhite,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
