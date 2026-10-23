import 'client_models.dart';

class BookingsResponse {
  final bool success;
  final String message;
  final List<BookingItem> data;

  BookingsResponse({
    this.success = false,
    this.message = '',
    this.data = const [],
  });

  factory BookingsResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BookingsResponse();

    final rawList = json['data'] is List ? (json['data'] as List) : [];
    return BookingsResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: rawList
          .whereType<Map>()
          .map((e) => BookingItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class BookingItem {
  final String id;
  final String code;
  final String? clientId;
  final String clientName;
  final String clientPhone;
  final String patientName;
  final String patientAge;
  final String patientGender;
  final String relation;
  final String serviceId;
  final String service;
  final String serviceName;
  final String? categoryId;
  final String? category;
  final String plan;
  final String city;
  final String area;
  final String address;
  final String date;
  final String time;
  final String status; // requested, confirmed, assigned, on_the_way, in_progress, completed, cancelled
  final String staffId;
  final String source;
  final String notes;
  final String price;
  final List<BookingTask> tasks;
  final VisitReport? visit;
  final String? confirmedBy;
  final String? confirmedAt;
  final String? assignedBy;
  final String? assignedAt;
  final dynamic checkInAt;
  final dynamic checkOutAt;
  final List<HistoryEntry> history;
  final int createdAt;
  final String? createdAtIso;
  final String? updatedAt;
  final AssignedStaff? assignedStaff;
  final String? cancelReason;
  final String? fromEnquiry;
  final List<HelpFileItem> files;

  BookingItem({
    required this.id,
    required this.code,
    this.clientId,
    required this.clientName,
    required this.clientPhone,
    required this.patientName,
    required this.patientAge,
    this.patientGender = '',
    required this.relation,
    this.serviceId = '',
    required this.service,
    required this.serviceName,
    this.categoryId,
    this.category,
    required this.plan,
    required this.city,
    this.area = '',
    required this.address,
    required this.date,
    required this.time,
    required this.status,
    this.staffId = '',
    this.source = 'App',
    this.notes = '',
    this.price = '0.00',
    this.tasks = const [],
    this.visit,
    this.confirmedBy,
    this.confirmedAt,
    this.assignedBy,
    this.assignedAt,
    this.checkInAt,
    this.checkOutAt,
    this.history = const [],
    required this.createdAt,
    this.createdAtIso,
    this.updatedAt,
    this.assignedStaff,
    this.cancelReason,
    this.fromEnquiry,
    this.files = const [],
  });

  bool get isActive =>
      status == 'requested' ||
      status == 'confirmed' ||
      status == 'assigned' ||
      status == 'on_the_way' ||
      status == 'in_progress';

  bool get canCancel =>
      status == 'requested' || status == 'confirmed' || status == 'assigned';

  String get effectiveServiceName {
    if (serviceName.isNotEmpty) return serviceName;
    if (service.isNotEmpty) return service;
    return 'Care Service';
  }

  String get formattedPrice {
    final clean = price.replaceAll(RegExp(r'[^\d.]'), '');
    final numVal = double.tryParse(clean) ?? 0.0;
    if (numVal > 0) {
      final formatted = numVal.toInt().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
      return '₹$formatted';
    }
    return '';
  }

  String get staffDisplayName {
    if (assignedStaff != null && assignedStaff!.name.isNotEmpty) {
      return assignedStaff!.name;
    }
    return '';
  }

  factory BookingItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return BookingItem(
        id: '',
        code: '',
        clientName: '',
        clientPhone: '',
        patientName: '',
        patientAge: '',
        relation: 'Mother',
        service: '',
        serviceName: '',
        plan: 'Single visit',
        city: 'mumbai',
        address: '',
        date: '',
        time: '',
        status: 'requested',
        createdAt: 0,
      );
    }

    // Parse tasks
    final List<BookingTask> taskList = [];
    if (json['tasks'] is List) {
      for (final t in json['tasks'] as List) {
        if (t is Map) {
          taskList.add(BookingTask.fromJson(Map<String, dynamic>.from(t)));
        }
      }
    }

    // Parse history safely
    final List<HistoryEntry> historyList = [];
    if (json['history'] is List) {
      for (final h in json['history'] as List) {
        if (h is Map) {
          historyList.add(HistoryEntry.fromJson(Map<String, dynamic>.from(h)));
        }
      }
    }

    // Parse createdAt millis
    int parsedCreatedAt = 0;
    if (json['createdAt'] is int) {
      parsedCreatedAt = json['createdAt'];
    } else if (json['createdAt'] != null) {
      final str = json['createdAt'].toString();
      final dt = DateTime.tryParse(str);
      if (dt != null) {
        parsedCreatedAt = dt.millisecondsSinceEpoch;
      } else {
        parsedCreatedAt = int.tryParse(str) ?? 0;
      }
    }

    // Parse assignedStaff safely
    AssignedStaff? staffObj;
    if (json['assignedStaff'] is Map<String, dynamic>) {
      staffObj = AssignedStaff.fromJson(
        Map<String, dynamic>.from(json['assignedStaff']),
      );
    }

    // Parse service & serviceName
    final sId = json['serviceId']?.toString() ?? json['service']?.toString() ?? '';
    final sName = json['serviceName']?.toString() ??
        json['category']?.toString() ??
        json['service']?.toString() ??
        '';

    return BookingItem(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      clientId: json['clientId']?.toString(),
      clientName: json['clientName']?.toString() ?? '',
      clientPhone: json['clientPhone']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? '',
      patientAge: json['patientAge']?.toString() ?? '',
      patientGender: json['patientGender']?.toString() ?? '',
      relation: json['relation']?.toString() ?? 'Mother',
      serviceId: sId,
      service: json['service']?.toString() ?? sId,
      serviceName: sName,
      categoryId: json['categoryId']?.toString(),
      category: json['category']?.toString(),
      plan: json['plan']?.toString() ?? 'Single visit',
      city: json['city']?.toString() ?? 'mumbai',
      area: json['area']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      status: json['status']?.toString() ?? 'requested',
      staffId: json['staffId']?.toString() ?? staffObj?.staffId ?? '',
      source: json['source']?.toString() ?? 'App',
      notes: json['notes']?.toString() ?? '',
      price: json['price']?.toString() ?? '0.00',
      tasks: taskList,
      visit: json['visit'] is Map && (json['visit'] as Map).isNotEmpty
          ? VisitReport.fromJson(Map<String, dynamic>.from(json['visit']))
          : null,
      confirmedBy: json['confirmedBy']?.toString(),
      confirmedAt: json['confirmedAt']?.toString(),
      assignedBy: json['assignedBy']?.toString(),
      assignedAt: json['assignedAt']?.toString(),
      checkInAt: json['checkInAt'],
      checkOutAt: json['checkOutAt'],
      history: historyList,
      createdAt: parsedCreatedAt,
      createdAtIso: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      assignedStaff: staffObj,
      cancelReason: json['cancelReason']?.toString(),
      fromEnquiry: json['fromEnquiry']?.toString(),
      files: json['files'] is List
          ? List<HelpFileItem>.from(
              (json['files'] as List)
                  .whereType<Map>()
                  .map((e) => HelpFileItem.fromJson(Map<String, dynamic>.from(e))),
            )
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        if (clientId != null) 'clientId': clientId,
        'clientName': clientName,
        'clientPhone': clientPhone,
        'patientName': patientName,
        'patientAge': patientAge,
        'patientGender': patientGender,
        'relation': relation,
        'serviceId': serviceId,
        'service': service,
        'serviceName': serviceName,
        if (categoryId != null) 'categoryId': categoryId,
        if (category != null) 'category': category,
        'plan': plan,
        'city': city,
        'area': area,
        'address': address,
        'date': date,
        'time': time,
        'status': status,
        'staffId': staffId,
        'source': source,
        'notes': notes,
        'price': price,
        'tasks': tasks.map((e) => e.toJson()).toList(),
        if (visit != null) 'visit': visit!.toJson(),
        if (confirmedBy != null) 'confirmedBy': confirmedBy,
        if (confirmedAt != null) 'confirmedAt': confirmedAt,
        if (assignedBy != null) 'assignedBy': assignedBy,
        if (assignedAt != null) 'assignedAt': assignedAt,
        if (checkInAt != null) 'checkInAt': checkInAt,
        if (checkOutAt != null) 'checkOutAt': checkOutAt,
        'history': history.map((e) => e.toJson()).toList(),
        'createdAt': createdAt,
        if (createdAtIso != null) 'createdAtIso': createdAtIso,
        if (updatedAt != null) 'updatedAt': updatedAt,
        if (assignedStaff != null) 'assignedStaff': assignedStaff!.toJson(),
        if (cancelReason != null) 'cancelReason': cancelReason,
        if (fromEnquiry != null) 'fromEnquiry': fromEnquiry,
        if (files.isNotEmpty) 'files': files.map((e) => e.toJson()).toList(),
      };

  BookingItem copyWith({
    String? status,
    String? cancelReason,
    String? staffId,
    List<HistoryEntry>? history,
    AssignedStaff? assignedStaff,
    String? fromEnquiry,
    List<HelpFileItem>? files,
  }) =>
      BookingItem(
        id: id,
        code: code,
        clientId: clientId,
        clientName: clientName,
        clientPhone: clientPhone,
        patientName: patientName,
        patientAge: patientAge,
        patientGender: patientGender,
        relation: relation,
        serviceId: serviceId,
        service: service,
        serviceName: serviceName,
        categoryId: categoryId,
        category: category,
        plan: plan,
        city: city,
        area: area,
        address: address,
        date: date,
        time: time,
        status: status ?? this.status,
        staffId: staffId ?? this.staffId,
        source: source,
        notes: notes,
        price: price,
        tasks: tasks,
        visit: visit,
        confirmedBy: confirmedBy,
        confirmedAt: confirmedAt,
        assignedBy: assignedBy,
        assignedAt: assignedAt,
        checkInAt: checkInAt,
        checkOutAt: checkOutAt,
        history: history ?? this.history,
        createdAt: createdAt,
        createdAtIso: createdAtIso,
        updatedAt: updatedAt,
        assignedStaff: assignedStaff ?? this.assignedStaff,
        cancelReason: cancelReason ?? this.cancelReason,
        fromEnquiry: fromEnquiry ?? this.fromEnquiry,
        files: files ?? this.files,
      );
}

class BookingTask {
  final bool done;
  final String label;

