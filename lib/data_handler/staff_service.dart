import 'dart:convert';
import 'package:eldoriaCare/model/alert_model.dart';
import 'package:eldoriaCare/model/booking_model.dart';
import 'package:eldoriaCare/model/staff_model.dart';
import 'package:eldoriaCare/model/users.dart';
import 'package:eldoriaCare/utils/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaffService {
  static const String _kStaffList = 'eldoria_staff_list_v1';
  static const String _kApplications = 'eldoria_applications_v1';
  static const String _kCurrentApplicantId = 'eldoria_applicant_id';
  static const String _kCurrentStaffId = 'eldoria_staff_id';
  static const String _kBookings = 'eldoria_bookings_v1';
  static const String _kAlerts = 'eldoria_alerts_v1';
  static const String _kOnDuty = 'eldoria_onduty_v1';

  static StaffService? _instance;
  static StaffService get instance => _instance ??= StaffService._();

  StaffService._();

  // ── City & Role Constants ──────────────────────────────────────────
  static const List<Map<String, String>> defaultCities = [
    {'id': 'mumbai', 'name': 'Mumbai'},
    {'id': 'thane', 'name': 'Thane'},
    {'id': 'navi-mumbai', 'name': 'Navi Mumbai'},
    {'id': 'pune', 'name': 'Pune'},
    {'id': 'nashik', 'name': 'Nashik'},
    {'id': 'nagpur', 'name': 'Nagpur'},
    {'id': 'delhi', 'name': 'Delhi'},
    {'id': 'gurugram', 'name': 'Gurugram'},
    {'id': 'noida', 'name': 'Noida'},
    {'id': 'bengaluru', 'name': 'Bengaluru'},
    {'id': 'hyderabad', 'name': 'Hyderabad'},
    {'id': 'chennai', 'name': 'Chennai'},
    {'id': 'kolkata', 'name': 'Kolkata'},
    {'id': 'ahmedabad', 'name': 'Ahmedabad'},
    {'id': 'surat', 'name': 'Surat'},
    {'id': 'jaipur', 'name': 'Jaipur'},
    {'id': 'lucknow', 'name': 'Lucknow'},
    {'id': 'chandigarh', 'name': 'Chandigarh'},
    {'id': 'indore', 'name': 'Indore'},
    {'id': 'goa', 'name': 'Goa'},
    {'id': 'dehradun', 'name': 'Dehradun'},
  ];

  static const List<String> roles = [
    'GNM Nurse',
    'ANM Nurse',
    'B.Sc Nurse',
    'ICU Nurse',
    'Elder Caregiver',
    'Patient Attendant',
    'Baby Care Nanny',
    'Physiotherapist',
  ];

  static const List<String> skills = [
    'Elder care',
    'Dementia / Alzheimer’s care',
    'Bedridden care',
    'ICU care',
    'Medication support',
    'Injections & IV',
    'Wound dressing',
    'Catheter care',
    'Ryles tube care',
    'Vital monitoring',
    'Post-surgery care',
    'Stroke & paralysis care',
    'Cancer & palliative care',
    'Parkinson’s care',
    'Newborn & baby care',
    'Mother & baby support',
    'Physiotherapy',
    'Night shifts',
    'Live-in care',
  ];

  static const List<String> languages = [
    'Hindi',
    'English',
    'Marathi',
    'Gujarati',
    'Bengali',
    'Tamil',
    'Telugu',
    'Kannada',
    'Malayalam',
    'Punjabi',
  ];

  static const List<String> availabilities = [
    'Day visits',
    '12-hr shifts',
    '24-hr live-in',
  ];

  static const List<Map<String, dynamic>> requiredDocs = [
    {
      'key': 'photo',
      'label': 'Profile photo',
      'hint': 'A clear photo of your face on a plain background',
      'required': true,
    },
    {
      'key': 'idProof',
      'label': 'Photo ID proof',
      'hint': 'Aadhaar, PAN, Voter ID, Passport or Driving licence',
      'required': true,
    },
    {
      'key': 'qualification',
      'label': 'Qualification certificate',
      'hint': 'GNM, ANM, B.Sc Nursing, BPT or caregiver course',
      'required': true,
    },
    {
      'key': 'experience',
      'label': 'Experience letter',
      'hint': 'From a hospital, agency or previous employer',
      'required': false,
    },
    {
      'key': 'police',
      'label': 'Police verification',
      'hint': 'If you already have one',
      'required': false,
    },
  ];

  // ── Seed Demo Staff ────────────────────────────────────────────────
  List<StaffModel> _defaultStaff() {
    return [
      StaffModel(
        id: 's1',
        name: 'Anjali Patil',
        role: 'GNM Nurse',
        phone: '9876543210',
        city: 'mumbai',
        area: 'Andheri, Versova',
        skills: ['Diabetic care', 'Injections & IV', 'Medication support'],
        languages: ['Hindi', 'Marathi', 'English'],
        availability: ['Day visits', '12-hr shifts'],
        docs: 'verified',
        onDuty: true,
        approval: 'approved',
      ),
      StaffModel(
        id: 's2',
        name: 'Rahul Kadam',
        role: 'Physiotherapist',
        phone: '9876543211',
        city: 'mumbai',
        area: 'Dadar, Worli',
        skills: ['Physiotherapy', 'Stroke & paralysis care', 'Post-surgery care'],
        languages: ['Hindi', 'Marathi', 'English'],
        availability: ['Day visits'],
        docs: 'verified',
        onDuty: true,
        approval: 'approved',
      ),
      StaffModel(
        id: 's3',
        name: 'Sushma More',
        role: 'Elder Caregiver',
        phone: '9876543212',
        city: 'mumbai',
        area: 'Borivali, Kandivali',
        skills: ['Elder care', 'Bedridden care', 'Dementia / Alzheimer’s care'],
        languages: ['Hindi', 'Marathi'],
        availability: ['12-hr shifts', '24-hr live-in'],
        docs: 'verified',
        onDuty: true,
        approval: 'approved',
      ),
      StaffModel(
        id: 's4',
        name: "Joseph D'Souza",
        role: 'ANM Nurse',
        phone: '9876543213',
        city: 'mumbai',
        area: 'Bandra, Khar',
        skills: ['Wound dressing', 'Injections & IV', 'Vital monitoring'],
        languages: ['English', 'Hindi'],
        availability: ['Day visits'],
        docs: 'verified',
        onDuty: false,
        approval: 'approved',
      ),
      StaffModel(
        id: 's5',
        name: 'Lata Pawar',
        role: 'GNM Nurse',
        phone: '9876543214',
        city: 'thane',
        area: 'Thane West',
        skills: ['Post-surgery care', 'Catheter care', 'Ryles tube care'],
        languages: ['Hindi', 'Marathi'],
        availability: ['Day visits', '12-hr shifts'],
        docs: 'verified',
        onDuty: true,
        approval: 'approved',
      ),
      StaffModel(
        id: 's6',
        name: 'Kiran Jadhav',
        role: 'Patient Attendant',
        phone: '9876543215',
        city: 'pune',
        area: 'Kothrud',
        skills: ['Elder care', 'Night shifts', 'Vital monitoring'],
        languages: ['Hindi', 'Marathi'],
        availability: ['12-hr shifts'],
        docs: 'verified',
        onDuty: false,
        approval: 'approved',
      ),
    ];
  }

  // ── Seed Demo Applications ─────────────────────────────────────────
  List<StaffModel> _defaultApplications() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return [
      StaffModel(
        id: 'app1',
        name: 'Neha Sawant',
        role: 'GNM Nurse',
        phone: '9811122233',
        email: 'neha@example.com',
        dob: '1996-08-14',
        gender: 'Female',
        city: 'mumbai',
        area: 'Andheri East',
        address: 'Room 14, Sai Krupa Chawl, Marol, Andheri East, Mumbai 400059',
        qualification: 'GNM Nursing, 2018',
        regNo: 'MNC-204511',
        experience: 6,
        skills: ['Elder care', 'Injections & IV', 'Wound dressing'],
        languages: ['Hindi', 'Marathi', 'English'],
        availability: ['Day visits', '12-hr shifts'],
        emergencyName: 'Sunil Sawant',
        emergencyPhone: '9811100011',
        emergencyRelation: 'Father',
        applied: true,
        approval: 'pending',
        docs: 'pending',
        onDuty: false,
        submittedAt: now - (95 * 60 * 1000),
        appHistory: [
          {
            'status': 'pending',
            'at': now - (95 * 60 * 1000),
            'by': 'applicant',
            'note': 'Application submitted',
          }
        ],
      ),
      StaffModel(
        id: 'app2',
        name: 'Priyanka Shinde',
        role: 'Elder Caregiver',
        phone: '9811122244',
        email: 'priyanka@example.com',
        dob: '1994-02-03',
        gender: 'Female',
        city: 'mumbai',
        area: 'Kurla West',
        address: 'Flat 6, Laxmi Niwas, Kurla West, Mumbai 400070',
        qualification: 'Caregiver certificate course, 2020',
        regNo: '',
        experience: 4,
        skills: ['Elder care', 'Bedridden care', 'Dementia / Alzheimer’s care'],
        languages: ['Hindi', 'Marathi'],
        availability: ['24-hr live-in'],
        emergencyName: 'Amit Shinde',
        emergencyPhone: '9811100022',
        emergencyRelation: 'Husband',
        applied: true,
        approval: 'changes',
        docs: 'pending',
        onDuty: false,
        reviewNote:
            'Your ID photo is blurry. Please upload a clearer photo of the front side.',
        submittedAt: now - (90 * 60 * 1000),
        appHistory: [
          {
            'status': 'changes',
            'at': now - (40 * 60 * 1000),
            'by': 'admin',
            'note':
                'Your ID photo is blurry. Please upload a clearer photo of the front side.',
          },
          {
            'status': 'pending',
            'at': now - (90 * 60 * 1000),
            'by': 'applicant',
            'note': 'Application submitted',
          }
        ],
      ),
      StaffModel(
        id: 'app3',
        name: 'Deepa Nair',
        role: 'B.Sc Nurse',
        phone: '9811122255',
        email: 'deepa@example.com',
        dob: '1990-11-21',
        gender: 'Female',
        city: 'mumbai',
        area: 'Chembur',
        address: '22, Shell Colony, Chembur, Mumbai 400071',
        qualification: 'B.Sc Nursing, 2012',
        regNo: 'MNC-118820',
        experience: 11,
        skills: ['Post-surgery care', 'Catheter care', 'Injections & IV'],
        languages: ['English', 'Hindi', 'Malayalam'],
        availability: ['Day visits', '12-hr shifts'],
        emergencyName: 'Ravi Nair',
        emergencyPhone: '9811100033',
        emergencyRelation: 'Brother',
        applied: true,
        approval: 'approved',
        docs: 'verified',
        onDuty: true,
        submittedAt: now - (85 * 60 * 1000),
        appHistory: [
          {
            'status': 'approved',
            'at': now - (30 * 60 * 1000),
            'by': 'admin',
            'note': 'Application approved by Care Desk',
          },
          {
            'status': 'pending',
            'at': now - (85 * 60 * 1000),
            'by': 'applicant',
            'note': 'Application submitted',
          }
        ],
      ),
    ];
  }

  // ── Staff List Operations ──────────────────────────────────────────
  Future<List<StaffModel>> getApprovedStaffList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_kStaffList);
    if (jsonStr == null || jsonStr.isEmpty) {
      final list = _defaultStaff();
      await prefs.setString(
        _kStaffList,
        jsonEncode(list.map((e) => e.toJson()).toList()),
      );
      return list;
    }

    try {
      final List decoded = jsonDecode(jsonStr);
      return decoded.map((e) => StaffModel.fromJson(e)).toList();
    } catch (_) {
      return _defaultStaff();
    }
  }

  // ── Applications Operations ────────────────────────────────────────
  Future<List<StaffModel>> getAllApplications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_kApplications);
    if (jsonStr == null || jsonStr.isEmpty) {
      final list = _defaultApplications();
      await prefs.setString(
        _kApplications,
        jsonEncode(list.map((e) => e.toJson()).toList()),
      );
      return list;
    }

    try {
      final List decoded = jsonDecode(jsonStr);
      return decoded.map((e) => StaffModel.fromJson(e)).toList();
    } catch (_) {
      return _defaultApplications();
    }
  }

  Future<StaffModel?> getApplicationById(String id) async {
    final all = await getAllApplications();
    return all.cast<StaffModel?>().firstWhere(
          (element) => element?.id == id,
          orElse: () => null,
        );
  }

  Future<StaffModel?> findApplicationByPhone(String rawPhone) async {
    final cleanDigits = rawPhone.replaceAll(RegExp(r'\D'), '');
    final phoneSuffix = cleanDigits.length >= 10
        ? cleanDigits.substring(cleanDigits.length - 10)
        : cleanDigits;

    final all = await getAllApplications();
    for (final app in all) {
      final appDigits = app.phone.replaceAll(RegExp(r'\D'), '');
      if (appDigits.endsWith(phoneSuffix)) {
        return app;
      }
    }
    return null;
  }

  Future<StaffModel?> getCurrentApplicant() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_kCurrentApplicantId);
    if (id == null || id.isEmpty) {
      // Default to app2 for demo inspection if none is set
      return getApplicationById('app2');
    }
    return getApplicationById(id);
  }

  Future<void> setCurrentApplicantId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCurrentApplicantId, id);
  }

  Future<void> saveApplication(StaffModel app) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await getAllApplications();
    final index = all.indexWhere((e) => e.id == app.id);

    if (index >= 0) {
      all[index] = app;
    } else {
      all.insert(0, app);
    }

    await prefs.setString(
      _kApplications,
      jsonEncode(all.map((e) => e.toJson()).toList()),
    );
    await prefs.setString(_kCurrentApplicantId, app.id);
  }

  // ── Authentication Bridge ──────────────────────────────────────────
  Future<void> loginAsStaff(StaffModel staff) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCurrentStaffId, staff.id);

    // Populate user profile in existing Preference system
    final userInfo = UserInfo(
      id: staff.id,
      name: staff.name,
      username: staff.name,
      email: staff.email ?? '${staff.phone}@eldoriacare.staff',
      role: 'STAFF',
      designation: staff.role,
      accessStatus: staff.approval,
      eldoriaCareId: staff.id,
      eldoriaCareName: 'Eldoria Care at Home',
    );

    final user = User(
      success: true,
      token: 'staff_jwt_${staff.id}_${DateTime.now().millisecondsSinceEpoch}',
      userInfo: userInfo,
    );

    Preference.setUser(user);
    await Preference.setLogin(true);
  }

  // ── Default Seed Bookings ───────────────────────────────────────────
  List<BookingModel> _defaultBookings() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return [
      BookingModel(
        id: 'b8',
        code: 'ELD-20409',
        city: 'mumbai',
        clientName: 'Farhan Shaikh',
        clientPhone: '9821077788',
        patientName: 'Farhan Shaikh',
        patientAge: '68',
        relation: 'Self',
        service: 'postsurgery',
        serviceName: 'Post-Surgery Care',
        plan: 'Single visit',
        date: 'Mon 5 Oct',
        time: '4:00 PM',
        address: 'Shastri Nagar, Jogeshwari West, Mumbai',
        notes: 'Hip surgery 10 days ago. Wound dressing and walking practice.',
        source: 'Call',
        status: 'assigned',
        staffId: 's1',
        confirmedBy: 'admin',
        assignedBy: 'admin',
        tasks: [
          TaskItem(label: 'Wound check & dressing', done: false),
          TaskItem(label: 'Pain & vitals check', done: false),
          TaskItem(label: 'Mobility exercises', done: false),
          TaskItem(label: 'Medication as prescribed', done: false),
        ],
        createdAt: now - (600 * 60 * 1000),
      ),
      BookingModel(
        id: 'b1',
        code: 'ELD-20418',
        city: 'mumbai',
        clientName: 'Priya Mehta',
        clientPhone: '9123456780',
        patientName: 'Sunita Mehta',
        patientAge: '72',
        relation: 'Mother',
        service: 'nursing',
        serviceName: 'Home Nursing',
        plan: 'Single visit',
        date: 'Today',
        time: '9:00 AM',
        address: 'Flat 402, Sea Breeze CHS, Lokhandwala, Andheri West, Mumbai',
        notes: 'Diabetic, on insulin. Check sugar before breakfast.',
        source: 'App',
        status: 'assigned',
        staffId: 's1',
        confirmedBy: 'admin',
        assignedBy: 'admin',
        tasks: [
          TaskItem(label: 'Check BP & SpO₂', done: false),
          TaskItem(label: 'Check blood sugar', done: false),
          TaskItem(label: 'Give medication as prescribed', done: false),
          TaskItem(label: 'Update family on visit', done: false),
        ],
        createdAt: now - (70 * 60 * 1000),
      ),
      BookingModel(
        id: 'b9',
        code: 'ELD-20388',
        city: 'mumbai',
        clientName: 'Vinod Rao',
        clientPhone: '9930044433',
        patientName: 'Vinod Rao',
        patientAge: '81',
        relation: 'Self',
        service: 'injection',
        serviceName: 'Injection Support',
        plan: 'Single visit',
        date: 'Mon 5 Oct',
        time: '7:00 AM',
        address: 'Yari Road, Versova, Mumbai',
        source: 'Call',
        status: 'completed',
        staffId: 's1',
        confirmedBy: 'admin',
        assignedBy: 'admin',
        visit: VisitVitals(
          bp: '132/86',
          spo2: '97',
          note: 'Injection given. Dressing changed, wound healing well.',
        ),
        checkInAt: now - (420 * 60 * 1000),
        checkOutAt: now - (380 * 60 * 1000),
        createdAt: now - (900 * 60 * 1000),
      ),
      BookingModel(
        id: 'b4',
        code: 'ELD-20431',
        city: 'mumbai',
        clientName: 'Kavita Desai',
        clientPhone: '9819012345',
        patientName: 'Shanta Desai',
        patientAge: '81',
        relation: 'Mother',
        service: 'attendant',
        serviceName: '24-Hour Care',
        plan: '24-hr live-in',
        date: 'Today',
        time: '9:00 AM',
        address: 'B-12, Gokul Dham, Borivali East',
        notes: 'Bedridden after a fall. Needs help with hygiene and feeding.',
        source: 'WhatsApp',
        status: 'requested',
        staffId: '',
        createdAt: now - (25 * 60 * 1000),
      ),
      BookingModel(
        id: 'b5',
        code: 'ELD-20425',
        city: 'mumbai',
        clientName: 'Arun Nair',
        clientPhone: '9820098765',
        patientName: 'Arun Nair',
        patientAge: '58',
        relation: 'Self',
        service: 'postsurgery',
        serviceName: 'Post-Surgery Care',
        plan: '12-hr shift',
        date: 'Today',
        time: '11:00 AM',
        address: '7, Sindhi Society, Chembur',
        notes: 'Discharged after bypass surgery yesterday.',
        source: 'Call',
        status: 'confirmed',
        confirmedBy: 'Care desk (admin)',
        staffId: '',
        createdAt: now - (40 * 60 * 1000),
      ),
      BookingModel(
        id: 'b12',
        code: 'ELD-34828',
        city: 'mumbai',
        clientName: 'Priya Mehta',
        clientPhone: '9123456780',
        patientName: 'Ramesh Mehta',
        patientAge: '76',
        relation: 'Father',
        service: 'caregiver',
        serviceName: 'Elderly Care',
        plan: '12-hr shift',
        date: 'Tomorrow',
        time: '9:00 AM',
        address: 'Flat 402, Sea Breeze CHS, Lokhandwala, Andheri West, Mumbai 400053',
        notes: 'Needs help walking and with evening medicines.',
        source: 'App',
        status: 'requested',
        staffId: '',
        createdAt: now - (12 * 60 * 1000),
      ),
    ];
  }

  // ── Default Seed Alerts ─────────────────────────────────────────────
  List<AlertModel> _defaultAlerts() {
    return [
      AlertModel(
        id: 'n1',
        to: 'staff:s1',
        title: 'New booking request ELD-20436',
        body: 'Injection & Dressing for Zubeida Khan, 67 · Today, 8:00 PM · Hill Road, Bandra West',
        time: '5 Oct, 11:54 AM',
        bookingId: 'b7',
        isRead: false,
      ),
      AlertModel(
        id: 'n2',
        to: 'staff:s1',
        title: 'New booking request ELD-34828',
        body: 'Elder Caregiver for Ramesh Mehta, 76 · 12-hr shift · Lokhandwala, Andheri West',
        time: '5 Oct, 11:50 AM',
        bookingId: 'b12',
        isRead: false,
      ),
      AlertModel(
        id: 'n3',
        to: 'staff:s1',
        title: 'New booking request ELD-20431',
        body: '24-hr Attendant for Shanta Desai, 81 · Tomorrow, 9:00 AM · B-12, Gokul Dham, Borivali East',
        time: '5 Oct, 11:37 AM',
        bookingId: 'b4',
        isRead: false,
      ),
      AlertModel(
        id: 'n4',
        to: 'staff:s1',
        title: 'New visit assigned',
        body: 'Farhan Shaikh · Post-Surgery Care · Today, 4:00 PM · Shastri Nagar, Jogeshwari West',
        time: '5 Oct, 2:12 AM',
        bookingId: 'b8',
        isRead: false,
      ),
    ];
  }

  Future<List<BookingModel>> getBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_kBookings);
    if (jsonStr == null || jsonStr.isEmpty) {
      final list = _defaultBookings();
      await prefs.setString(_kBookings, jsonEncode(list.map((e) => e.toJson()).toList()));
      return list;
    }
    try {
      final List decoded = jsonDecode(jsonStr);
      return decoded.map((e) => BookingModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _defaultBookings();
    }
  }

  Future<void> saveBookings(List<BookingModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kBookings, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  Future<void> updateBooking(BookingModel booking) async {
    final list = await getBookings();
    final idx = list.indexWhere((e) => e.id == booking.id);
    if (idx >= 0) {
      list[idx] = booking;
    } else {
      list.insert(0, booking);
    }
    await saveBookings(list);
  }

  Future<List<AlertModel>> getAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_kAlerts);
    if (jsonStr == null || jsonStr.isEmpty) {
      final list = _defaultAlerts();
      await prefs.setString(_kAlerts, jsonEncode(list.map((e) => e.toJson()).toList()));
      return list;
    }
    try {
      final List decoded = jsonDecode(jsonStr);
      return decoded.map((e) => AlertModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _defaultAlerts();
    }
  }

  Future<void> saveAlerts(List<AlertModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAlerts, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  Future<void> markAllAlertsRead() async {
    final list = await getAlerts();
    for (var a in list) {
      a.isRead = true;
    }
    await saveAlerts(list);
  }

  Future<void> setOnDuty(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnDuty, val);
  }

  Future<StaffModel> getCurrentStaff() async {
    final prefs = await SharedPreferences.getInstance();
    final staffId = prefs.getString(_kCurrentStaffId) ?? 's1';
    final allStaff = await getApprovedStaffList();
    return allStaff.firstWhere(
      (s) => s.id == staffId,
      orElse: () => _defaultStaff().first,
    );
  }
}
