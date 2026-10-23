import 'dart:convert';
import 'package:eldoriaCare/utils/const.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eldoriaCare/data_handler/repository.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/model/services_model.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/logger.dart';
import 'package:eldoriaCare/utils/preference.dart';
import 'package:eldoriaCare/utils/toasty.dart';

class BookServicesController extends GetxController {
  final patientNameController = TextEditingController();
  final patientAgeController = TextEditingController();
  final areaController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  final RxString patientName = ''.obs;
  final RxString address = ''.obs;
  final RxString fromEnquiry = ''.obs;
  final RxList<HelpFileItem> attachedFiles = <HelpFileItem>[].obs;
  final RxBool isUploading = false.obs;

  // ── Selections ──────────────────────────────────────────────────────────
  final RxString selectedRelation = 'Mother'.obs;
  final RxString selectedGender = 'female'.obs;
  final RxString selectedPlan = ''.obs;
  final RxString selectedDate = ''.obs;
  final RxString selectedTime = '9:00 AM'.obs;
  final RxString selectedCity = 'pune'.obs;

  // ── State ───────────────────────────────────────────────────────────────
  final Rxn<ServiceItem> currentService = Rxn<ServiceItem>();
  final RxBool isEquipment = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isLoading = false.obs;
  final RxString locationNotice = ''.obs;
  final RxBool isCityServiceable = true.obs;
  final RxList<DateTime> next7Days = <DateTime>[].obs;

  // ── Preset Lists ────────────────────────────────────────────────────────
  final List<String> relations = const [
    'Mother',
    'Father',
    'Self',
    'Spouse',
    'Grandparent',
    'Other',
  ];
  final List<String> genders = const ['female', 'male', 'other'];
  final List<String> timeSlots = const [
    '7:00 AM',
    '9:00 AM',
    '11:00 AM',
    '2:00 PM',
    '5:00 PM',
    '8:00 PM',
  ];

  @override
  void onInit() {
    super.onInit();
    patientNameController.addListener(() {
      patientName.value = patientNameController.text;
    });
    addressController.addListener(() {
      address.value = addressController.text;
    });
    _initDateSlots();
    _initDefaults();

    final args = Get.arguments;
    String serviceArg = 'nursing';
    if (args is Map) {
      if (args['serviceId'] != null) {
        serviceArg = args['serviceId'].toString();
      } else if (args['service'] != null) {
        serviceArg = args['service'].toString();
      }
      if (args['fromEnquiry'] != null) {
        fromEnquiry.value = args['fromEnquiry'].toString();
      }
      if (args['files'] is List) {
        final List rawFiles = args['files'];
        attachedFiles.assignAll(
          rawFiles.map(
            (f) => HelpFileItem.fromJson(Map<String, dynamic>.from(f)),
          ),
        );
      }
    } else if (args != null) {
      serviceArg = args.toString();
    }
    initService(serviceArg);
  }


  void _initDateSlots() {
    final now = DateTime.now();
    next7Days.assignAll(List.generate(7, (i) => now.add(Duration(days: i))));
    selectedDate.value = DateFormat('yyyy-MM-dd').format(next7Days.first);
  }

  Future<void> _initDefaults() async {
    try {
      final userStr = LocalDB.clientUserJson;
      if (userStr.isNotEmpty) {
        final u = jsonDecode(userStr);
        if (u['city'] != null && u['city'].toString().trim().isNotEmpty) {
          final raw = u['city'].toString().trim().toLowerCase();
          final matched = Const.cities.firstWhereOrNull(
            (c) => c.id.toLowerCase() == raw || c.name.toLowerCase() == raw,
          );
          if (matched != null) {
            selectedCity.value = matched.id;
          }
        }
        if (u['address'] != null && u['address'].toString().trim().isNotEmpty) {
          addressController.text = u['address'].toString().trim();
        }
      }
    } catch (_) {}

    if (Preference.isUserAvailable) {
      final prof = Preference.user.profile;
      if (prof != null) {
        if (prof.city != null && prof.city!.trim().isNotEmpty) {
          final raw = prof.city!.trim().toLowerCase();
          final matched = Const.cities.firstWhereOrNull(
            (c) => c.id.toLowerCase() == raw || c.name.toLowerCase() == raw,
          );
          if (matched != null) {
            selectedCity.value = matched.id;
          }
        }
        if (prof.area != null && prof.area!.trim().isNotEmpty) {
          areaController.text = prof.area!.trim();
        }
        if (prof.address != null &&
            prof.address!.trim().isNotEmpty &&
            addressController.text.isEmpty) {
          addressController.text = prof.address!.trim();
        }
      }
    }
  }