  BookingTask({this.done = false, this.label = ''});

  factory BookingTask.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BookingTask();
    return BookingTask(
      done: json['done'] == true || json['done']?.toString() == 'true',
      label: json['label']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'done': done,
        'label': label,
      };
}

class AssignedStaff {
  final int? id;
  final String staffId;
  final String qualification;
  final String city;
  final String area;
  final String docs;
  final bool onDuty;
  final AssignedStaffUser? user;

  AssignedStaff({
    this.id,
    this.staffId = '',
    this.qualification = '',
    this.city = '',
    this.area = '',
    this.docs = '',
    this.onDuty = false,
    this.user,
  });

  String get name =>
      user?.name.trim().isNotEmpty == true ? user!.name.trim() : 'Staff Member';
  String get phone => user?.phone.trim() ?? '';
  String get email => user?.email.trim() ?? '';

  String get initials {
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'ST';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length.clamp(0, 2)).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  factory AssignedStaff.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AssignedStaff();
    return AssignedStaff(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      staffId: json['staffId']?.toString() ?? '',
      qualification: json['qualification']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      docs: json['docs']?.toString() ?? '',
      onDuty: json['onDuty'] == true,
      user: json['user'] is Map<String, dynamic>
          ? AssignedStaffUser.fromJson(
              Map<String, dynamic>.from(json['user']),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'staffId': staffId,
        'qualification': qualification,
        'city': city,
        'area': area,
        'docs': docs,
        'onDuty': onDuty,
        'user': user?.toJson(),
      };
}

class AssignedStaffUser {
  final int? id;
  final String name;
  final String phone;
  final String email;

