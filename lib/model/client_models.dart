import 'package:flutter/material.dart';

class CityItem {
  final String id;
  final String name;
  final int order;
  final String phone;
  final String whatsapp;

  CityItem({
    required this.id,
    required this.name,
    required this.order,
    this.phone = '',
    this.whatsapp = '',
  });

  factory CityItem.fromJson(Map<String, dynamic> json) => CityItem(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        order: json['order'] is int ? json['order'] : int.tryParse(json['order']?.toString() ?? '1') ?? 1,
        phone: json['phone']?.toString() ?? '',
        whatsapp: json['whatsapp']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'order': order,
        'phone': phone,
        'whatsapp': whatsapp,
      };
}

class CategoryItem {
  final String id;
  final String name;
  final String desc;
  final String icon;
  final String kind; // 'care' | 'equipment' | 'doctor'
  final int order;
  final bool enabled;
  final bool comingSoon;

  CategoryItem({
    required this.id,
    required this.name,
    required this.desc,
    required this.icon,
    this.kind = 'care',
    this.order = 1,
    this.enabled = true,
    this.comingSoon = false,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        desc: json['desc']?.toString() ?? '',
        icon: json['icon']?.toString() ?? 'cross',
        kind: json['kind']?.toString() ?? 'care',
        order: json['order'] is int ? json['order'] : int.tryParse(json['order']?.toString() ?? '1') ?? 1,
        enabled: json['enabled'] != false,
        comingSoon: json['comingSoon'] == true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'desc': desc,
        'icon': icon,
        'kind': kind,
        'order': order,
        'enabled': enabled,
        'comingSoon': comingSoon,
      };
}

class ServiceItem {
  final String id;
  final String categoryId;
  final String name;
  final String icon;
  final String desc;
  final List<String> options;
  final List<String> tasks;
  final int price;
  final String priceMode; // 'fixed' | 'contact'
  final String unit; // 'per visit', 'per day', 'per session'
  final bool enabled;
  final int order;

  ServiceItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.desc,
    this.options = const [],
    this.tasks = const [],
    this.price = 0,
    this.priceMode = 'contact',
    this.unit = 'per visit',
    this.enabled = true,
    this.order = 1,
  });

  String get priceLabel {
    if (price > 0) {
      final formatted = '₹${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
      return unit.isNotEmpty ? '$formatted $unit' : formatted;
    }
    return 'Contact for price';
  }

  factory ServiceItem.fromJson(Map<String, dynamic> json) => ServiceItem(
        id: json['id']?.toString() ?? '',
        categoryId: json['categoryId']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        icon: json['icon']?.toString() ?? 'cross',
        desc: json['desc']?.toString() ?? '',
        options: json['options'] is List ? List<String>.from(json['options'].map((e) => e.toString())) : [],
        tasks: json['tasks'] is List ? List<String>.from(json['tasks'].map((e) => e.toString())) : [],
        price: json['price'] is int ? json['price'] : int.tryParse(json['price']?.toString() ?? '0') ?? 0,
        priceMode: json['priceMode']?.toString() ?? 'contact',
        unit: json['unit']?.toString() ?? 'per visit',
        enabled: json['enabled'] != false,
        order: json['order'] is int ? json['order'] : int.tryParse(json['order']?.toString() ?? '1') ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'name': name,
        'icon': icon,
        'desc': desc,
        'options': options,
        'tasks': tasks,
        'price': price,
        'priceMode': priceMode,
        'unit': unit,
        'enabled': enabled,
        'order': order,
      };
}

class HistoryEntry {
  final String status;
  final int at;
  final String by;
  final String? note;

  HistoryEntry({
    required this.status,
    required this.at,
    required this.by,
    this.note,
  });

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        status: json['status']?.toString() ?? '',
        at: json['at'] is int ? json['at'] : int.tryParse(json['at']?.toString() ?? '0') ?? 0,
        by: json['by']?.toString() ?? 'client',
        note: json['note']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'at': at,
        'by': by,
        if (note != null) 'note': note,
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

class BookingItem {
  final String id;
  final String code;
  final String city;
  final String serviceName;
  final String clientName;
  final String clientPhone;
  final String patientName;
  final String patientAge;
  final String relation;
  final String service;
  final String plan;
  final String date;
  final String time;
  final String address;
  final String notes;
  final String source;
  final String status; // requested, confirmed, assigned, on_the_way, in_progress, completed, cancelled
  final String? cancelReason;
  final String staffId;
  final VisitReport? visit;
  final int? checkInAt;
  final int? checkOutAt;
  final List<HistoryEntry> history;
  final int createdAt;

