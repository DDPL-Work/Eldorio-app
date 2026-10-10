import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/booking_model.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/my_button.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitDetailScreen extends StatefulWidget {
  final BookingModel booking;

  const VisitDetailScreen({super.key, required this.booking});

  @override
  State<VisitDetailScreen> createState() => _VisitDetailScreenState();
}

class _VisitDetailScreenState extends State<VisitDetailScreen> {
  late TextEditingController bpCtrl;
  late TextEditingController sugarCtrl;
  late TextEditingController spo2Ctrl;
  late TextEditingController noteCtrl;

  @override
  void initState() {
    super.initState();
    final v = widget.booking.visit;
    bpCtrl = TextEditingController(text: v?.bp ?? '');
    sugarCtrl = TextEditingController(text: v?.sugar ?? '');
    spo2Ctrl = TextEditingController(text: v?.spo2 ?? '');
    noteCtrl = TextEditingController(text: v?.note ?? '');
  }

  @override
  void dispose() {
    bpCtrl.dispose();
    sugarCtrl.dispose();
    spo2Ctrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${b.patientName}, ${b.patientAge}',
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontWeight: FontWeight.w800,
                fontSize: 16.5.sp,
              ),
            ),
            Text(
              '${b.serviceName} · ${b.date}, ${b.time}',
              style: TextStyle(
                color: ThemeColors.textFaint,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.8.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Status Pill & Code ──────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusPill(b),
                  Text(
                    b.code,
                    style: TextStyle(
                      color: ThemeColors.textSlateMuted,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              1.6.h.vs,

              // ── Care Notes from Family (if present) ─────────────
              if (b.notes.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.all(3.6.w),
                  decoration: BoxDecoration(
                    color: ThemeColors.goldenAmberBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ThemeColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARE NOTES FROM FAMILY',
                        style: TextStyle(
                          color: ThemeColors.goldenAmber,
                          fontWeight: FontWeight.w800,
                          fontSize: 11.sp,
                          letterSpacing: 0.5,
                        ),
                      ),
                      0.6.h.vs,
                      Text(
                        b.notes,
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontSize: 13.sp,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                1.6.h.vs,
              ],

              // ── Address & Quick Contact Card ────────────────────
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: ThemeColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ThemeColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, color: ThemeColors.textMuted, size: 18.sp),
                        2.w.hs,
                        Expanded(
                          child: Text(
                            '${b.address}, ${b.city.capitalizeFirst}',
                            style: TextStyle(
                              color: ThemeColors.textWhite,
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    1.4.h.vs,
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _callFamily(b.clientPhone),
                            icon: Icon(Icons.phone_outlined, color: ThemeColors.textWhite, size: 16.sp),
                            label: Text(
                              'Call family',
                              style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.sp, fontWeight: FontWeight.w700),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: ThemeColors.whiteBorder40),
                              padding: EdgeInsets.symmetric(vertical: 1.2.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        2.w.hs,
                        IconButton(
                          onPressed: () => _openWhatsApp(b.clientPhone, b.clientName, b.patientName),
                          icon: Icon(Icons.chat_bubble_outline_rounded, color: ThemeColors.textWhite, size: 18.sp),
                          style: IconButton.styleFrom(
                            backgroundColor: ThemeColors.whatsAppGreen,
                            padding: EdgeInsets.all(2.8.w),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        2.w.hs,
                        IconButton(
                          onPressed: () => _openMaps(b.address, b.city),
                          icon: Icon(Icons.navigation_outlined, color: ThemeColors.textWhite, size: 18.sp),
                          style: IconButton.styleFrom(
                            backgroundColor: ThemeColors.surface2,
                            padding: EdgeInsets.all(2.8.w),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                    1.h.vs,
                    Text(
                      'Family: +91 ${b.clientPhone}',
                      style: TextStyle(
                        color: ThemeColors.textPlaceholder,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              1.6.h.vs,

              // ── Care Tasks Card ─────────────────────────────────
              if (b.tasks.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: ThemeColors.cardSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ThemeColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Care tasks',
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontWeight: FontWeight.w800,
                          fontSize: 15.sp,
                        ),
                      ),
                      1.h.vs,
                      ...List.generate(b.tasks.length, (index) {
                        final task = b.tasks[index];
                        return CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            task.label,
                            style: TextStyle(
                              color: task.done ? ThemeColors.textSlateMuted : ThemeColors.textWhite,
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w500,
                              decoration: task.done ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          value: task.done,
                          activeColor: ThemeColors.goldenAmber,
                          checkColor: ThemeColors.deepNavy,
                          onChanged: b.isCompleted ? null : (_) => c.toggleTask(b, index),
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }),
                    ],
                  ),
                ),
                1.6.h.vs,
              ],

              // ── Vitals & Notes Card ─────────────────────────────
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: ThemeColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ThemeColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vitals & notes',
                      style: TextStyle(
                        color: ThemeColors.textWhite,
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                      ),
                    ),
                    1.4.h.vs,
                    if (b.isCompleted) ...[
                      _buildVitalRow('BP', b.visit?.bp.isNotEmpty == true ? '${b.visit!.bp} mmHg' : '—'),
                      _buildVitalRow('Sugar', b.visit?.sugar.isNotEmpty == true ? '${b.visit!.sugar} mg/dL' : '—'),
                      _buildVitalRow('SpO₂', b.visit?.spo2.isNotEmpty == true ? '${b.visit!.spo2}%' : '—'),
                      _buildVitalRow('Nurse notes', b.visit?.note.isNotEmpty == true ? b.visit!.note : '—'),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(child: _buildVitalInput(bpCtrl, 'BP', '120/80')),
                          2.w.hs,
                          Expanded(child: _buildVitalInput(sugarCtrl, 'Sugar', 'mg/dL')),
                          2.w.hs,
                          Expanded(child: _buildVitalInput(spo2Ctrl, 'SpO₂', '%')),
                        ],
                      ),
                      1.4.h.vs,
                      TextField(
                        controller: noteCtrl,
                        maxLines: 3,
                        style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.5.sp),
                        decoration: InputDecoration(
                          hintText: 'Visit notes for family (what was done, vitals, anything to watch)...',
                          hintStyle: TextStyle(color: ThemeColors.textPlaceholder, fontSize: 13.sp),
                          filled: true,
                          fillColor: ThemeColors.inputBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: ThemeColors.lineBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: ThemeColors.lineBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: ThemeColors.goldenAmber),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              2.h.vs,

              // ── Bottom Action Button ────────────────────────────
              _buildActionArea(c, b),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVitalInput(TextEditingController ctrl, String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: ThemeColors.textSlateMuted, fontSize: 11.5.sp, fontWeight: FontWeight.w600),
        ),
        0.5.h.vs,
        TextField(
          controller: ctrl,
          style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: ThemeColors.textPlaceholder, fontSize: 12.sp),
            filled: true,
            fillColor: ThemeColors.inputBg,
            contentPadding: EdgeInsets.symmetric(horizontal: 2.6.w, vertical: 1.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: ThemeColors.lineBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: ThemeColors.lineBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: ThemeColors.goldenAmber),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVitalRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: TextStyle(
                color: ThemeColors.textSlateMuted,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionArea(DashboardController c, BookingModel b) {
    if (b.isAssigned || b.isConfirmed) {
      return MyButton(
        label: 'Start trip · notify family',
        color: ThemeColors.goldenAmber,
        onPressed: () => c.updateVisitStatus(b, 'on_the_way'),
      );
    } else if (b.isOnTheWay) {
      return MyButton(
        label: 'Check in at patient\'s home',
        color: ThemeColors.goldenAmber,
        onPressed: () => c.updateVisitStatus(b, 'in_progress'),
      );
    } else if (b.isInProgress) {
      return MyButton(
        label: 'Complete visit & check out',
        color: ThemeColors.brandBlue,
        onPressed: () {
          c.saveVitals(b, bpCtrl.text, sugarCtrl.text, spo2Ctrl.text, noteCtrl.text);
          c.updateVisitStatus(b, 'completed');
        },
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.4.h),
        decoration: BoxDecoration(
          color: ThemeColors.successGreenBg,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          'Visit completed',
          style: TextStyle(
            color: ThemeColors.successGreen,
            fontWeight: FontWeight.w800,
            fontSize: 14.5.sp,
          ),
        ),
      );
    }
  }

  Widget _buildStatusPill(BookingModel b) {
    Color bg;
    Color fg;
    String text;

    if (b.isCompleted) {
      bg = ThemeColors.successGreenBg;
      fg = ThemeColors.successGreen;
      text = 'Completed';
    } else if (b.isInProgress) {
      bg = ThemeColors.goldenAmberBg;
      fg = ThemeColors.goldenAmberLight;
      text = 'In progress';
    } else if (b.isOnTheWay) {
      bg = ThemeColors.infoBlueBg;
      fg = ThemeColors.infoBlueFg;
      text = 'On the way';
    } else {
      bg = ThemeColors.badgeStaffAssignedBg;
      fg = ThemeColors.badgeStaffAssignedFg;
      text = 'Staff assigned';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.8.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 11.5.sp,
          fontWeight: FontWeight.w700,
        ),
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
    final message = Uri.encodeComponent('Hello, this is regarding $patientName\'s visit from Eldoria Care.');
    final uri = Uri.parse('https://wa.me/91$phone?text=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openMaps(String address, String city) async {
    final query = Uri.encodeComponent('$address, $city');
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
