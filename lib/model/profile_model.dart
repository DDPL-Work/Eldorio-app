class ProfileResponse {
  final bool success;
  final String message;
  final ProfileData? data;

  ProfileResponse({
    this.success = false,
    this.message = '',
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProfileResponse();

    return ProfileResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? ProfileData.fromJson(Map<String, dynamic>.from(json['data']))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}

class ProfileData {
  final ProfileUser? user;
  final String? role;
  final ProfileDetails? profile;
  final ProfileDetails? staffProfile;
  final ProfileDetails? clientProfile;

  ProfileData({
    this.user,
    this.role,
    this.profile,
    this.staffProfile,
    this.clientProfile,
  });

  factory ProfileData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProfileData();

    return ProfileData(
      user: json['user'] is Map<String, dynamic>
          ? ProfileUser.fromJson(Map<String, dynamic>.from(json['user']))
          : null,
      role: json['role']?.toString(),
      profile: json['profile'] is Map<String, dynamic>
          ? ProfileDetails.fromJson(Map<String, dynamic>.from(json['profile']))
          : null,
      staffProfile: json['staffProfile'] is Map<String, dynamic>
          ? ProfileDetails.fromJson(
              Map<String, dynamic>.from(json['staffProfile']))
          : null,
      clientProfile: json['clientProfile'] is Map<String, dynamic>
          ? ProfileDetails.fromJson(
              Map<String, dynamic>.from(json['clientProfile']))
          : null,
    );
  }

  ProfileDetails? get activeProfile => staffProfile ?? profile ?? clientProfile;

  String get displayName {
    if (user?.name != null && user!.name!.trim().isNotEmpty) {
      return user!.name!.trim();
    }
    if (activeProfile?.name != null && activeProfile!.name!.trim().isNotEmpty) {
      return activeProfile!.name!.trim();
    }
    return 'Client';
  }

  String get displayPhone {
    if (user?.phone != null && user!.phone!.trim().isNotEmpty) {
      return user!.phone!.trim();
    }
    if (activeProfile?.phone != null && activeProfile!.phone!.trim().isNotEmpty) {
      return activeProfile!.phone!.trim();
    }
    return '';
  }

  String get displayEmail => user?.email?.trim() ?? '';

  String get displayRole => user?.role?.trim() ?? role?.trim() ?? 'client';

  String get displayStaffId =>
      user?.staffId?.trim() ?? activeProfile?.staffId?.trim() ?? '';

  String get displayCity => activeProfile?.city?.trim() ?? '';

  String get displayArea => activeProfile?.area?.trim() ?? '';

  String get displayAddress => activeProfile?.address?.trim() ?? '';

  String get initials {
    final name = displayName;
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'CL';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length.clamp(0, 2)).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  bool get isStaff => displayRole.toLowerCase() == 'staff' || staffProfile != null;

  Map<String, dynamic> toJson() => {
        'user': user?.toJson(),
        'role': role,
        'profile': profile?.toJson(),
        'staffProfile': staffProfile?.toJson(),
        'clientProfile': clientProfile?.toJson(),
      };
}

class ProfileUser {
  final int? id;
  final String? staffId;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  ProfileUser({
    this.id,
    this.staffId,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileUser.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProfileUser();

    return ProfileUser(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      staffId: json['staffId']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      role: json['role']?.toString(),
      isActive: json['isActive'] != false,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
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
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class ProfileDetails {
  final int? id;
  final String? staffId;
  final String? name;
  final String? phone;
  final String? email;
  final String? dob;
  final String? gender;
  final String? city;
  final String? area;
  final String? address;
  final String? qualification;
  final String? regNo;
  final String? experience;
  final List<String> skills;
  final List<String> language;
  final List<String> availability;
  final String? emergencyName;
  final String? emergencyPhone;
  final String? emergencyRelation;
  final Map<String, ProfileDocFile> files;
  final bool applied;
  final String? approval;
  final String? registrationStatus;
  final String? docs;
  final Map<String, bool> docChecks;
  final String? reviewNote;
  final String? reviewedAt;
  final List<AppHistoryItem> appHistory;
  final bool onDuty;
  final String? submittedAt;
  final String? approvedAt;
  final String? rejectedAt;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  ProfileDetails({
    this.id,
    this.staffId,
    this.name,
    this.phone,
    this.email,
    this.dob,
    this.gender,
    this.city,
    this.area,
    this.address,
    this.qualification,
    this.regNo,
    this.experience,
    this.skills = const [],
    this.language = const [],
    this.availability = const [],
    this.emergencyName,
    this.emergencyPhone,
    this.emergencyRelation,
    this.files = const {},
    this.applied = false,
    this.approval,
    this.registrationStatus,
    this.docs,
    this.docChecks = const {},
    this.reviewNote,
    this.reviewedAt,
    this.appHistory = const [],
    this.onDuty = false,
    this.submittedAt,
    this.approvedAt,
    this.rejectedAt,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProfileDetails();

    // Parse files safely
    final Map<String, ProfileDocFile> filesMap = {};
    if (json['files'] is Map) {
      final rawFiles = json['files'] as Map;
      rawFiles.forEach((key, val) {
        if (val is Map) {
          filesMap[key.toString()] =
              ProfileDocFile.fromJson(Map<String, dynamic>.from(val));
        }
      });
    }

    // Parse docChecks safely
    final Map<String, bool> checksMap = {};
    if (json['docChecks'] is Map) {
      final rawChecks = json['docChecks'] as Map;
      rawChecks.forEach((key, val) {
        checksMap[key.toString()] = val == true;
      });
    }

    // Parse appHistory safely
    final List<AppHistoryItem> historyList = [];
    if (json['appHistory'] is List) {
      for (final item in json['appHistory'] as List) {
        if (item is Map) {
          historyList
              .add(AppHistoryItem.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return ProfileDetails(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      staffId: json['staffId']?.toString(),
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      dob: json['dob']?.toString(),
      gender: json['gender']?.toString(),
      city: json['city']?.toString(),
      area: json['area']?.toString(),
      address: json['address']?.toString(),
      qualification: json['qualification']?.toString(),
      regNo: json['regNo']?.toString(),
      experience: json['experience']?.toString(),
      skills: json['skills'] is List
          ? (json['skills'] as List).map((e) => e.toString()).toList()
          : const [],
      language: json['language'] is List
          ? (json['language'] as List).map((e) => e.toString()).toList()
          : const [],
      availability: json['availability'] is List
          ? (json['availability'] as List).map((e) => e.toString()).toList()
          : const [],
      emergencyName: json['emergencyName']?.toString(),
      emergencyPhone: json['emergencyPhone']?.toString(),
      emergencyRelation: json['emergencyRelation']?.toString(),
      files: filesMap,
      applied: json['applied'] == true,
      approval: json['approval']?.toString(),
      registrationStatus: json['registrationStatus']?.toString(),
      docs: json['docs']?.toString(),
      docChecks: checksMap,
      reviewNote: json['reviewNote']?.toString(),
      reviewedAt: json['reviewedAt']?.toString(),
      appHistory: historyList,
      onDuty: json['onDuty'] == true,
      submittedAt: json['submittedAt']?.toString(),
      approvedAt: json['approvedAt']?.toString(),
      rejectedAt: json['rejectedAt']?.toString(),
      notes: json['notes']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'staffId': staffId,
        'name': name,
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
        'language': language,
        'availability': availability,
        'emergencyName': emergencyName,
        'emergencyPhone': emergencyPhone,
        'emergencyRelation': emergencyRelation,
        'files': files.map((k, v) => MapEntry(k, v.toJson())),
        'applied': applied,
        'approval': approval,
        'registrationStatus': registrationStatus,
        'docs': docs,
        'docChecks': docChecks,
        'reviewNote': reviewNote,
        'reviewedAt': reviewedAt,
        'appHistory': appHistory.map((e) => e.toJson()).toList(),
        'onDuty': onDuty,
        'submittedAt': submittedAt,
        'approvedAt': approvedAt,
        'rejectedAt': rejectedAt,
        'notes': notes,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class ProfileDocFile {
  final String? id;
  final String? key;
  final String? data;
  final String? name;
  final int? size;
  final String? type;
  final String? notes;
  final String? status;
  final bool verified;
  final String? uploadedAt;
  final String? verifiedAt;

  ProfileDocFile({
    this.id,
    this.key,
    this.data,
    this.name,
    this.size,
    this.type,
    this.notes,
    this.status,
    this.verified = false,
    this.uploadedAt,
    this.verifiedAt,
  });

  factory ProfileDocFile.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProfileDocFile();

    return ProfileDocFile(
      id: json['id']?.toString(),
      key: json['key']?.toString(),
      data: json['data']?.toString(),
      name: json['name']?.toString(),
      size: json['size'] is int
          ? json['size']
          : int.tryParse(json['size']?.toString() ?? ''),
      type: json['type']?.toString(),
      notes: json['notes']?.toString(),
      status: json['status']?.toString(),
      verified: json['verified'] == true,
      uploadedAt: json['uploadedAt']?.toString(),
      verifiedAt: json['verifiedAt']?.toString(),
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
        'uploadedAt': uploadedAt,
        'verifiedAt': verifiedAt,
      };
}

class AppHistoryItem {
  final String? at;
  final String? by;
  final String? note;
  final String? status;

  AppHistoryItem({
    this.at,
    this.by,
    this.note,
    this.status,
  });

  factory AppHistoryItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AppHistoryItem();

    return AppHistoryItem(
      at: json['at']?.toString(),
      by: json['by']?.toString(),
      note: json['note']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'at': at,
        'by': by,
        'note': note,
        'status': status,
      };
}
