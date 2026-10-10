class TaskItem {
  String label;
  bool done;

  TaskItem({required this.label, this.done = false});

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      label: json['label']?.toString() ?? '',
      done: json['done'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'label': label,
    'done': done,
  };
}

class VisitVitals {
  String bp;
  String sugar;
  String spo2;
  String note;

  VisitVitals({
    this.bp = '',
    this.sugar = '',
    this.spo2 = '',
    this.note = '',
  });

  factory VisitVitals.fromJson(Map<String, dynamic> json) {
    return VisitVitals(
      bp: json['bp']?.toString() ?? '',
      sugar: json['sugar']?.toString() ?? '',
      spo2: json['spo2']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'bp': bp,
    'sugar': sugar,
    'spo2': spo2,
    'note': note,
  };
}

class BookingModel {
  final String id;
  final String code;
  final String city;
  final String clientName;
  final String clientPhone;
  final String patientName;
  final String patientAge;
  final String relation;
  final String service;
  final String serviceName;
  final String plan;
  final String date;
  final String time;
  final String address;
  final String notes;
  final String source;
  String status;
  String staffId;
  String? confirmedBy;
  String? assignedBy;
  List<TaskItem> tasks;
  VisitVitals? visit;
  int? checkInAt;
  int? checkOutAt;
  final int createdAt;

  BookingModel({
    required this.id,
    required this.code,
    required this.city,
    required this.clientName,
    required this.clientPhone,
    required this.patientName,
    required this.patientAge,
    required this.relation,
    required this.service,
    required this.serviceName,
    required this.plan,
    required this.date,
    required this.time,
    required this.address,
    this.notes = '',
    this.source = 'App',
    required this.status,
    this.staffId = '',
    this.confirmedBy,
    this.assignedBy,
    List<TaskItem>? tasks,
    this.visit,
    this.checkInAt,
    this.checkOutAt,
    required this.createdAt,
  }) : tasks = tasks ?? [];

  bool get isRequested => status == 'requested';
  bool get isConfirmed => status == 'confirmed';
  bool get isAssigned => status == 'assigned';
  bool get isOnTheWay => status == 'on_the_way';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      city: json['city']?.toString() ?? 'mumbai',
      clientName: json['clientName']?.toString() ?? '',
      clientPhone: json['clientPhone']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? '',
      patientAge: json['patientAge']?.toString() ?? '',
      relation: json['relation']?.toString() ?? '',
      service: json['service']?.toString() ?? '',
      serviceName: json['serviceName']?.toString() ?? '',
      plan: json['plan']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      source: json['source']?.toString() ?? 'App',
      status: json['status']?.toString() ?? 'requested',
      staffId: json['staffId']?.toString() ?? '',
      confirmedBy: json['confirmedBy']?.toString(),
      assignedBy: json['assignedBy']?.toString(),
      tasks: (json['tasks'] as List<dynamic>?)
          ?.map((t) => TaskItem.fromJson(t as Map<String, dynamic>))
          .toList(),
      visit: json['visit'] != null
          ? VisitVitals.fromJson(json['visit'] as Map<String, dynamic>)
          : null,
      checkInAt: json['checkInAt'] as int?,
      checkOutAt: json['checkOutAt'] as int?,
      createdAt: json['createdAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'city': city,
    'clientName': clientName,
    'clientPhone': clientPhone,
    'patientName': patientName,
    'patientAge': patientAge,
    'relation': relation,
    'service': service,
    'serviceName': serviceName,
    'plan': plan,
    'date': date,
    'time': time,
    'address': address,
    'notes': notes,
    'source': source,
    'status': status,
    'staffId': staffId,
    'confirmedBy': confirmedBy,
    'assignedBy': assignedBy,
    'tasks': tasks.map((t) => t.toJson()).toList(),
    'visit': visit?.toJson(),
    'checkInAt': checkInAt,
    'checkOutAt': checkOutAt,
    'createdAt': createdAt,
  };
}
