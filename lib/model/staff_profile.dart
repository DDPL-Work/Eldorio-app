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

class StaffProfileData {
  final StaffUser user;
  final String role;
  final StaffProfile profile;
  final StaffProfile staffProfile;

  const StaffProfileData({
    this.user = const StaffUser(),
    this.role = '',
    this.profile = const StaffProfile(),
    this.staffProfile = const StaffProfile(),
  });

  factory StaffProfileData.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return StaffProfileData(
      user: StaffUser.fromJson(_asMap(json['user'])),
      role: json['role'] as String? ?? '',
      profile: StaffProfile.fromJson(_asMap(json['profile'])),
      staffProfile: StaffProfile.fromJson(_asMap(json['staffProfile'])),
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'role': role,
    'profile': profile.toJson(),
    'staffProfile': staffProfile.toJson(),
  };
}

class StaffUser {
  final int id;
  final String staffId;
  final String name;
  final String email;
  final String phone;
  final String role;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StaffUser({
    this.id = 0,
    this.staffId = '',
    this.name = '',
    this.email = '',
    this.phone = '',
    this.role = '',
    this.isActive = false,
    this.createdAt,
    this.updatedAt,
  });

  factory StaffUser.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return StaffUser(
      id: _asInt(json['id']),
      staffId: json['staffId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      createdAt: _asDate(json['createdAt']),
      updatedAt: _asDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'staffId': staffId,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'isActive': isActive,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}

class StaffProfile {
  final int id;
  final String staffId;
  final String dob;
  final String gender;
  final String city;
  final String area;
  final String address;
  final String qualification;
  final String regNo;
  final String experience;
  final List<String> skills;
  final List<String> language;
  final List<String> availability;
  final String emergencyName;
  final String emergencyPhone;
  final String emergencyRelation;
  final StaffFiles files;
  final bool applied;
  final String approval;
  final String registrationStatus;
  final String docs;
  final DocumentChecks docChecks;
  final String reviewNote;
  final DateTime? reviewedAt;
  final bool onDuty;
  final DateTime? submittedAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final String notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StaffProfile({
    this.id = 0,
    this.staffId = '',
    this.dob = '',
    this.gender = '',
    this.city = '',
    this.area = '',
    this.address = '',
    this.qualification = '',
    this.regNo = '',
    this.experience = '',
    this.skills = const [],
    this.language = const [],
    this.availability = const [],
    this.emergencyName = '',
    this.emergencyPhone = '',
    this.emergencyRelation = '',
    this.files = const StaffFiles(),
    this.applied = false,
    this.approval = '',
    this.registrationStatus = '',
    this.docs = '',
    this.docChecks = const DocumentChecks(),
    this.reviewNote = '',
    this.reviewedAt,
    this.onDuty = false,
    this.submittedAt,
    this.approvedAt,
    this.rejectedAt,
    this.notes = '',
    this.createdAt,
    this.updatedAt,
  });

  factory StaffProfile.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return StaffProfile(
      id: _asInt(json['id']),
      staffId: json['staffId'] as String? ?? '',
      dob: json['dob'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      city: json['city'] as String? ?? '',
      area: json['area'] as String? ?? '',
      address: json['address'] as String? ?? '',
      qualification: json['qualification'] as String? ?? '',
      regNo: json['regNo'] as String? ?? '',
      experience: json['experience'] as String? ?? '',
      skills: _asStringList(json['skills']),
      language: _asStringList(json['language']),
      availability: _asStringList(json['availability']),
      emergencyName: json['emergencyName'] as String? ?? '',
      emergencyPhone: json['emergencyPhone'] as String? ?? '',
      emergencyRelation: json['emergencyRelation'] as String? ?? '',
      files: StaffFiles.fromJson(_asMap(json['files'])),
      applied: json['applied'] as bool? ?? false,
      approval: json['approval'] as String? ?? '',
      registrationStatus: json['registrationStatus'] as String? ?? '',
      docs: json['docs'] as String? ?? '',
      docChecks: DocumentChecks.fromJson(_asMap(json['docChecks'])),
      reviewNote: json['reviewNote'] as String? ?? '',
      reviewedAt: _asDate(json['reviewedAt']),
      onDuty: json['onDuty'] as bool? ?? false,
      submittedAt: _asDate(json['submittedAt']),
      approvedAt: _asDate(json['approvedAt']),
      rejectedAt: _asDate(json['rejectedAt']),
      notes: json['notes'] as String? ?? '',
      createdAt: _asDate(json['createdAt']),
      updatedAt: _asDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
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
    'language': language,
    'availability': availability,
    'emergencyName': emergencyName,
    'emergencyPhone': emergencyPhone,
    'emergencyRelation': emergencyRelation,
    'files': files.toJson(),
    'applied': applied,
    'approval': approval,
    'registrationStatus': registrationStatus,
    'docs': docs,
    'docChecks': docChecks.toJson(),
    'reviewNote': reviewNote,
    'reviewedAt': reviewedAt?.toIso8601String(),
    'onDuty': onDuty,
    'submittedAt': submittedAt?.toIso8601String(),
    'approvedAt': approvedAt?.toIso8601String(),
    'rejectedAt': rejectedAt?.toIso8601String(),
    'notes': notes,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}

class StaffFiles {
  final StaffDocument photo;
  final StaffDocument police;
  final StaffDocument idProof;
  final StaffDocument experience;
  final StaffDocument qualification;

  const StaffFiles({
    this.photo = const StaffDocument(),
    this.police = const StaffDocument(),
    this.idProof = const StaffDocument(),
    this.experience = const StaffDocument(),
    this.qualification = const StaffDocument(),
  });

  factory StaffFiles.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return StaffFiles(
      photo: StaffDocument.fromJson(_asMap(json['photo'])),
      police: StaffDocument.fromJson(_asMap(json['police'])),
      idProof: StaffDocument.fromJson(_asMap(json['idProof'])),
      experience: StaffDocument.fromJson(_asMap(json['experience'])),
      qualification: StaffDocument.fromJson(_asMap(json['qualification'])),
    );
  }

  Map<String, dynamic> toJson() => {
    'photo': photo.toJson(),
    'police': police.toJson(),
    'idProof': idProof.toJson(),
    'experience': experience.toJson(),
    'qualification': qualification.toJson(),
  };
}

class StaffDocument {
  final String id;
  final String key;
  final String data;
  final String name;
  final int size;
  final String type;
  final String? notes;
  final String status;
  final bool verified;
  final DateTime? uploadedAt;
  final DateTime? verifiedAt;

  const StaffDocument({
    this.id = '',
    this.key = '',
    this.data = '',
    this.name = '',
    this.size = 0,
    this.type = '',
    this.notes,
    this.status = '',
    this.verified = false,
    this.uploadedAt,
    this.verifiedAt,
  });

  factory StaffDocument.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return StaffDocument(
      id: json['id'] as String? ?? '',
      key: json['key'] as String? ?? '',
      data: json['data'] as String? ?? '',
      name: json['name'] as String? ?? '',
      size: _asInt(json['size']),
      type: json['type'] as String? ?? '',
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? '',
      verified: json['verified'] as bool? ?? false,
      uploadedAt: _asDate(json['uploadedAt']),
      verifiedAt: _asDate(json['verifiedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'key': key,
    'data': data,
    'name': name,
    'size': size,
    'type': type,
    'notes': notes,
    'status': status,
    'verified': verified,
    'uploadedAt': uploadedAt?.toIso8601String(),
    'verifiedAt': verifiedAt?.toIso8601String(),
  };
}

class DocumentChecks {
  final bool photo;
  final bool police;
  final bool idProof;
  final bool experience;
  final bool qualification;

  const DocumentChecks({
    this.photo = false,
    this.police = false,
    this.idProof = false,
    this.experience = false,
    this.qualification = false,
  });

  factory DocumentChecks.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return DocumentChecks(
      photo: json['photo'] as bool? ?? false,
      police: json['police'] as bool? ?? false,
      idProof: json['idProof'] as bool? ?? false,
      experience: json['experience'] as bool? ?? false,
      qualification: json['qualification'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'photo': photo,
    'police': police,
    'idProof': idProof,
    'experience': experience,
    'qualification': qualification,
  };
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

List<String> _asStringList(dynamic value) {
  if (value is! List) return <String>[];
  return value.whereType<String>().toList();
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime? _asDate(dynamic value) {
  if (value == null || value.toString().isEmpty) return null;
  return DateTime.tryParse(value.toString());
}
