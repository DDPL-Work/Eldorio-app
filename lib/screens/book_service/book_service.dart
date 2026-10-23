import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/widget/care_desk_buttons.dart';
import 'package:eldoriaCare/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eldoriaCare/screens/book_service/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class BookServiceScreen extends StatelessWidget {
  const BookServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(BookServicesController());
    final now = DateTime.now();

    return Obx(() {
      final s = c.currentService.value;
      if (s == null) {
        return const Scaffold(
          backgroundColor: ThemeColors.appBackground,
          body: Center(
            child: CircularProgressIndicator(color: ThemeColors.goldenAmber),
          ),
        );
      }

      final isEquipment = c.isEquipment.value;
      final isToday =
          c.selectedDate.value == DateFormat('yyyy-MM-dd').format(now);

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
                '${isEquipment ? 'Order ' : 'Book '}${s.name}',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (s.desc.isNotEmpty) ...[
                0.2.h.vs,
                Text(
                  s.desc,
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
            // Unserviceable Location Banner
            if (!c.isCityServiceable.value ||
                c.locationNotice.value.isNotEmpty) ...[
              UnserviceableBanner(
                city: c.selectedCity.value,
                notice: c.locationNotice.value,
              ),
              2.h.vs,
            ],

            // Patient Info Section
            FormSectionTitle(
              isEquipment ? 'Who is it for?' : 'Who needs care?',
            ),
            1.2.h.vs,
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomBookingTextField(
                    controller: c.patientNameController,
                    label: 'Patient name',
                    hint: 'e.g. Sunita Mehta',
                  ),
                ),
                2.5.w.hs,
                Expanded(
                  flex: 2,
                  child: CustomBookingTextField(
                    controller: c.patientAgeController,
                    keyboardType: TextInputType.number,
                    label: 'Age',
                    hint: '72',
                  ),
                ),
              ],
            ),

            1.2.h.vs,

            // Relation Chips
            HorizontalChoiceList<String>(
              items: c.relations,
              selectedItem: c.selectedRelation.value,
              onSelected: c.onRelationSelected,
              labelBuilder: (rel) => rel,
            ),

            1.5.h.vs,

            // Gender Selection Row
            Row(
              children: [
                Text(
                  'Gender:',
                  style: TextStyle(
                    color: ThemeColors.textMuted,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                2.5.w.hs,
                Expanded(
                  child: HorizontalChoiceList<String>(
                    items: c.genders,
                    selectedItem: c.selectedGender.value,
                    onSelected: c.onGenderSelected,
                    labelBuilder: (g) => g[0].toUpperCase() + g.substring(1),
                  ),
                ),
              ],
            ),

            2.5.h.vs,

            // Care Plan / Rent Options Section
            FormSectionTitle(isEquipment ? 'Rent or buy' : 'Care plan'),
            1.2.h.vs,
            HorizontalChoiceList<String>(
              items: s.options,
              selectedItem: c.selectedPlan.value,
              onSelected: c.onPlanSelected,
              labelBuilder: (opt) => opt,
            ),

            2.5.h.vs,

            // Date Selection Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormSectionTitle(isEquipment ? 'Delivery date' : 'Start date'),
                if (c.next7Days.isNotEmpty)
                  Text(
                    DateFormat(
                      'MMM yyyy',
                    ).format(c.next7Days.first).toUpperCase(),
                    style: TextStyle(
                      color: ThemeColors.textMuted,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            1.2.h.vs,
            DateSelectorBar(
              dates: c.next7Days,
              selectedDateIso: c.selectedDate.value,
              onDateSelected: c.onDateSelected,
            ),

            2.5.h.vs,

            // Preferred Time Section
            FormSectionTitle(isEquipment ? 'Delivery time' : 'Preferred time'),
            1.2.h.vs,
            HorizontalChoiceList<String>(
              items: c.timeSlots,
              selectedItem: c.selectedTime.value,
              onSelected: c.onTimeSelected,
              labelBuilder: (slot) => slot,
              isDisabled: (slot) {
                int slotHour = 9;
                if (slot.contains('7:00 AM')) slotHour = 7;
                if (slot.contains('9:00 AM')) slotHour = 9;
                if (slot.contains('11:00 AM')) slotHour = 11;
                if (slot.contains('2:00 PM')) slotHour = 14;
                if (slot.contains('5:00 PM')) slotHour = 17;
                if (slot.contains('8:00 PM')) slotHour = 20;
                return isToday && slotHour <= now.hour;
              },
            ),

            2.5.h.vs,

            // Location Fields
            FormSectionTitle('City'),
            1.h.vs,
            CityDropdown(
              height: 5.6.h,
              width: double.infinity,
              color: ThemeColors.inputBg,
              selectedCity: c.selectedCity.value,
              onChanged: c.onCitySelected,
            ),

            2.h.vs,

            FormSectionTitle('Area / Locality'),
            1.h.vs,
            CustomBookingTextField(
              controller: c.areaController,
              hint: 'e.g. Andheri West, Karanpur',
            ),

            2.h.vs,

            FormSectionTitle(
              isEquipment ? 'Delivery address' : 'Visit address',
            ),
            1.h.vs,
            CustomBookingTextField(
              controller: c.addressController,
              maxLines: 2,
              hint: 'Flat, building, area, Mumbai PIN',
            ),

            2.h.vs,

            // Care Notes Field
            FormSectionTitle(
              isEquipment
                  ? 'Notes (size, model, floor, lift…)'
                  : 'Care notes for the nurse (optional)',
            ),
            1.h.vs,
            CustomBookingTextField(
              controller: c.notesController,
              maxLines: 2,
              hint: 'e.g. Diabetic, on insulin. Needs help walking.',
            ),

            2.h.vs,

            // Document / Photo Section
            FormSectionTitle('Document or photo (optional)'),
            0.4.h.vs,
            Text(
              'Prescription, discharge summary or medical report (optional). Up to 3 files.',
              style: TextStyle(color: ThemeColors.textMuted, fontSize: 11.sp),
            ),
            1.4.h.vs,

            FileAttachmentPicker(controller: c),

            10.h.vs,
          ],
        ),

        // Sticky Bottom Footer Bar
        bottomNavigationBar: StickyBookingFooter(
          priceLabel: s.priceLabel,
          hasPrice: s.price > 0,
          isFormValid: c.isFormValid,
          isSubmitting: c.isSubmitting.value,
          onSubmit: c.submitBooking,
        ),
      );
    });
  }
}

