import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eldoriaCare/data_handler/client_data_controller.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final clientData = ClientDataController.to;

  late ServiceItem service;
  bool isEquipment = false;

  final patientNameController = TextEditingController();
  final patientAgeController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  String selectedRelation = 'Mother';
  String selectedPlan = '';
  late String selectedDate;
  String selectedTime = '9:00 AM';
  String selectedCity = 'mumbai';

  final List<String> relations = ['Mother', 'Father', 'Self', 'Spouse', 'Grandparent', 'Other'];
  final List<String> timeSlots = ['7:00 AM', '9:00 AM', '11:00 AM', '2:00 PM', '5:00 PM', '8:00 PM'];
  late List<DateTime> next7Days;

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final serviceId = Get.arguments?.toString() ?? 'nursing';
    service = clientData.getService(serviceId) ?? clientData.services.first;

    final cat = clientData.getCategory(service.categoryId);
    isEquipment = cat?.kind == 'equipment';

    // Pre-fill fields
    selectedPlan = service.options.isNotEmpty ? service.options.first : 'Single visit';
    selectedCity = clientData.clientCity.value;
    addressController.text = clientData.clientAddress.value;

    final now = DateTime.now();
    next7Days = List.generate(7, (i) => now.add(Duration(days: i)));
    selectedDate = DateFormat('yyyy-MM-dd').format(next7Days.first);
  }

  @override
  void dispose() {
    patientNameController.dispose();
    patientAgeController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }

  bool get isFormValid {
    return patientNameController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty &&
        selectedDate.isNotEmpty &&
        selectedTime.isNotEmpty;
  }

  Future<void> _submitBooking() async {
    if (!isFormValid || isSubmitting) return;

    setState(() => isSubmitting = true);

    try {
      final newId = await clientData.createBooking(
        serviceId: service.id,
        patientName: patientNameController.text.trim(),
        patientAge: patientAgeController.text.trim(),
        relation: selectedRelation,
        plan: selectedPlan,
        date: selectedDate,
        time: selectedTime,
        city: selectedCity,
        address: addressController.text.trim(),
        notes: notesController.text.trim(),
      );

      // Pop back to dashboard and open the booking detail
      Get.back();
      Get.toNamed('${AppRoutes.dashboard}/booking', arguments: newId);
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = selectedDate == DateFormat('yyyy-MM-dd').format(now);

    return Scaffold(
      backgroundColor: ThemeColors.appBackground,
      appBar: AppBar(
        backgroundColor: ThemeColors.appBar,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ThemeColors.textWhite),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${isEquipment ? 'Order ' : 'Book '}${service.name}',
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (service.desc.isNotEmpty) ...[
              0.2.h.vs,
              Text(
                service.desc,
                style: TextStyle(
                  color: ThemeColors.textMuted,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        children: [
          // Section: Who is it for?
          _buildSectionTitle(isEquipment ? 'Who is it for?' : 'Who needs care?'),
          1.2.h.vs,
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: patientNameController,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.sp),
                  decoration: _inputDecoration(
                    label: 'Patient name',
                    hint: 'e.g. Sunita Mehta',
                  ),
                ),
              ),
              2.5.w.hs,
              Expanded(
                flex: 2,
                child: TextField(
                  controller: patientAgeController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.sp),
                  decoration: _inputDecoration(
                    label: 'Age',
                    hint: '72',
                  ),
                ),
              ),
            ],
          ),

          1.2.h.vs,

          // Relation Chips
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: relations.map((rel) {
              final isSelected = selectedRelation == rel;
              return ChoiceChip(
                label: Text(rel),
                selected: isSelected,
                onSelected: (val) {
                  setState(() => selectedRelation = rel);
                },
                selectedColor: ThemeColors.brandNavy,
                backgroundColor: ThemeColors.cardSurface,
                side: BorderSide(
                  color: isSelected ? ThemeColors.goldenAmber : ThemeColors.cardBorder,
                  width: isSelected ? 1.4 : 1,
                ),
                labelStyle: TextStyle(
                  color: isSelected ? ThemeColors.goldenAmber : ThemeColors.textLight,
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              );
            }).toList(),
          ),

          2.5.h.vs,

          // Section: Care plan / Rent or buy
          _buildSectionTitle(isEquipment ? 'Rent or buy' : 'Care plan'),
          1.2.h.vs,
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: service.options.map((opt) {
              final isSelected = selectedPlan == opt;
              return ChoiceChip(
                label: Text(opt),
                selected: isSelected,
                onSelected: (val) {
                  setState(() => selectedPlan = opt);
                },
                selectedColor: ThemeColors.brandNavy,
                backgroundColor: ThemeColors.cardSurface,
                side: BorderSide(
                  color: isSelected ? ThemeColors.goldenAmber : ThemeColors.cardBorder,
                  width: isSelected ? 1.4 : 1,
                ),
                labelStyle: TextStyle(
                  color: isSelected ? ThemeColors.goldenAmber : ThemeColors.textLight,
                  fontSize: 11.5.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              );
            }).toList(),
          ),

          2.5.h.vs,

          // Section: Start date / Delivery date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle(isEquipment ? 'Delivery date' : 'Start date'),
              Text(
                DateFormat('MMM yyyy').format(next7Days.first).toUpperCase(),
                style: TextStyle(
                  color: ThemeColors.textMuted,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          1.2.h.vs,

          // 7-day horizontal date selector
          SizedBox(
            height: 8.5.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: next7Days.length,
              separatorBuilder: (_, __) => 2.5.w.hs,
              itemBuilder: (context, i) {
                final d = next7Days[i];
                final iso = DateFormat('yyyy-MM-dd').format(d);
                final isSelected = selectedDate == iso;

                return InkWell(
                  onTap: () {
                    setState(() => selectedDate = iso);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 14.w,
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isSelected ? ThemeColors.goldenAmber : ThemeColors.cardSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? ThemeColors.goldenAmber : ThemeColors.cardBorder,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E').format(d).toUpperCase(),
                          style: TextStyle(
                            color: isSelected ? ThemeColors.deepNavy : ThemeColors.textMuted,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        0.4.h.vs,
                        Text(
                          '${d.day}',
                          style: TextStyle(
                            color: isSelected ? ThemeColors.deepNavy : ThemeColors.textWhite,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          2.5.h.vs,

          // Section: Preferred time / Delivery time
          _buildSectionTitle(isEquipment ? 'Delivery time' : 'Preferred time'),
          1.2.h.vs,
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: timeSlots.map((slot) {
              final isSelected = selectedTime == slot;

              // Check if slot has already passed today
              int slotHour = 9;
              if (slot.contains('7:00 AM')) slotHour = 7;
              if (slot.contains('9:00 AM')) slotHour = 9;
              if (slot.contains('11:00 AM')) slotHour = 11;
              if (slot.contains('2:00 PM')) slotHour = 14;
              if (slot.contains('5:00 PM')) slotHour = 17;
              if (slot.contains('8:00 PM')) slotHour = 20;

              final isPast = isToday && slotHour <= now.hour;

              return ChoiceChip(
                label: Text(slot),
                selected: isSelected,
                onSelected: isPast
                    ? null
                    : (val) {
                        setState(() => selectedTime = slot);
                      },
                selectedColor: ThemeColors.brandNavy,
                backgroundColor: isPast ? ThemeColors.cardSurface.withValues(alpha: 0.3) : ThemeColors.cardSurface,
                side: BorderSide(
                  color: isSelected ? ThemeColors.goldenAmber : ThemeColors.cardBorder,
                ),
                labelStyle: TextStyle(
                  color: isPast
                      ? ThemeColors.textMuted.withValues(alpha: 0.4)
                      : (isSelected ? ThemeColors.goldenAmber : ThemeColors.textLight),
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              );
            }).toList(),
          ),

          2.5.h.vs,

          // City Field
          _buildSectionTitle('City'),
          1.h.vs,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.4.h),
            decoration: BoxDecoration(
              color: ThemeColors.inputBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeColors.lineBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCity,
                dropdownColor: ThemeColors.cardSurface,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: ThemeColors.goldenAmber),
                isExpanded: true,
                items: clientData.cities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city.id,
                    child: Text(
                      city.name,
                      style: TextStyle(
                        color: ThemeColors.textWhite,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => selectedCity = val);
                },
              ),
            ),
          ),

          2.h.vs,

          // Address Field
          _buildSectionTitle(isEquipment ? 'Delivery address' : 'Visit address'),
          1.h.vs,
          TextField(
            controller: addressController,
            maxLines: 2,
            onChanged: (_) => setState(() {}),
            style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.sp),
            decoration: _inputDecoration(
              label: '',
              hint: 'Flat, building, area, Mumbai PIN',
            ),
          ),

          2.h.vs,

          // Notes Field
          _buildSectionTitle(
            isEquipment ? 'Notes (size, model, floor, lift…)' : 'Care notes for the nurse (optional)',
          ),
          1.h.vs,
          TextField(
            controller: notesController,
            maxLines: 2,
            style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.sp),
            decoration: _inputDecoration(
              label: '',
              hint: 'e.g. Diabetic, on insulin. Needs help walking.',
            ),
          ),

          10.h.vs, // Extra bottom padding for sticky bar
        ],
      ),

      // Sticky Bottom Footer Bar
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: ThemeColors.cardSurface,
          border: const Border(
            top: BorderSide(color: ThemeColors.cardBorder, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.shadowColorDark,
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Price Estimate
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.price > 0 ? 'Estimated' : 'Price',
                    style: TextStyle(
                      color: ThemeColors.textMuted,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  0.3.h.vs,
                  Text(
                    service.priceLabel,
                    style: TextStyle(
                      color: ThemeColors.goldenAmber,
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              4.w.hs,

              // Request Booking Button
              Expanded(
                child: SizedBox(
                  height: 5.4.h,
                  child: ElevatedButton(
                    onPressed: isFormValid && !isSubmitting ? _submitBooking : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.goldenAmber,
                      disabledBackgroundColor: ThemeColors.surface2,
                      foregroundColor: ThemeColors.deepNavy,
                      disabledForegroundColor: ThemeColors.textMuted,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: isFormValid ? 4 : 0,
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ThemeColors.deepNavy,
                            ),
                          )
                        : Text(
                            'Request booking',
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: ThemeColors.textWhite,
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  InputDecoration _inputDecoration({required String label, required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: ThemeColors.textPlaceholder),
      labelText: label.isNotEmpty ? label : null,
      labelStyle: const TextStyle(color: ThemeColors.textMuted),
      filled: true,
      fillColor: ThemeColors.inputBg,
      contentPadding: EdgeInsets.symmetric(horizontal: 3.8.w, vertical: 1.4.h),
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
        borderSide: const BorderSide(color: ThemeColors.goldenAmber, width: 1.4),
      ),
    );
  }
}