  void initService(String serviceId) {
    fetchRealServiceDetails(serviceId);
  }

  Future<void> fetchRealServiceDetails(String serviceId) async {
    isLoading.value = true;
    try {
      final response = await Repository.instance.getServices(
        city: selectedCity.value,
      );
      if (response != null && response is Map) {
        final parsed = ServicesResponse.fromJson(
          Map<String, dynamic>.from(response),
        );

        if (parsed.data?.location != null) {
          isCityServiceable.value = parsed.data!.location!.isServiceable;
          locationNotice.value = parsed.data!.location!.notice ?? '';
        } else {
          isCityServiceable.value = true;
          locationNotice.value = '';
        }

        if (parsed.success && parsed.data != null) {
          final sList = parsed.data!.services;
          final cList = parsed.data!.categories;

          final matched =
              sList.firstWhereOrNull((s) {
                return s.id?.toString().toLowerCase() ==
                        serviceId.toLowerCase() ||
                    s.serviceId.toLowerCase() == serviceId.toLowerCase() ||
                    s.name.toLowerCase() == serviceId.toLowerCase() ||
                    s.code.toLowerCase() == serviceId.toLowerCase();
              }) ??
              (sList.isNotEmpty ? sList.first : null);

          if (matched != null) {
            final cat = cList.firstWhereOrNull((c) {
              return c.id.toLowerCase() == matched.categoryId.toLowerCase() ||
                  c.categoryId.toLowerCase() ==
                      matched.categoryId.toLowerCase() ||
                  c.name.toLowerCase() == matched.category.toLowerCase();
            });

            final converted = ServiceItem(
              id: matched.serviceId.isNotEmpty
                  ? matched.serviceId
                  : (matched.id?.toString() ?? matched.name),
              categoryId: matched.categoryId.isNotEmpty
                  ? matched.categoryId
                  : (cat?.id ?? ''),
              name: matched.name,
              icon: matched.icon,
              desc: matched.desc,
              options: matched.options.isNotEmpty
                  ? matched.options
                  : const ['Single visit'],
              tasks: matched.tasks,
              price: matched.price,
              priceMode: matched.priceMode,
              unit: matched.unit,
            );

            currentService.value = converted;
            isEquipment.value =
                (cat?.kind == 'equipment') || (matched.kind == 'equipment');
            if (matched.options.isNotEmpty) {
              selectedPlan.value = matched.options.first;
            } else {
              selectedPlan.value = 'Single visit';
            }
          } else {
            currentService.value = ServiceItem(
              id: serviceId,
              categoryId: 'general',
              name: _formatServiceName(serviceId),
              icon: 'cross',
              desc: 'Professional care service at home.',
              options: const ['Single visit', '12-hr shift', '24-hr live-in'],
              price: 0,
              priceMode: 'contact',
              unit: 'per visit',
            );
            if (currentService.value!.options.isNotEmpty) {
              selectedPlan.value = currentService.value!.options.first;
            }
          }
        }
      }
    } catch (e) {
      Logger.e(tag: 'Fetch Real Service Details Error', value: e);
    } finally {
      if (currentService.value == null) {
        currentService.value = ServiceItem(
          id: serviceId,
          categoryId: 'general',
          name: _formatServiceName(serviceId),
          icon: 'cross',
          desc: 'Professional care service at home.',
          options: const ['Single visit', '12-hr shift', '24-hr live-in'],
          price: 0,
          priceMode: 'contact',
          unit: 'per visit',
        );
        selectedPlan.value = 'Single visit';
      }
      isLoading.value = false;
    }
  }

