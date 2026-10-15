class StaffModel {
  final String id;
  final String staffId;
  final String name;
  final String role;
  final String phone;
  final String? email;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  final String? token;
  final String? salt;
  final String? hash;

  final String? dob;
  final String? gender;
  final String city;
  final String? area;
  final String? address;
  final String? qualification;
  final String? regNo;
  final String? experience;
  final List<String> skills;
  final List<String> languages;
  final List<String> availability;

  final String? emergencyName;
  final String? emergencyPhone;
  final String? emergencyRelation;
  final Map<String, dynamic> files;

  final bool applied;
  final String approval;
  final String docs;
  final bool onDuty;

  final String? submittedAt;
  final String? approvedAt;
  final String? rejectedAt;
  final String? notes;

  StaffModel({
    required this.id,
    required this.staffId,
    required this.name,
    required this.role,
    required this.phone,
    this.email,
    this.isActive = false,
    this.createdAt,
    this.updatedAt,
    this.token,
    this.salt,
    this.hash,
    this.dob,
    this.gender,
    this.city = '',
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
    this.approval = 'pending',
    this.docs = 'pending',
    this.onDuty = false,
    this.submittedAt,
    this.approvedAt,
    this.rejectedAt,
    this.notes,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']) ?? json;
    final user = _asMap(data['user']) ?? data;
    final profile = _asMap(data['staffProfile']) ?? data;

    return StaffModel(
      id: _string(user['id']),
      staffId: _string(user['staffId'] ?? profile['staffId']),
      name: _string(user['name']),
      role: _string(user['role']),
      phone: _string(user['phone']),
      email: _nullableString(user['email']),
      isActive: user['isActive'] == true,
      createdAt: _nullableString(user['createdAt']),
      updatedAt: _nullableString(user['updatedAt']),

      token: _nullableString(data['token']),
      salt: _nullableString(data['salt']),
      hash: _nullableString(data['hash']),

      dob: _nullableString(profile['dob']),
      gender: _nullableString(profile['gender']),
      city: _string(profile['city']),
      area: _nullableString(profile['area']),
      address: _nullableString(profile['address']),
      qualification: _nullableString(profile['qualification']),
      regNo: _nullableString(profile['regNo']),
      experience: _nullableString(profile['experience']),

      skills: _stringList(profile['skills']),
      languages: _stringList(profile['language'] ?? profile['languages']),
      availability: _stringList(profile['availability']),

      emergencyName: _nullableString(profile['emergencyName']),
      emergencyPhone: _nullableString(profile['emergencyPhone']),
      emergencyRelation: _nullableString(profile['emergencyRelation']),
      files: _asMap(profile['files']) ?? {},

      applied: profile['applied'] == true,
      approval: _string(profile['approval'], fallback: 'pending'),
      docs: _string(profile['docs'], fallback: 'pending'),
      onDuty: profile['onDuty'] == true,

      submittedAt: _nullableString(profile['submittedAt']),
      approvedAt: _nullableString(profile['approvedAt']),
      rejectedAt: _nullableString(profile['rejectedAt']),
      notes: _nullableString(profile['notes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'staffId': staffId,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'isActive': isActive,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      },
      'token': token,
      'salt': salt,
      'hash': hash,
      'staffProfile': {
        'staffId': staffId,
        'dob': dob,
        'gender': gender,
        'city': city,
        'area': area,
        'address': address,
        'qualification': qualification,
        'regNo': regNo,
        'experience': experience,
        'skills': skills,
        'language': languages,
        'availability': availability,
        'emergencyName': emergencyName,
        'emergencyPhone': emergencyPhone,
        'emergencyRelation': emergencyRelation,
        'files': files,
        'applied': applied,
        'approval': approval,
        'docs': docs,
        'onDuty': onDuty,
        'submittedAt': submittedAt,
        'approvedAt': approvedAt,
        'rejectedAt': rejectedAt,
        'notes': notes,
      },
    };
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) return 'ST';
    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    }

    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }

  String get cityName {
    if (city.isEmpty) return '';
    return city
        .split(RegExp(r'[-\s]+'))
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
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

      var age = today.year - birthDate.year;

      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (_) {
      return 0;
    }
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  static String _string(dynamic value, {String fallback = ''}) {
    return value?.toString() ?? fallback;
  }

  static String? _nullableString(dynamic value) {
    return value?.toString();
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return const [];

    return value.map((item) => item.toString()).toList();
  }
}