  BookingItem({
    required this.id,
    required this.code,
    required this.city,
    required this.serviceName,
    required this.clientName,
    required this.clientPhone,
    required this.patientName,
    required this.patientAge,
    required this.relation,
    required this.service,
    required this.plan,
    required this.date,
    required this.time,
    required this.address,
    this.notes = '',
    this.source = 'App',
    required this.status,
    this.cancelReason,
    this.staffId = '',
    this.visit,
    this.checkInAt,
    this.checkOutAt,
    this.history = const [],
    required this.createdAt,
  });

  bool get isActive =>
      status == 'requested' ||
      status == 'confirmed' ||
      status == 'assigned' ||
      status == 'on_the_way' ||
      status == 'in_progress';

  bool get canCancel =>
      status == 'requested' || status == 'confirmed' || status == 'assigned';

  factory BookingItem.fromJson(Map<String, dynamic> json) => BookingItem(
        id: json['id']?.toString() ?? '',
        code: json['code']?.toString() ?? '',
        city: json['city']?.toString() ?? 'mumbai',
        serviceName: json['serviceName']?.toString() ?? '',
        clientName: json['clientName']?.toString() ?? '',
        clientPhone: json['clientPhone']?.toString() ?? '',
        patientName: json['patientName']?.toString() ?? '',
        patientAge: json['patientAge']?.toString() ?? '',
        relation: json['relation']?.toString() ?? 'Mother',
        service: json['service']?.toString() ?? '',
        plan: json['plan']?.toString() ?? 'Single visit',
        date: json['date']?.toString() ?? '',
        time: json['time']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        notes: json['notes']?.toString() ?? '',
        source: json['source']?.toString() ?? 'App',
        status: json['status']?.toString() ?? 'requested',
        cancelReason: json['cancelReason']?.toString(),
        staffId: json['staffId']?.toString() ?? '',
        visit: json['visit'] != null ? VisitReport.fromJson(Map<String, dynamic>.from(json['visit'])) : null,
        checkInAt: json['checkInAt'] is int ? json['checkInAt'] : int.tryParse(json['checkInAt']?.toString() ?? ''),
        checkOutAt: json['checkOutAt'] is int ? json['checkOutAt'] : int.tryParse(json['checkOutAt']?.toString() ?? ''),
        history: json['history'] is List
            ? List<HistoryEntry>.from(json['history'].map((e) => HistoryEntry.fromJson(Map<String, dynamic>.from(e))))
            : [],
        createdAt: json['createdAt'] is int ? json['createdAt'] : int.tryParse(json['createdAt']?.toString() ?? '0') ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'city': city,
        'serviceName': serviceName,
        'clientName': clientName,
        'clientPhone': clientPhone,
        'patientName': patientName,
        'patientAge': patientAge,
        'relation': relation,
        'service': service,
        'plan': plan,
        'date': date,
        'time': time,
        'address': address,
        'notes': notes,
        'source': source,
        'status': status,
        if (cancelReason != null) 'cancelReason': cancelReason,
        'staffId': staffId,
        if (visit != null) 'visit': visit!.toJson(),
        if (checkInAt != null) 'checkInAt': checkInAt,
        if (checkOutAt != null) 'checkOutAt': checkOutAt,
        'history': history.map((e) => e.toJson()).toList(),
        'createdAt': createdAt,
      };

  BookingItem copyWith({
    String? status,
    String? cancelReason,
    String? staffId,
    List<HistoryEntry>? history,
  }) =>
      BookingItem(
        id: id,
        code: code,
        city: city,
        serviceName: serviceName,
        clientName: clientName,
        clientPhone: clientPhone,
        patientName: patientName,
        patientAge: patientAge,
        relation: relation,
        service: service,
        plan: plan,
        date: date,
        time: time,
        address: address,
        notes: notes,
        source: source,
        status: status ?? this.status,
        cancelReason: cancelReason ?? this.cancelReason,
        staffId: staffId ?? this.staffId,
        visit: visit,
        checkInAt: checkInAt,
        checkOutAt: checkOutAt,
        history: history ?? this.history,
        createdAt: createdAt,
      );
}

class HelpFileItem {
  final String id;
  final String name;
  final String type;
  final int size;
  final String? path;

  HelpFileItem({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    this.path,
  });

  factory HelpFileItem.fromJson(Map<String, dynamic> json) => HelpFileItem(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        type: json['type']?.toString() ?? '',
        size: json['size'] is int ? json['size'] : int.tryParse(json['size']?.toString() ?? '0') ?? 0,
        path: json['path']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'size': size,
        if (path != null) 'path': path,
      };
}

class HelpEnquiryItem {
  final String id;
  final String code;
  final String clientName;
  final String clientPhone;
  final String city;
  final String area;
  final String address;
  final String description;
  final String patientType;
  final String patientAge;
  final String duration;
  final String timing;
  final List<HelpFileItem> files;
  final String status; // 'new' | 'contacted' | 'converted'
  final String? adminNote;
  final String? recommended;
  final String? bookingId;
  final List<HistoryEntry> history;
  final int createdAt;

