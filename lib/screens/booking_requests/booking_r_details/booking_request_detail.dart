import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/booking_model.dart';
import 'package:eldoriaCare/model/staff_profile.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/my_button.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingRequestDetailScreen extends StatefulWidget {
  final BookingModel booking;

  const BookingRequestDetailScreen({super.key, required this.booking});

  @override
  State<BookingRequestDetailScreen> createState() => _BookingRequestDetailScreenState();
}

class _BookingRequestDetailScreenState extends State<BookingRequestDetailScreen> {
  StaffModel? selectedColleague;

  @override
  Widget build(BuildContext context) {
    final c = DashboardController.to;
    final b = widget.booking;

    return Scaffold(
      backgroundColor: ThemeColors.appBackgroundDeep,
      appBar: AppBar(
        backgroundColor: ThemeColors.sceneDarkNavy,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: ThemeColors.textWhite, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Booking request',
          style: TextStyle(
            color: ThemeColors.textWhite,
            fontWeight: FontWeight.w800,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.8.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Top Badges Row ──────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                    decoration: BoxDecoration(
                      color: ThemeColors.goldenAmberBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'New request',
                      style: TextStyle(
                        color: ThemeColors.goldenAmberLight,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                    decoration: BoxDecoration(
                      color: ThemeColors.infoBlueBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${b.code} · ${b.source}',
                      style: TextStyle(
                        color: ThemeColors.infoBlueFg,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              1.6.h.vs,

              // ── Details Card ────────────────────────────────────
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: ThemeColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ThemeColors.cardBorder),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Service', '${b.serviceName} · ${b.plan}'),
                    _buildDetailRow('When', '${b.date}, ${b.time}'),
                    _buildDetailRow('Patient', '${b.patientName}, ${b.patientAge} (${b.relation})'),
                    _buildDetailRow('Address', '${b.address}, ${b.city.capitalizeFirst}'),
                    _buildDetailRow('Family', '${b.clientName} · +91 ${b.clientPhone}'),
                    if (b.notes.isNotEmpty)
                      _buildDetailRow('Care notes', b.notes),
                    _buildDetailRow('Requested', '5 Oct, 11:50 AM'),
                  ],
                ),
              ),
              1.6.h.vs,

              // ── Quick Contacts Row ──────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _callFamily(b.clientPhone),
                      icon: Icon(Icons.phone_outlined, color: ThemeColors.textWhite, size: 18.sp),
                      label: Text(
                        'Call family',
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5.sp,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: ThemeColors.whiteBorder40),
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  3.w.hs,
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openWhatsApp(b.clientPhone, b.clientName, b.patientName),
                      icon: Icon(Icons.chat_bubble_outline_rounded, color: ThemeColors.textWhite, size: 18.sp),
                      label: Text(
                        'WhatsApp',
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5.sp,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.whatsAppGreen,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
              2.h.vs,

              // ── Take This Visit Card ────────────────────────────
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: ThemeColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ThemeColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Take this visit',
                      style: TextStyle(
                        color: ThemeColors.textWhite,
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                      ),
                    ),
                    1.4.h.vs,
                    ElevatedButton.icon(
                      onPressed: () => c.acceptRequestSelf(b),
                      icon: Icon(Icons.check_rounded, color: ThemeColors.deepNavy, size: 20.sp),
                      label: Text(
                        'Confirm & assign to me',
                        style: TextStyle(
                          color: ThemeColors.deepNavy,
                          fontWeight: FontWeight.w800,
                          fontSize: 14.5.sp,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.goldenAmber,
                        padding: EdgeInsets.symmetric(vertical: 1.6.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
              2.h.vs,

              // ── Assign a Colleague Card ─────────────────────────
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: ThemeColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ThemeColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Assign a colleague',
                      style: TextStyle(
                        color: ThemeColors.textWhite,
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                      ),
                    ),
                    1.4.h.vs,
                    Text(
                      'Staff member',
                      style: TextStyle(
                        color: ThemeColors.textSlateMuted,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    0.6.h.vs,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                      decoration: BoxDecoration(
                        color: ThemeColors.inputBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ThemeColors.lineBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<StaffModel>(
                          value: selectedColleague,
                          dropdownColor: ThemeColors.cardSurface,
                          hint: Text(
                            'Choose a person...',
                            style: TextStyle(color: ThemeColors.textPlaceholder, fontSize: 13.5.sp),
                          ),
                          isExpanded: true,
                          style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.5.sp),
                          items: c.colleagues.map((colleague) {
                            return DropdownMenuItem<StaffModel>(
                              value: colleague,
                              child: Text('${colleague.name} · ${colleague.role}'),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => selectedColleague = val);
                          },
                        ),
                      ),
                    ),
                    1.4.h.vs,
                    MyButton(
                      label: 'Confirm & assign',
                      color: ThemeColors.brandBlue,
                      onPressed: selectedColleague != null
                          ? () => c.assignRequestColleague(b, selectedColleague!)
                          : null,
                    ),
                  ],
                ),
              ),
              2.h.vs,

              // ── Confirm Only Action Button ──────────────────────
              OutlinedButton(
                onPressed: () => c.confirmOnlyRequest(b),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ThemeColors.textWhite,
                  side: const BorderSide(color: ThemeColors.cardBorder),
                  padding: EdgeInsets.symmetric(vertical: 1.6.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: ThemeColors.inputBg,
                ),
                child: Text(
                  'Confirm only · care desk assigns later',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: ThemeColors.textSlateMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callFamily(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String phone, String clientName, String patientName) async {
    final message = Uri.encodeComponent('Hello $clientName, this is regarding the visit for $patientName from Eldoria Care.');
    final uri = Uri.parse('https://wa.me/91$phone?text=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