// ── Reusable Component Widgets ──────────────────────────────────────────────

class CustomBookingTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String label;
  final TextInputType keyboardType;
  final int maxLines;

  const CustomBookingTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label = '',
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: ThemeColors.textPlaceholder),
        labelText: label.isNotEmpty ? label : null,
        labelStyle: const TextStyle(color: ThemeColors.textMuted),
        filled: true,
        fillColor: ThemeColors.inputBg,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 3.8.w,
          vertical: 1.4.h,
        ),
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
          borderSide: const BorderSide(
            color: ThemeColors.goldenAmber,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class FormSectionTitle extends StatelessWidget {
  final String title;

  const FormSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: ThemeColors.textWhite,
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class HorizontalChoiceList<T> extends StatelessWidget {
  final List<T> items;
  final T selectedItem;
  final ValueChanged<T> onSelected;
  final String Function(T) labelBuilder;
  final bool Function(T)? isDisabled;

  const HorizontalChoiceList({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
    required this.labelBuilder,
    this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          final isSelected = selectedItem == item;
          final disabled = isDisabled?.call(item) ?? false;

          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: ChoiceChip(
              label: Text(labelBuilder(item)),
              selected: isSelected,
              onSelected: disabled
                  ? null
                  : (val) {
                      if (val) onSelected(item);
                    },
              selectedColor: ThemeColors.brandNavy,
              backgroundColor: disabled
                  ? ThemeColors.cardSurface.withValues(alpha: 0.3)
                  : ThemeColors.cardSurface,
              side: BorderSide(
                color: isSelected
                    ? ThemeColors.goldenAmber
                    : ThemeColors.cardBorder,
                width: isSelected ? 1.4 : 1,
              ),
              labelStyle: TextStyle(
                color: disabled
                    ? ThemeColors.textMuted.withValues(alpha: 0.4)
                    : (isSelected
                          ? ThemeColors.goldenAmber
                          : ThemeColors.textLight),
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DateSelectorBar extends StatelessWidget {
  final List<DateTime> dates;
  final String selectedDateIso;
  final ValueChanged<String> onDateSelected;

  const DateSelectorBar({
    super.key,
    required this.dates,
    required this.selectedDateIso,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.5.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, _) => 2.5.w.hs,
        itemBuilder: (context, i) {
          final d = dates[i];
          final iso = DateFormat('yyyy-MM-dd').format(d);
          final isSelected = selectedDateIso == iso;

          return InkWell(
            onTap: () => onDateSelected(iso),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 14.w,
              padding: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? ThemeColors.goldenAmber
                    : ThemeColors.cardSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? ThemeColors.goldenAmber
                      : ThemeColors.cardBorder,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(d).toUpperCase(),
                    style: TextStyle(
                      color: isSelected
                          ? ThemeColors.deepNavy
                          : ThemeColors.textMuted,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  0.4.h.vs,
                  Text(
                    '${d.day}',
                    style: TextStyle(
                      color: isSelected
                          ? ThemeColors.deepNavy
                          : ThemeColors.textWhite,
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
    );
  }
}

class UnserviceableBanner extends StatelessWidget {
  final String city;
  final String notice;

  const UnserviceableBanner({
    super.key,
    required this.city,
    required this.notice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: ThemeColors.infoBlueBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.brandBlue.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_off_rounded,
                color: ThemeColors.goldenAmber,
                size: 24,
              ),
              2.5.w.hs,
              Expanded(
                child: Text(
                  'Service Unavailable in ${city.toUpperCase()}',
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          1.h.vs,
          Text(
            notice.isNotEmpty
                ? notice
                : 'Eldoria Care is not currently operational in $city. Select another city or contact our Care Desk below.',
            style: TextStyle(
              color: ThemeColors.textSoftBlue,
              fontSize: 11.5.sp,
              height: 1.35,
            ),
          ),
          1.5.h.vs,
          const CareDeskButtons(),
        ],
      ),
    );
  }
}

class FileAttachmentPicker extends StatelessWidget {
  final BookServicesController controller;

  const FileAttachmentPicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 3.w,
        runSpacing: 1.5.h,
        children: [
          ...controller.attachedFiles.asMap().entries.map((entry) {
            final idx = entry.key;
            final file = entry.value;
            return _buildThumbnail(idx, file);
          }),
          if (controller.attachedFiles.length < 3) _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildThumbnail(int index, HelpFileItem file) {
    return Container(
      width: 24.w,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(
            file.type == 'application/pdf'
                ? Icons.picture_as_pdf_rounded
                : Icons.image_rounded,
            color: ThemeColors.goldenAmber,
            size: 32,
          ),
          0.4.h.vs,
          Text(
            file.name,
            style: TextStyle(color: ThemeColors.textWhite, fontSize: 9.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          0.4.h.vs,
          InkWell(
            onTap: () => controller.removeFile(index),
            child: Text(
              'Remove',
              style: TextStyle(
                color: ThemeColors.errorRedColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: controller.pickFile,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 24.w,
        height: 11.h,
        decoration: BoxDecoration(
          color: ThemeColors.inputBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ThemeColors.lineBorder,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            controller.isUploading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ThemeColors.goldenAmber,
                    ),
                  )
                : const Icon(
                    Icons.cloud_upload_rounded,
                    color: ThemeColors.goldenAmber,
                    size: 24,
                  ),
            0.6.h.vs,
            Text(
              'Add file',
              style: TextStyle(
                color: ThemeColors.textMuted,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StickyBookingFooter extends StatelessWidget {
  final String priceLabel;
  final bool hasPrice;
  final bool isFormValid;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const StickyBookingFooter({
    super.key,
    required this.priceLabel,
    required this.hasPrice,
    required this.isFormValid,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        border: const Border(
          top: BorderSide(color: ThemeColors.cardBorder, width: 1),
        ),
        boxShadow: const [
          BoxShadow(
            color: ThemeColors.shadowColorDark,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasPrice ? 'Estimated' : 'Price',
                  style: TextStyle(
                    color: ThemeColors.textMuted,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                0.3.h.vs,
                Text(
                  priceLabel,
                  style: TextStyle(
                    color: ThemeColors.goldenAmber,
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            4.w.hs,
            Expanded(
              child: SizedBox(
                height: 5.4.h,
                child: ElevatedButton(
                  onPressed: isFormValid && !isSubmitting ? onSubmit : null,
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
    );
  }
}