  HelpEnquiryItem({
    required this.id,
    required this.code,
    required this.clientName,
    required this.clientPhone,
    required this.city,
    this.area = '',
    required this.address,
    required this.description,
    required this.patientType,
    required this.patientAge,
    required this.duration,
    required this.timing,
    this.files = const [],
    this.status = 'new',
    this.adminNote,
    this.recommended,
    this.bookingId,
    this.history = const [],
    required this.createdAt,
  });

  factory HelpEnquiryItem.fromJson(Map<String, dynamic> json) => HelpEnquiryItem(
        id: json['id']?.toString() ?? '',
        code: json['code']?.toString() ?? '',
        clientName: json['clientName']?.toString() ?? '',
        clientPhone: json['clientPhone']?.toString() ?? '',
        city: json['city']?.toString() ?? 'mumbai',
        area: json['area']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        patientType: json['patientType']?.toString() ?? '',
        patientAge: json['patientAge']?.toString() ?? '',
        duration: json['duration']?.toString() ?? '',
        timing: json['timing']?.toString() ?? '',
        files: json['files'] is List
            ? List<HelpFileItem>.from(json['files'].map((e) => HelpFileItem.fromJson(Map<String, dynamic>.from(e))))
            : [],
        status: json['status']?.toString() ?? 'new',
        adminNote: json['adminNote']?.toString(),
        recommended: json['recommended']?.toString(),
        bookingId: json['bookingId']?.toString(),
        history: json['history'] is List
            ? List<HistoryEntry>.from(json['history'].map((e) => HistoryEntry.fromJson(Map<String, dynamic>.from(e))))
            : [],
        createdAt: json['createdAt'] is int ? json['createdAt'] : int.tryParse(json['createdAt']?.toString() ?? '0') ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'clientName': clientName,
        'clientPhone': clientPhone,
        'city': city,
        'area': area,
        'address': address,
        'description': description,
        'patientType': patientType,
        'patientAge': patientAge,
        'duration': duration,
        'timing': timing,
        'files': files.map((e) => e.toJson()).toList(),
        'status': status,
        if (adminNote != null) 'adminNote': adminNote,
        if (recommended != null) 'recommended': recommended,
        if (bookingId != null) 'bookingId': bookingId,
        'history': history.map((e) => e.toJson()).toList(),
        'createdAt': createdAt,
      };
}

class ClientNotificationItem {
  final String id;
  final String to;
  final String title;
  final String body;
  final String? bookingId;
  final String? enquiryId;
  final int at;
  bool read;

  ClientNotificationItem({
    required this.id,
    required this.to,
    required this.title,
    required this.body,
    this.bookingId,
    this.enquiryId,
    required this.at,
    this.read = false,
  });

  factory ClientNotificationItem.fromJson(Map<String, dynamic> json) => ClientNotificationItem(
        id: json['id']?.toString() ?? '',
        to: json['to']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        body: json['body']?.toString() ?? '',
        bookingId: json['bookingId']?.toString(),
        enquiryId: json['enquiryId']?.toString(),
        at: json['at'] is int ? json['at'] : int.tryParse(json['at']?.toString() ?? '0') ?? 0,
        read: json['read'] == true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'to': to,
        'title': title,
        'body': body,
        if (bookingId != null) 'bookingId': bookingId,
        if (enquiryId != null) 'enquiryId': enquiryId,
        'at': at,
        'read': read,
      };
}

class StaffItem {
  final String id;
  final String name;
  final String role;
  final String phone;
  final String city;
  final String area;
  final String skills;
  final String docs; // 'verified' | 'pending'
  final bool onDuty;

  StaffItem({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.city,
    this.area = '',
    this.skills = '',
    this.docs = 'verified',
    this.onDuty = true,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'ST';
    if (parts.length == 1) return parts[0].substring(0, parts[0].length.clamp(0, 2)).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  factory StaffItem.fromJson(Map<String, dynamic> json) => StaffItem(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        role: json['role']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        city: json['city']?.toString() ?? '',
        area: json['area']?.toString() ?? '',
        skills: json['skills']?.toString() ?? '',
        docs: json['docs']?.toString() ?? 'verified',
        onDuty: json['onDuty'] == true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'phone': phone,
        'city': city,
        'area': area,
        'skills': skills,
        'docs': docs,
        'onDuty': onDuty,
      };
}
