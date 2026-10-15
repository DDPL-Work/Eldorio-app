import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/utils/preference.dart';
import 'package:eldoriaCare/utils/toasty.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ClientDataController extends GetxController {
  static ClientDataController get to => Get.isRegistered<ClientDataController>()
      ? Get.find<ClientDataController>()
      : Get.put(ClientDataController(), permanent: true);

  // ── Client User State ──────────────────────────────────────────────────
  final RxString clientName = 'Priya Mehta'.obs;
  final RxString clientPhone = '9123456780'.obs;
  final RxString clientCity = 'mumbai'.obs;
  final RxString clientAddress = 'Flat 402, Sea Breeze CHS, Lokhandwala, Andheri West'.obs;

  // Care Desk Contact Settings
  final RxString careDeskPhone = '9876543210'.obs;
  final RxString careDeskWhatsapp = '9876543210'.obs;

  // ── Catalog Collections ───────────────────────────────────────────────
  final RxList<CityItem> cities = <CityItem>[].obs;
  final RxList<CategoryItem> categories = <CategoryItem>[].obs;
  final RxList<ServiceItem> services = <ServiceItem>[].obs;
  final RxMap<String, StaffItem> staffMap = <String, StaffItem>{}.obs;

  // ── User Data Collections ─────────────────────────────────────────────
  final RxList<BookingItem> bookings = <BookingItem>[].obs;
  final RxList<HelpEnquiryItem> enquiries = <HelpEnquiryItem>[].obs;
  final RxList<ClientNotificationItem> notifications = <ClientNotificationItem>[].obs;

  // Recent celebrated booking code (for confetti animation overlay)
  final RxnString celebratedBookingCode = RxnString();

  static const String _kBookingsKey = 'eldoria_client_bookings_v2';
  static const String _kEnquiriesKey = 'eldoria_client_enquiries_v2';
  static const String _kNotificationsKey = 'eldoria_client_notifications_v2';
  static const String _kUserKey = 'eldoria_client_user_v2';

  @override
  void onInit() {
    super.onInit();
    _initCatalog();
    _initStaff();
    loadStoredData();
  }

  // ── Initialization of Catalog Data (from Client-app.html) ───────────
  void _initCatalog() {
    cities.assignAll([
      CityItem(id: 'mumbai', name: 'Mumbai', order: 1, phone: '9876543210', whatsapp: '9876543210'),
      CityItem(id: 'thane', name: 'Thane', order: 2, phone: '9876543214', whatsapp: '9876543214'),
      CityItem(id: 'navi-mumbai', name: 'Navi Mumbai', order: 3, phone: '9876543210', whatsapp: '9876543210'),
      CityItem(id: 'pune', name: 'Pune', order: 4, phone: '9876543215', whatsapp: '9876543215'),
      CityItem(id: 'nashik', name: 'Nashik', order: 5),
      CityItem(id: 'nagpur', name: 'Nagpur', order: 6),
      CityItem(id: 'delhi', name: 'Delhi', order: 7),
      CityItem(id: 'gurugram', name: 'Gurugram', order: 8),
      CityItem(id: 'noida', name: 'Noida', order: 9),
      CityItem(id: 'bengaluru', name: 'Bengaluru', order: 10),
      CityItem(id: 'hyderabad', name: 'Hyderabad', order: 11),
      CityItem(id: 'chennai', name: 'Chennai', order: 12),
      CityItem(id: 'kolkata', name: 'Kolkata', order: 13),
      CityItem(id: 'ahmedabad', name: 'Ahmedabad', order: 14),
      CityItem(id: 'surat', name: 'Surat', order: 15),
      CityItem(id: 'jaipur', name: 'Jaipur', order: 16),
      CityItem(id: 'lucknow', name: 'Lucknow', order: 17),
      CityItem(id: 'chandigarh', name: 'Chandigarh', order: 18),
      CityItem(id: 'indore', name: 'Indore', order: 19),
      CityItem(id: 'goa', name: 'Goa', order: 20),
      CityItem(id: 'dehradun', name: 'Dehradun', order: 21),
    ]);

    categories.assignAll([
      CategoryItem(
        id: 'elder',
        name: 'Elder Care',
        desc: 'Daily care, company and supervision for senior citizens.',
        icon: 'heart',
        kind: 'care',
        order: 1,
      ),
      CategoryItem(
        id: 'nursingcare',
        name: 'Home Nursing',
        desc: 'Qualified nurses for clinical care at home.',
        icon: 'cross',
        kind: 'care',
        order: 2,
      ),
      CategoryItem(
        id: 'caregivers',
        name: 'Caregiver & Patient Attendant',
        desc: 'Trained caregivers and attendants, by shift or live-in.',
        icon: 'users',
        kind: 'care',
        order: 3,
      ),
      CategoryItem(
        id: 'special',
        name: 'Specialized Patient Care',
        desc: 'Long-term and condition-specific care at home.',
        icon: 'shield',
        kind: 'care',
        order: 4,
      ),
      CategoryItem(
        id: 'babycare',
        name: 'Baby Care',
        desc: 'Newborn care, baby sitting and support for new mothers.',
        icon: 'baby',
        kind: 'care',
        order: 5,
      ),
      CategoryItem(
        id: 'physiotherapy',
        name: 'Physiotherapy',
        desc: 'Home physiotherapy and rehabilitation sessions.',
        icon: 'walker',
        kind: 'care',
        order: 6,
      ),
      CategoryItem(
        id: 'equipment',
        name: 'Medical Equipment',
        desc: 'Hospital beds, wheelchairs, oxygen and more on rent or sale.',
        icon: 'wheelchair',
        kind: 'equipment',
        order: 7,
      ),
      CategoryItem(
        id: 'doctors',
        name: 'Doctor Services',
        desc: 'Doctor consultations and home visits.',
        icon: 'steth',
        kind: 'doctor',
        order: 8,
        comingSoon: true,
      ),
    ]);

    const careOpts = ['12-hr day shift', '12-hr night shift', '24-hr live-in'];
    const visitOpts = ['Single visit', '3 visits pack', '7 visits pack'];
    const physioOpts = ['Single session', '5 sessions', '10 sessions'];
    const equipOpts = ['Rent · 1 week', 'Rent · 1 month', 'Buy'];
    const tElder = ['Bathing & sponge', 'Feeding support', 'Medicine reminders', 'Mobility & walking'];
    const tPhysio = ['Pain assessment', 'Mobility exercises', 'Joint mobilization', 'Home exercise chart'];
    const tEquip = ['Free delivery & setup', 'Sanitized & tested', 'Demonstration included', '24×7 support'];

    final sList = <ServiceItem>[
      // Elder Care
      ServiceItem(
        id: 'senior',
        categoryId: 'elder',
        name: 'Senior Citizen Care',
        icon: 'heart',
        desc: 'All-round daily support for senior citizens at home.',
        options: careOpts,
        tasks: tElder,
        order: 1,
      ),
      ServiceItem(
        id: 'caregiver',
        categoryId: 'elder',
        name: 'Elderly Care',
        icon: 'heart',
        desc: 'Daily living support: bathing, feeding, mobility and companionship.',
        options: careOpts,
        tasks: tElder,
        order: 2,
      ),
      ServiceItem(
        id: 'bedridden',
        categoryId: 'elder',
        name: 'Bedridden Patient Care',
        icon: 'bed',
        desc: 'Dedicated care, turning, hygiene and bed-sore prevention.',
        options: careOpts,
        tasks: ['Turn every 2 hours', 'Sponge bath & linen', 'Feed & hydrate', 'Bed-sore care'],
        price: 2000,
        unit: 'per day',
        order: 3,
      ),
      ServiceItem(
        id: 'dementia',
        categoryId: 'elder',
        name: 'Dementia Care',
        icon: 'brain',
        desc: 'Compassionate, routine-based care for seniors with memory loss.',
        options: careOpts,
        tasks: ['Structured routine', 'Gentle reminders', 'Safe mobility', 'Cognitive exercises'],
        order: 4,
      ),

      // Home Nursing
      ServiceItem(
        id: 'nursing',
        categoryId: 'nursingcare',
        name: 'Home Nursing',
        icon: 'cross',
        desc: 'Professional nursing for injections, vitals, post-surgery and IV.',
        options: visitOpts,
        tasks: ['Vitals check (BP, Sugar, SpO₂)', 'Prescribed medication', 'Clinical monitoring', 'Doctor report'],
        price: 450,
        order: 1,
      ),
      ServiceItem(
        id: 'injection',
        categoryId: 'nursingcare',
        name: 'Injection Support',
        icon: 'syringe',
        desc: 'IM, IV and subcutaneous injections given by a verified nurse.',
        options: ['Single injection', 'Course (3–7 days)'],
        tasks: ['Check prescription', 'Aseptic injection', 'Post-dose monitoring'],
        price: 350,
        order: 2,
      ),
      ServiceItem(
        id: 'iv',
        categoryId: 'nursingcare',
        name: 'IV Infusion',
        icon: 'droplet',
        desc: 'Saline, antibiotic and nutrient IV infusions at home.',
        options: ['Single infusion', 'Multi-day course'],
        tasks: ['Cannula insertion', 'Monitor flow rate', 'Vitals check during infusion'],
        price: 600,
        order: 3,
      ),
      ServiceItem(
        id: 'wound',
        categoryId: 'nursingcare',
        name: 'Wound Dressing',
        icon: 'bandage',
        desc: 'Sterile wound and surgical dressing at home.',
        options: visitOpts,
        tasks: ['Clean wound', 'Change dressing', 'Check for infection'],
        order: 4,
      ),
      ServiceItem(
        id: 'catheter',
        categoryId: 'nursingcare',
        name: 'Catheter Care',
        icon: 'droplet',
        desc: 'Catheter insertion, change and care.',
        options: visitOpts,
        tasks: ['Catheter hygiene', 'Change bag', 'Check for infection'],
        order: 5,
      ),
      ServiceItem(
        id: 'ryles',
        categoryId: 'nursingcare',
        name: 'Ryles Tube Care',
        icon: 'tube',
        desc: 'Ryles tube insertion, feeding and care.',
        options: visitOpts,
        tasks: ['Check tube position', 'Tube feeding', 'Clean & secure tube'],
        order: 6,
      ),
      ServiceItem(
        id: 'vitals',
        categoryId: 'nursingcare',
        name: 'Vital Monitoring',
        icon: 'pulse',
        desc: 'Regular BP, sugar, SpO₂ and temperature checks.',
        options: visitOpts,
        tasks: ['BP & pulse', 'Blood sugar', 'SpO₂ & temperature', 'Share report'],
        order: 7,
      ),

      // Caregivers
      ServiceItem(
        id: 'patientcg',
        categoryId: 'caregivers',
        name: 'Patient Caregiver',
        icon: 'users',
        desc: 'Trained caregiver for patients recovering at home.',
        options: careOpts,
        tasks: tElder,
        order: 1,
      ),
      ServiceItem(
        id: 'eldercg',
        categoryId: 'caregivers',
        name: 'Elder Caregiver',
        icon: 'heart',
        desc: 'Caregiver for elderly parents and grandparents.',
        options: careOpts,
        tasks: tElder,
        order: 2,
      ),
      ServiceItem(
        id: 'malecg',
        categoryId: 'caregivers',
        name: 'Male Caregiver',
        icon: 'male',
        desc: 'Male caregiver, helpful for lifting and male patients.',
        options: careOpts,
        tasks: tElder,
        order: 3,
      ),
      ServiceItem(
        id: 'femalecg',
        categoryId: 'caregivers',
        name: 'Female Caregiver',
        icon: 'female',
        desc: 'Female caregiver for women and elderly patients.',
        options: careOpts,
        tasks: tElder,
        order: 4,
      ),
      ServiceItem(
        id: 'care12',
        categoryId: 'caregivers',
        name: '12-Hour Care',
        icon: 'clock',
        desc: 'Day or night caregiver for a 12-hour shift.',
        options: ['12-hr day shift', '12-hr night shift'],
        tasks: tElder,
        order: 5,
      ),
      ServiceItem(
        id: 'attendant',
        categoryId: 'caregivers',
        name: '24-Hour Care',
        icon: 'clock',
        desc: 'Round-the-clock care with a caregiver on duty.',
        options: ['24-hr live-in'],
        tasks: ['Shift handover', 'Hygiene & meals', 'Night monitoring'],
        price: 2200,
        unit: 'per day',
        order: 6,
      ),
      ServiceItem(
        id: 'livein',
        categoryId: 'caregivers',
        name: 'Live-in Caregiver',
        icon: 'home',
        desc: 'Caregiver who stays at home, by week or month.',
        options: ['1 week', '1 month'],
        tasks: tElder,
        order: 7,
      ),

      // Specialized Patient Care
      ServiceItem(
        id: 'stroke',
        categoryId: 'special',
        name: 'Stroke Patient Care',
        icon: 'brain',
        desc: 'Care and daily rehab support after a stroke.',
        options: careOpts,
        tasks: ['Positioning & mobility', 'Feeding support', 'Exercises as advised', 'Vitals check'],
        order: 1,
      ),
      ServiceItem(
        id: 'paralysis',
        categoryId: 'special',
        name: 'Paralysis Care',
        icon: 'bed',
        desc: 'Care for patients with partial or full paralysis.',
        options: careOpts,
        tasks: ['Turn & position', 'Hygiene', 'Passive exercises', 'Bed-sore check'],
        order: 2,
      ),
      ServiceItem(
        id: 'postsurgery',
        categoryId: 'special',
        name: 'Post-Surgery Care',
        icon: 'bed',
        desc: 'Recovery care after hospital discharge, wound and mobility care.',
        options: careOpts,
        tasks: ['Wound check & dressing', 'Pain & vitals check', 'Mobility exercises', 'Medication as prescribed'],
        price: 1800,
        order: 3,
      ),
      ServiceItem(
        id: 'cancer',
        categoryId: 'special',
        name: 'Cancer Patient Care',
        icon: 'ribbon',
        desc: 'Gentle care during treatment and recovery.',
        options: careOpts,
        tasks: ['Medication on time', 'Nutrition support', 'Comfort care', 'Vitals check'],
        order: 4,
      ),
      ServiceItem(
        id: 'palliative',
        categoryId: 'special',
        name: 'Palliative Care',
        icon: 'hand',
        desc: 'Comfort-focused care for serious illness.',
        options: careOpts,
        tasks: ['Pain & comfort care', 'Hygiene', 'Emotional support', 'Family updates'],
        order: 5,
      ),
      ServiceItem(
        id: 'parkinsons',
        categoryId: 'special',
        name: 'Parkinson’s Care',
        icon: 'pulse',
        desc: 'Support with movement, routines and medication.',
        options: careOpts,
        tasks: ['Medication on time', 'Assisted walk', 'Fall prevention', 'Exercises'],
        order: 6,
      ),
      ServiceItem(
        id: 'alzheimers',
        categoryId: 'special',
        name: 'Alzheimer’s / Dementia Care',
        icon: 'brain',
        desc: 'Specialised memory care with a safe routine.',
        options: careOpts,
        tasks: ['Routine & reminders', 'Safety supervision', 'Meals & hygiene', 'Calming activities'],
        order: 7,
      ),

      // Baby Care
      ServiceItem(
        id: 'newborn',
        categoryId: 'babycare',
        name: 'Newborn Baby Care',
        icon: 'baby',
        desc: 'Trained nanny for newborn feeding, bathing and sleep.',
        options: ['12-hr shift', '24-hr live-in'],
        tasks: ['Bathing & massage', 'Feeding support', 'Sleep routine', 'Hygiene'],
        order: 1,
      ),
      ServiceItem(
        id: 'babysitter',
        categoryId: 'babycare',
        name: 'Baby Sitter',
        icon: 'baby',
        desc: 'Safe, caring baby sitter at home.',
        options: ['4-hr visit', '8-hr shift', '12-hr shift'],
        tasks: ['Play & feeding', 'Nap time', 'Hygiene'],
        order: 2,
      ),
      ServiceItem(
        id: 'motherbaby',
        categoryId: 'babycare',
        name: 'Mother & Baby Support',
        icon: 'heart',
        desc: 'Care for the new mother and baby after delivery.',
        options: ['12-hr shift', '24-hr live-in'],
        tasks: ['Mother care & diet', 'Baby bath & massage', 'Feeding support'],
        order: 3,
      ),

      // Physiotherapy
      ServiceItem(
        id: 'physio',
        categoryId: 'physiotherapy',
        name: 'Home Physiotherapy',
        icon: 'walker',
        desc: 'Home physio sessions for pain, injury and mobility.',
        options: physioOpts,
        tasks: tPhysio,
        price: 900,
        unit: 'per session',
        order: 1,
      ),
      ServiceItem(
        id: 'elderphysio',
        categoryId: 'physiotherapy',
        name: 'Elderly Physiotherapy',
        icon: 'walker',
        desc: 'Gentle physio to keep seniors strong and steady.',
        options: physioOpts,
        tasks: tPhysio,
        order: 2,
      ),
      ServiceItem(
        id: 'postsurgphysio',
        categoryId: 'physiotherapy',
        name: 'Post-Surgery Physiotherapy',
        icon: 'walker',
        desc: 'Rehab after knee, hip and other surgeries.',
        options: physioOpts,
        tasks: tPhysio,
        order: 3,
      ),
      ServiceItem(
        id: 'strokerehab',
        categoryId: 'physiotherapy',
        name: 'Stroke Rehabilitation',
        icon: 'brain',
        desc: 'Structured rehab to regain movement after a stroke.',
        options: physioOpts,
        tasks: tPhysio,
        order: 4,
      ),

      // Medical Equipment
      ServiceItem(
        id: 'hbed',
        categoryId: 'equipment',
        name: 'Hospital Bed',
        icon: 'bed',
        desc: 'Manual or motorised hospital bed with mattress.',
        options: equipOpts,
        tasks: tEquip,
        order: 1,
      ),
      ServiceItem(
        id: 'wchair',
        categoryId: 'equipment',
        name: 'Wheelchair',
        icon: 'wheelchair',
        desc: 'Foldable wheelchair for indoor and outdoor use.',
        options: equipOpts,
        tasks: tEquip,
        order: 2,
      ),
      ServiceItem(
        id: 'walkereq',
        categoryId: 'equipment',
        name: 'Walker',
        icon: 'walker',
        desc: 'Lightweight walker for safe walking.',
        options: ['Rent · 1 month', 'Buy'],
        tasks: tEquip,
        order: 3,
      ),
      ServiceItem(
        id: 'oxygen',
        categoryId: 'equipment',
        name: 'Oxygen Concentrator',
        icon: 'oxygen',
        desc: '5L / 10L oxygen concentrator with setup.',
        options: equipOpts,
        tasks: tEquip,
        order: 4,
      ),
      ServiceItem(
        id: 'otherequip',
        categoryId: 'equipment',
        name: 'Other Patient Care Equipment',
        icon: 'sofa',
        desc: 'Air mattress, commode chair, suction machine and more.',
        options: ['Rent', 'Buy'],
        tasks: tEquip,
        order: 5,
      ),

      // Doctor Services (Coming soon)
      ServiceItem(
        id: 'consult',
        categoryId: 'doctors',
        name: 'Doctor Consultation',
        icon: 'steth',
        desc: 'Talk to a doctor about symptoms and treatment.',
        options: ['Video call', 'Phone call'],
        tasks: const [],
        order: 1,
      ),
      ServiceItem(
        id: 'nearby',
        categoryId: 'doctors',
        name: 'Nearby Doctors',
        icon: 'pin',
        desc: 'Find trusted doctors near you.',
        options: ['Clinic visit'],
        tasks: const [],
        order: 2,
      ),
      ServiceItem(
        id: 'homedoctor',
        categoryId: 'doctors',
        name: 'Home Visit Doctor',
        icon: 'home',
        desc: 'A doctor visits the patient at home.',
        options: ['Single visit'],
        tasks: const [],
        order: 3,
      ),
    ];

    services.assignAll(sList);
  }

  void _initStaff() {
    staffMap.assignAll({
      's1': StaffItem(
        id: 's1',
        name: 'Anjali Patil',
        role: 'GNM Nurse',
        phone: '9876543210',
        city: 'mumbai',
        area: 'Andheri, Versova',
        skills: 'Diabetic care, injections',
        docs: 'verified',
        onDuty: true,
      ),
      's2': StaffItem(
        id: 's2',
        name: 'Rahul Kadam',
        role: 'Physiotherapist',
        phone: '9876543211',
        city: 'mumbai',
        area: 'Dadar, Worli',
        skills: 'Post-stroke, ortho rehab',
        docs: 'verified',
        onDuty: true,
      ),
      's3': StaffItem(
        id: 's3',
        name: 'Sushma More',
        role: 'Elder Caregiver',
        phone: '9876543212',
        city: 'mumbai',
        area: 'Borivali, Kandivali',
        skills: 'Bedridden care, 24-hr',
        docs: 'verified',
        onDuty: true,
      ),
      's4': StaffItem(
        id: 's4',
        name: "Joseph D'Souza",
        role: 'ANM Nurse',
        phone: '9876543213',
        city: 'mumbai',
        area: 'Bandra, Khar',
        skills: 'Wound dressing, IV',
        docs: 'verified',
        onDuty: false,
      ),
      's5': StaffItem(
        id: 's5',
        name: 'Lata Pawar',
        role: 'GNM Nurse',
        phone: '9876543214',
        city: 'thane',
        area: 'Thane West',
        skills: 'Post-surgery, catheter',
        docs: 'verified',
        onDuty: true,
      ),
      's6': StaffItem(
        id: 's6',
        name: 'Kiran Jadhav',
        role: 'Attendant',
        phone: '9876543215',
        city: 'pune',
        area: 'Kothrud',
        skills: 'Mobility, night shift',
        docs: 'pending',
        onDuty: false,
      ),
    });
  }

  // ── Persistence & Demo Data Initialization ────────────────────────────
  Future<void> loadStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load user
      final userStr = prefs.getString(_kUserKey);
      if (userStr != null && userStr.isNotEmpty) {
        final u = jsonDecode(userStr);
        clientName.value = u['name'] ?? clientName.value;
        clientPhone.value = u['phone'] ?? clientPhone.value;
        clientCity.value = u['city'] ?? clientCity.value;
        clientAddress.value = u['address'] ?? clientAddress.value;
      }

      // Load bookings
      final bStr = prefs.getString(_kBookingsKey);
      if (bStr != null && bStr.isNotEmpty) {
        final List bList = jsonDecode(bStr);
        bookings.assignAll(bList.map((e) => BookingItem.fromJson(Map<String, dynamic>.from(e))));
      } else {
        _loadDefaultBookings();
      }

      // Load enquiries
      final eStr = prefs.getString(_kEnquiriesKey);
      if (eStr != null && eStr.isNotEmpty) {
        final List eList = jsonDecode(eStr);
        enquiries.assignAll(eList.map((e) => HelpEnquiryItem.fromJson(Map<String, dynamic>.from(e))));
      } else {
        _loadDefaultEnquiries();
      }

      // Load notifications
      final nStr = prefs.getString(_kNotificationsKey);
      if (nStr != null && nStr.isNotEmpty) {
        final List nList = jsonDecode(nStr);
        notifications.assignAll(nList.map((e) => ClientNotificationItem.fromJson(Map<String, dynamic>.from(e))));
      } else {
        _loadDefaultNotifications();
      }
    } catch (e) {
      debugPrint('Error loading stored client data: $e');
      _loadDefaultBookings();
      _loadDefaultEnquiries();
      _loadDefaultNotifications();
    }
  }

  void _loadDefaultBookings() {
    final now = DateTime.now();
    String dayOffset(int days) {
      final d = now.add(Duration(days: days));
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }

    final nowMs = now.millisecondsSinceEpoch;
    int agoMin(int m) => nowMs - (m * 60 * 1000);

    bookings.assignAll([
      BookingItem(
        id: 'b1',
        code: 'ELD-20418',
        city: 'mumbai',
        serviceName: 'Home Nursing',
        clientName: 'Priya Mehta',
        clientPhone: '9123456780',
        patientName: 'Sunita Mehta',
        patientAge: '72',
        relation: 'Mother',
        service: 'nursing',
        plan: 'Single visit',
        date: dayOffset(1),
        time: '9:00 AM',
        address: 'Flat 402, Sea Breeze CHS, Lokhandwala, Andheri West',
        notes: 'Diabetic, on insulin. Check sugar before breakfast.',
        status: 'assigned',
        staffId: 's1',
        history: [
          HistoryEntry(status: 'requested', at: agoMin(70), by: 'client'),
          HistoryEntry(status: 'confirmed', at: agoMin(50), by: 'staff:s1', note: 'Booking confirmed'),
          HistoryEntry(status: 'assigned', at: agoMin(50), by: 'staff:s1', note: 'Anjali Patil assigned'),
        ],
        createdAt: agoMin(70),
      ),
      BookingItem(
        id: 'b2',
        code: 'ELD-19877',
        city: 'mumbai',
        serviceName: 'Home Physiotherapy',
        clientName: 'Priya Mehta',
        clientPhone: '9123456780',
        patientName: 'Ramesh Mehta',
        patientAge: '76',
        relation: 'Father',
        service: 'physio',
        plan: 'Single visit',
        date: dayOffset(-3),
        time: '5:00 PM',
        address: 'Flat 402, Sea Breeze CHS, Lokhandwala, Andheri West',
        notes: 'Knee replacement 6 weeks ago.',
        status: 'completed',
        staffId: 's2',
        visit: VisitReport(
          bp: '128/82',
          sugar: '',
          spo2: '98',
          note: 'Good progress on knee bend. Continue the 3 exercises twice a day. Next session in one week.',
        ),
        checkInAt: agoMin(60 * 24 * 3 + 60),
        checkOutAt: agoMin(60 * 24 * 3),
        history: [
          HistoryEntry(status: 'requested', at: agoMin(60 * 24 * 4), by: 'client'),
          HistoryEntry(status: 'confirmed', at: agoMin(60 * 24 * 4 - 30), by: 'admin'),
          HistoryEntry(status: 'assigned', at: agoMin(60 * 24 * 4 - 25), by: 'admin'),
          HistoryEntry(status: 'on_the_way', at: agoMin(60 * 24 * 3 + 80), by: 'staff:s2'),
          HistoryEntry(status: 'in_progress', at: agoMin(60 * 24 * 3 + 60), by: 'staff:s2'),
          HistoryEntry(status: 'completed', at: agoMin(60 * 24 * 3), by: 'staff:s2'),
        ],
        createdAt: agoMin(60 * 24 * 4),
      ),
      BookingItem(
        id: 'b12',
        code: 'ELD-34828',
        city: 'mumbai',
        serviceName: 'Elderly Care',
        clientName: 'Priya Mehta',
        clientPhone: '9123456780',
        patientName: 'Ramesh Mehta',
        patientAge: '76',
        relation: 'Father',
        service: 'caregiver',
        plan: '12-hr shift',
        date: dayOffset(2),
        time: '9:00 AM',
        address: 'Flat 402, Sea Breeze CHS, Lokhandwala, Andheri West, Mumbai 400053',
        notes: 'Needs help walking and with evening medicines.',
        status: 'requested',
        staffId: '',
        history: [
          HistoryEntry(status: 'requested', at: agoMin(12), by: 'client'),
        ],
        createdAt: agoMin(12),
      ),
    ]);
  }

  void _loadDefaultEnquiries() {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    int agoMin(int m) => nowMs - (m * 60 * 1000);

    enquiries.assignAll([
      HelpEnquiryItem(
        id: 'q1',
        code: 'HLP-40213',
        clientName: 'Priya Mehta',
        clientPhone: '9123456780',
        city: 'mumbai',
        area: 'Andheri West',
        address: 'Flat 402, Sea Breeze CHS, Lokhandwala, Andheri West',
        description:
            'My father had a mild stroke last month. He can walk with support but needs help with bathing and exercises. Not sure if we need a nurse, a caregiver or physiotherapy.',
        patientType: 'Stroke / paralysis',
        patientAge: '76',
        duration: '1 month or more',
        timing: 'Daytime',
        files: [
          HelpFileItem(
            id: 'fexp',
            name: 'discharge-summary.jpg',
            type: 'image/jpeg',
            size: 204800,
          ),
        ],
        status: 'new',
        history: [
          HistoryEntry(status: 'new', at: agoMin(18), by: 'client'),
        ],
        createdAt: agoMin(18),
      ),
    ]);
  }

  void _loadDefaultNotifications() {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    int agoMin(int m) => nowMs - (m * 60 * 1000);

    notifications.assignAll([
      ClientNotificationItem(
        id: 'n0',
        to: 'client:9123456780',
        title: 'Request received',
        body: "We'll confirm your Elderly Care booking ELD-34828 shortly.",
        bookingId: 'b12',
        at: agoMin(12),
        read: false,
      ),
      ClientNotificationItem(
        id: 'n1',
        to: 'client:9123456780',
        title: 'Caregiver assigned',
        body: 'Anjali Patil (GNM Nurse) will visit Sunita Mehta tomorrow at 9:00 AM.',
        bookingId: 'b1',
        at: agoMin(50),
        read: false,
      ),
      ClientNotificationItem(
        id: 'n2',
        to: 'client:9123456780',
        title: 'Booking confirmed',
        body: 'Your Home Nursing booking ELD-20418 is confirmed for tomorrow, 9:00 AM.',
        bookingId: 'b1',
        at: agoMin(51),
        read: true,
      ),
      ClientNotificationItem(
        id: 'n3',
        to: 'client:9123456780',
        title: 'Visit completed',
        body: 'Rahul Kadam completed the visit for Ramesh Mehta. Tap to see the visit report.',
        bookingId: 'b2',
        at: agoMin(60 * 24 * 3),
        read: true,
      ),
    ]);
  }

  Future<void> _saveBookings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kBookingsKey, jsonEncode(bookings.map((e) => e.toJson()).toList()));
  }

  Future<void> _saveEnquiries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kEnquiriesKey, jsonEncode(enquiries.map((e) => e.toJson()).toList()));
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kNotificationsKey, jsonEncode(notifications.map((e) => e.toJson()).toList()));
  }

  Future<void> saveClientUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kUserKey,
      jsonEncode({
        'name': clientName.value,
        'phone': clientPhone.value,
        'city': clientCity.value,
        'address': clientAddress.value,
      }),
    );
  }

  // ── Login / Demo Actions ─────────────────────────────────────────────
  Future<void> loginDemo() async {
    clientName.value = 'Priya Mehta';
    clientPhone.value = '9123456780';
    clientCity.value = 'mumbai';
    await saveClientUser();
    await Preference.setLogin(true);
  }

  Future<void> login({
    required String name,
    required String phone,
    required String city,
  }) async {
    clientName.value = name.trim();
    clientPhone.value = phone.trim();
    clientCity.value = city;
    await saveClientUser();
    await Preference.setLogin(true);
  }

  Future<void> logout() async {
    await Preference.setLogin(false);
    await Preference.clear();
  }

  // ── Booking Actions ──────────────────────────────────────────────────
  Future<String> createBooking({
    required String serviceId,
    required String patientName,
    required String patientAge,
    required String relation,
    required String plan,
    required String date,
    required String time,
    required String city,
    required String address,
    required String notes,
  }) async {
    final now = DateTime.now();
    final id = 'b_${now.millisecondsSinceEpoch}';
    final code = 'ELD-${now.millisecondsSinceEpoch.toString().substring(7)}';
    final s = getService(serviceId);
    final sName = s?.name ?? 'Care Service';

    final newBooking = BookingItem(
      id: id,
      code: code,
      city: city,
      serviceName: sName,
      clientName: clientName.value,
      clientPhone: clientPhone.value,
      patientName: patientName,
      patientAge: patientAge,
      relation: relation,
      service: serviceId,
      plan: plan,
      date: date,
      time: time,
      address: address,
      notes: notes,
      status: 'requested',
      staffId: '',
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

    // Save client address if given
    if (address.isNotEmpty) {
      clientAddress.value = address;
      saveClientUser();
    }

    bookings.insert(0, newBooking);
    await _saveBookings();

    // Trigger local notification
    notifications.insert(
      0,
      ClientNotificationItem(
        id: 'n_${now.millisecondsSinceEpoch}',
        to: 'client:${clientPhone.value}',
        title: 'Request received',
        body: "We'll confirm your $sName booking $code shortly.",
        bookingId: id,
        at: now.millisecondsSinceEpoch,
        read: false,
      ),
    );
    await _saveNotifications();

    // Trigger celebration
    celebratedBookingCode.value = code;

    return id;
  }

  Future<void> cancelBooking(String bookingId, {String? reason}) async {
    final idx = bookings.indexWhere((b) => b.id == bookingId);
    if (idx != -1) {
      final b = bookings[idx];
      final now = DateTime.now().millisecondsSinceEpoch;
      final updatedHistory = List<HistoryEntry>.from(b.history)
        ..add(HistoryEntry(
          status: 'cancelled',
          at: now,
          by: 'client',
          note: reason ?? 'Cancelled by client',
        ));

      bookings[idx] = b.copyWith(
        status: 'cancelled',
        cancelReason: reason ?? 'Cancelled by client',
        history: updatedHistory,
      );
      await _saveBookings();
      Toasty.normal('Booking cancelled');
    }
  }

  // ── Help Request Actions ─────────────────────────────────────────────
  Future<String> createHelpRequest({
    required String description,
    required String patientType,
    required String patientAge,
    required String city,
    required String address,
    required String duration,
    required String timing,
    List<HelpFileItem> files = const [],
  }) async {
    final now = DateTime.now();
    final id = 'q_${now.millisecondsSinceEpoch}';
    final code = 'HLP-${now.millisecondsSinceEpoch.toString().substring(7)}';

    final newEnquiry = HelpEnquiryItem(
      id: id,
      code: code,
      clientName: clientName.value,
      clientPhone: clientPhone.value,
      city: city,
      area: address,
      address: address,
      description: description,
      patientType: patientType,
      patientAge: patientAge,
      duration: duration,
      timing: timing,
      files: files,
      status: 'new',
      history: [
        HistoryEntry(
          status: 'new',
          at: now.millisecondsSinceEpoch,
          by: 'client',
          note: 'Help request submitted',
        ),
      ],
      createdAt: now.millisecondsSinceEpoch,
    );

    enquiries.insert(0, newEnquiry);
    await _saveEnquiries();

    // Trigger local notification
    notifications.insert(
      0,
      ClientNotificationItem(
        id: 'n_${now.millisecondsSinceEpoch}',
        to: 'client:${clientPhone.value}',
        title: 'Help request sent',
        body: 'Our care team will call you soon to recommend the right service.',
        enquiryId: id,
        at: now.millisecondsSinceEpoch,
        read: false,
      ),
    );
    await _saveNotifications();

    Toasty.success('Request sent to Eldoria care team');
    return id;
  }

  // ── Notification Actions ─────────────────────────────────────────────
  void markNotificationRead(String id) {
    final idx = notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      notifications[idx].read = true;
      notifications.refresh();
      _saveNotifications();
    }
  }

  void markAllNotificationsRead() {
    for (final n in notifications) {
      n.read = true;
    }
    notifications.refresh();
    _saveNotifications();
  }

  int get unreadNotificationsCount =>
      notifications.where((n) => !n.read).length;

  // ── Getters & Queries ────────────────────────────────────────────────
  BookingItem? get nextUpcomingBooking {
    final active = bookings.where((b) => b.isActive).toList();
    if (active.isEmpty) return null;
    return active.first;
  }

  List<BookingItem> get activeBookings =>
      bookings.where((b) => b.isActive).toList();

  List<BookingItem> get pastBookings =>
      bookings.where((b) => !b.isActive).toList();

  ServiceItem? getService(String? id) {
    if (id == null) return null;
    return services.firstWhereOrNull((s) => s.id == id);
  }

  CategoryItem? getCategory(String? id) {
    if (id == null) return null;
    return categories.firstWhereOrNull((c) => c.id == id);
  }

  StaffItem? getStaff(String? id) {
    if (id == null) return null;
    return staffMap[id];
  }

  BookingItem? getBooking(String? id) {
    if (id == null) return null;
    return bookings.firstWhereOrNull((b) => b.id == id);
  }

  HelpEnquiryItem? getEnquiry(String? id) {
    if (id == null) return null;
    return enquiries.firstWhereOrNull((e) => e.id == id);
  }

  List<ServiceItem> getServicesForCategory(String categoryId) {
    return services.where((s) => s.categoryId == categoryId).toList();
  }

  List<ServiceItem> searchServices(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return services.where((s) {
      final cat = getCategory(s.categoryId);
      final text = '${s.name} ${s.desc} ${cat?.name ?? ''}'.toLowerCase();
      return text.contains(q);
    }).toList();
  }

  String cityName(String cityId) {
    final c = cities.firstWhereOrNull((x) => x.id == cityId);
    return c?.name ?? cityId;
  }

  // ── Communication Actions (Call / WhatsApp) ──────────────────────────
  Future<void> makePhoneCall(String? phone) async {
    final p = (phone != null && phone.isNotEmpty)
        ? phone
        : careDeskPhone.value;
    final digits = p.replaceAll(RegExp(r'\D'), '');
    final url = 'tel:+91$digits';
    try {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        Toasty.info('Calling +91 $digits');
      }
    } catch (_) {
      Toasty.info('Calling +91 $digits');
    }
  }

  Future<void> openWhatsApp(String? phone, {String? text}) async {
    final p = (phone != null && phone.isNotEmpty)
        ? phone
        : careDeskWhatsapp.value;
    final digits = p.replaceAll(RegExp(r'\D'), '');
    final msg = Uri.encodeComponent(text ?? 'Hello Eldoria, I need help with home care.');
    final url = 'https://wa.me/91$digits?text=$msg';
    try {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      } else {
        Toasty.info('WhatsApp +91 $digits');
      }
    } catch (_) {
      Toasty.info('WhatsApp +91 $digits');
    }
  }
}