  AssignedStaffUser({
    this.id,
    this.name = '',
    this.phone = '',
    this.email = '',
  });

  factory AssignedStaffUser.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AssignedStaffUser();
    return AssignedStaffUser(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
      };
}

class HistoryEntry {
  final String status;
  final int at;
  final String atIso;
  final String by;
  final String? note;
  final String? staffId;

  HistoryEntry({
    required this.status,
    required this.at,
    this.atIso = '',
    required this.by,
    this.note,
    this.staffId,
  });

  factory HistoryEntry.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return HistoryEntry(status: '', at: 0, by: 'client');
    }

    int parsedAt = 0;
    if (json['at'] is int) {
      parsedAt = json['at'];
    } else if (json['at'] != null) {
      final str = json['at'].toString();
      final dt = DateTime.tryParse(str);
      if (dt != null) {
        parsedAt = dt.millisecondsSinceEpoch;
      } else {
        parsedAt = int.tryParse(str) ?? 0;
      }
    }

    return HistoryEntry(
      status: json['status']?.toString() ?? '',
      at: parsedAt,
      atIso: json['at']?.toString() ?? '',
      by: json['by']?.toString() ?? 'client',
      note: json['note']?.toString(),
      staffId: json['staffId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'at': at,
        if (atIso.isNotEmpty) 'atIso': atIso,
        'by': by,
        if (note != null) 'note': note,
        if (staffId != null) 'staffId': staffId,
      };
}

class VisitReport {
  final String? bp;
  final String? sugar;
  final String? spo2;
  final String? note;

  VisitReport({this.bp, this.sugar, this.spo2, this.note});

  factory VisitReport.fromJson(Map<String, dynamic>? json) {
    if (json == null) return VisitReport();
    return VisitReport(
      bp: json['bp']?.toString(),
      sugar: json['sugar']?.toString(),
      spo2: json['spo2']?.toString(),
      note: json['note']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (bp != null) 'bp': bp,
        if (sugar != null) 'sugar': sugar,
        if (spo2 != null) 'spo2': spo2,
        if (note != null) 'note': note,
      };
}