  String _formatServiceName(String id) {
    if (id.isEmpty) return 'Care Service';
    const map = {
      'senior': 'Senior Citizen Care',
      'caregiver': 'Elderly Care',
      'nursing': 'Home Nursing',
      'nurse12': '12-Hour Nursing Shift',
      'dressing': 'Wound Dressing & Care',
      'injection': 'Injections & IV Fluids',
      'catheter': 'Catheter Care & Change',
      'ryles': 'Ryles Tube Insertion',
      'attendant12': 'Patient Attendant (12 hrs)',
      'attendant': '24-Hour Care',
      'livein': 'Live-in Caregiver',
      'stroke': 'Stroke Patient Care',
      'paralysis': 'Paralysis Care',
      'postsurgery': 'Post-Surgery Care',
      'cancer': 'Cancer Patient Care',
      'physio': 'General Physiotherapy',
      'hbed': 'Hospital Bed',
      'wchair': 'Wheelchair',
      'oxygen': 'Oxygen Concentrator',
    };
    if (map.containsKey(id.toLowerCase())) return map[id.toLowerCase()]!;
    final words = id.replaceAll('-', ' ').replaceAll('_', ' ').split(' ');
    return words
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '')
        .join(' ');
  }

  Future<void> pickFile() async {
    if (attachedFiles.length >= 3 || isUploading.value) return;

    try {
      isUploading.value = true;
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        final f = result.files.first;
        attachedFiles.add(
          HelpFileItem(
            id: 'f_${DateTime.now().millisecondsSinceEpoch}',
            name: f.name,
            type: f.extension?.toLowerCase() == 'pdf'
                ? 'application/pdf'
                : 'image/jpeg',
            size: f.size,
            path: f.path,
          ),
        );
        Toasty.success('File attached');
      }
    } catch (e) {
      Logger.e(tag: 'Pick File Error', value: e);
      Toasty.failed('Could not attach file');
    } finally {
      isUploading.value = false;
    }
  }

  void removeFile(int index) {
    if (index >= 0 && index < attachedFiles.length) {
      attachedFiles.removeAt(index);
    }
  }

  bool get isFormValid {
    return patientName.value.trim().isNotEmpty &&
        address.value.trim().isNotEmpty &&
        selectedDate.value.isNotEmpty &&
        selectedTime.value.isNotEmpty;
  }

  void onRelationSelected(String rel) {
    selectedRelation.value = rel;
    if (rel == 'Father' || rel == 'Grandfather') {
      selectedGender.value = 'male';
    } else if (rel == 'Mother' || rel == 'Grandmother') {
      selectedGender.value = 'female';
    }
  }

  void onGenderSelected(String gender) {
    selectedGender.value = gender;
  }

  void onPlanSelected(String plan) {
    selectedPlan.value = plan;
  }

  void onDateSelected(String iso) {
    selectedDate.value = iso;
  }

  void onTimeSelected(String slot) {
    selectedTime.value = slot;
  }

  void onCitySelected(String? city) {
    if (city != null) {
      selectedCity.value = city;
      final currentSvcId = currentService.value?.id;
      if (currentSvcId != null && currentSvcId.isNotEmpty) {
        fetchRealServiceDetails(currentSvcId);
      }
    }
  }

  Future<void> submitBooking() async {
    if (!isFormValid || isSubmitting.value) return;

    isSubmitting.value = true;
    final s = currentService.value;
    if (s == null) {
      isSubmitting.value = false;
      return;
    }

    try {
      String cName = '';
      String cPhone = '';
      if (Preference.isUserAvailable) {
        if (Preference.user.userInfo?.name?.isNotEmpty == true) {
          cName = Preference.user.userInfo!.name!;
        }
        if (Preference.user.userInfo?.phone?.isNotEmpty == true) {
          cPhone = Preference.user.userInfo!.phone!;
        }
      }

      final payload = <String, dynamic>{
        "clientName": cName,
        "clientPhone": cPhone,
        "serviceId": s.id,
        "categoryId": s.categoryId,
        "plan": selectedPlan.value,
        "patientName": patientNameController.text.trim(),
        "patientAge": int.tryParse(patientAgeController.text.trim()) ?? 0,
        "patientGender": selectedGender.value.toLowerCase(),
        "relation": selectedRelation.value,
        "city": selectedCity.value.toLowerCase(),
        "area": areaController.text.trim(),
        "address": addressController.text.trim(),
        "date": selectedDate.value,
        "time": selectedTime.value,
        "notes": notesController.text.trim(),
        "source": "App",
        if (fromEnquiry.value.isNotEmpty) "fromEnquiry": fromEnquiry.value,
        if (attachedFiles.isNotEmpty)
          "files": attachedFiles.map((f) => f.toJson()).toList(),
      };

      final response = await Repository.instance.createBooking(payload);
      Logger.m(tag: 'Create Booking Response', value: response);

      Map<String, dynamic>? data;
      if (response != null && response is Map) {
        if (response['success'] == true) {
          if (response['data'] is Map) {
            data = Map<String, dynamic>.from(response['data']);
          }
        } else {
          final errorMsg =
              response['message']?.toString() ?? 'Failed to create booking';
          throw Exception(errorMsg);
        }
      }

      final now = DateTime.now();
      final id = data?['id']?.toString() ?? 'b_${now.millisecondsSinceEpoch}';
      final code =
          data?['code']?.toString() ??
          data?['bookingCode']?.toString() ??
          'ELD-${now.millisecondsSinceEpoch.toString().substring(7)}';

      final newBooking = BookingItem(
        id: id,
        code: code,
        city: selectedCity.value,
        serviceName: s.name,
        clientName: cName,
        clientPhone: cPhone,
        patientName: patientNameController.text.trim(),
        patientAge: patientAgeController.text.trim(),
        patientGender: selectedGender.value,
        relation: selectedRelation.value,
        service: s.id,
        serviceId: s.id,
        categoryId: s.categoryId,
        plan: selectedPlan.value,
        date: selectedDate.value,
        time: selectedTime.value,
        area: areaController.text.trim(),
        address: addressController.text.trim(),
        notes: notesController.text.trim(),
        status: data?['status']?.toString() ?? 'requested',
        staffId: data?['staffId']?.toString() ?? '',
        price: s.priceLabel,
        fromEnquiry: fromEnquiry.value.isNotEmpty ? fromEnquiry.value : null,
        files: List.from(attachedFiles),
        history: [
          HistoryEntry(
            status: 'requested',
            at: now.millisecondsSinceEpoch,
            by: 'client',
            note: 'Booking requested',
          ),
        ],
        createdAt: now.millisecondsSinceEpoch,
      );

      await _saveLocalBooking(newBooking);

      Toasty.success('Booking requested successfully!');
      Get.back();
      Get.toNamed(AppRoutes.booking, arguments: id);
    } catch (e) {
      Logger.e(tag: 'Submit Booking Error', value: e);
      Toasty.failed(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _saveLocalBooking(BookingItem b) async {
    try {
      final bStr = LocalDB.clientBookingsJson;
      List<BookingItem> list = [];
      if (bStr.isNotEmpty) {
        final List raw = jsonDecode(bStr);
        list = raw
            .map((e) => BookingItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      list.insert(0, b);
      await LocalDB.setClientBookingsJson(
        jsonEncode(list.map((e) => e.toJson()).toList()),
      );

      // Save notification
      final nStr = LocalDB.clientNotificationsJson;
      List<ClientNotificationItem> nList = [];
      if (nStr.isNotEmpty) {
        final List raw = jsonDecode(nStr);
        nList = raw
            .map(
              (e) =>
                  ClientNotificationItem.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList();
      }
      nList.insert(
        0,
        ClientNotificationItem(
          id: 'n_${b.createdAt}',
          to: 'client:${b.clientPhone}',
          title: 'Request received',
          body:
              "We'll confirm your ${b.serviceName} booking ${b.code} shortly.",
          bookingId: b.id,
          at: b.createdAt,
          read: false,
        ),
      );
      await LocalDB.setClientNotificationsJson(
        jsonEncode(nList.map((e) => e.toJson()).toList()),
      );
    } catch (_) {}
  }

  @override
  void onClose() {
    patientNameController.dispose();
    patientAgeController.dispose();
    areaController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
