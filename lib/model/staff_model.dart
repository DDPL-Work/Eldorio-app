class StaffModel {
  final String id;
  final String name;
  final String role;
  final String phone;
  final String? email;
  final String? dob;
  final String? gender;
  final String city;
  final String? area;
  final String? address;
  final String? qualification;
  final String? regNo;
  final int? experience;
  final List<String> skills;
  final List<String> languages;
  final List<String> availability;
  final String? emergencyName;
  final String? emergencyPhone;
  final String? emergencyRelation;
  final Map<String, dynamic> files;
  final bool applied;
  final String approval; // 'pending' | 'changes' | 'approved' | 'rejected'
  final String docs; // 'verified' | 'pending'
  final bool onDuty;
  final String? reviewNote;
  final int? submittedAt;
  final List<Map<String, dynamic>> appHistory;

  StaffModel({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    this.email,
    this.dob,
    this.gender,
    required this.city,
    this.area,
    this.address,
    this.qualification,
    this.regNo,
    this.experience,
    this.skills = const [],
    this.languages = const [],
    this.availability = const [],
    this.emergencyName,
    this.emergencyPhone,
    this.emergencyRelation,
    this.files = const {},
    this.applied = false,
    this.approval = 'approved',
    this.docs = 'pending',
    this.onDuty = true,
    this.reviewNote,
    this.submittedAt,
    this.appHistory = const [],
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'ST';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  String get cityName {
    switch (city.toLowerCase()) {
      case 'mumbai':
        return 'Mumbai';
      case 'thane':
        return 'Thane';
      case 'navi-mumbai':
        return 'Navi Mumbai';
      case 'pune':
        return 'Pune';
      case 'nashik':
        return 'Nashik';
      case 'nagpur':
        return 'Nagpur';
      case 'delhi':
        return 'Delhi';
      case 'gurugram':
        return 'Gurugram';
      case 'noida':
        return 'Noida';
      case 'bengaluru':
        return 'Bengaluru';
      case 'hyderabad':
        return 'Hyderabad';
      case 'chennai':
        return 'Chennai';
      case 'kolkata':
        return 'Kolkata';
      case 'ahmedabad':
        return 'Ahmedabad';
      case 'surat':
        return 'Surat';
      case 'jaipur':
        return 'Jaipur';
      case 'lucknow':
        return 'Lucknow';
      case 'chandigarh':
        return 'Chandigarh';
      case 'indore':
        return 'Indore';
      case 'goa':
        return 'Goa';
      case 'dehradun':
        return 'Dehradun';
      default:
        return city.isNotEmpty
            ? '${city[0].toUpperCase()}${city.substring(1)}'
            : 'Mumbai';
    }
  }

  bool get isApproved => approval == 'approved';
  bool get isPending => approval == 'pending';
  bool get isChanges => approval == 'changes';
  bool get isRejected => approval == 'rejected';
  bool get isVerified => docs == 'verified';

  int get calculatedAge {
    if (dob == null || dob!.isEmpty) return 0;
    try {
      final birthDate = DateTime.parse(dob!);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString(),
      dob: json['dob']?.toString(),
      gender: json['gender']?.toString(),
      city: json['city']?.toString() ?? 'mumbai',
      area: json['area']?.toString(),
      address: json['address']?.toString(),
      qualification: json['qualification']?.toString(),
      regNo: json['regNo']?.toString(),
      experience: json['experience'] != null
          ? int.tryParse(json['experience'].toString())
          : null,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          (json['skillList'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      availability: (json['availability'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      emergencyName: json['emergencyName']?.toString() ??
          (json['emergency'] is Map ? json['emergency']['name'] : null),
      emergencyPhone: json['emergencyPhone']?.toString() ??
          (json['emergency'] is Map ? json['emergency']['phone'] : null),
      emergencyRelation: json['emergencyRelation']?.toString() ??
          (json['emergency'] is Map ? json['emergency']['relation'] : null),
      files: json['files'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['files'])
          : {},
      applied: json['applied'] == true,
      approval: json['approval']?.toString() ?? 'approved',
      docs: json['docs']?.toString() ?? 'pending',
      onDuty: json['onDuty'] == true,
      reviewNote: json['reviewNote']?.toString(),
      submittedAt: json['submittedAt'] != null
          ? int.tryParse(json['submittedAt'].toString())
          : null,
      appHistory: (json['appHistory'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'phone': phone,
      'email': email,
      'dob': dob,
      'gender': gender,
      'city': city,
      'area': area,
      'address': address,
      'qualification': qualification,
      'regNo': regNo,
      'experience': experience,
      'skills': skills,
      'languages': languages,
      'availability': availability,
      'emergencyName': emergencyName,
      'emergencyPhone': emergencyPhone,
      'emergencyRelation': emergencyRelation,
      'files': files,
      'applied': applied,
      'approval': approval,
      'docs': docs,
      'onDuty': onDuty,
      'reviewNote': reviewNote,
      'submittedAt': submittedAt,
      'appHistory': appHistory,
    };
  }

  StaffModel copyWith({
    String? id,
    String? name,
    String? role,
    String? phone,
    String? email,
    String? dob,
    String? gender,
    String? city,
    String? area,
    String? address,
    String? qualification,
    String? regNo,
    int? experience,
    List<String>? skills,
    List<String>? languages,
    List<String>? availability,
    String? emergencyName,
    String? emergencyPhone,
    String? emergencyRelation,
    Map<String, dynamic>? files,
    bool? applied,
    String? approval,
    String? docs,
    bool? onDuty,
    String? reviewNote,
    int? submittedAt,
    List<Map<String, dynamic>>? appHistory,
  }) {
    return StaffModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      city: city ?? this.city,
      area: area ?? this.area,
      address: address ?? this.address,
      qualification: qualification ?? this.qualification,
      regNo: regNo ?? this.regNo,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      availability: availability ?? this.availability,
      emergencyName: emergencyName ?? this.emergencyName,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      emergencyRelation: emergencyRelation ?? this.emergencyRelation,
      files: files ?? this.files,
      applied: applied ?? this.applied,
      approval: approval ?? this.approval,
      docs: docs ?? this.docs,
      onDuty: onDuty ?? this.onDuty,
      reviewNote: reviewNote ?? this.reviewNote,
      submittedAt: submittedAt ?? this.submittedAt,
      appHistory: appHistory ?? this.appHistory,
    );
  }
}
