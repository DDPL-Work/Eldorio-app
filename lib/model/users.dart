class User {
  final bool? success;
  final String? token;
  final int? expiresInSeconds;
  final UserInfo? userInfo;
  final Profile? profile;

  User({
    this.success,
    this.token,
    this.expiresInSeconds,
    this.userInfo,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) return User();

    final Map<String, dynamic> data = json['data'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['data'])
        : json;

    return User(
      success: json['success'],
      token: json['token'] ?? json['accessToken'] ?? json['mvn_access_token'],
      expiresInSeconds: json['expiresInSeconds'],

      userInfo: data['user'] != null
          ? UserInfo.fromJson(Map<String, dynamic>.from(data['user']))
          : null,

      profile: data['profile'] != null
          ? Profile.fromJson(Map<String, dynamic>.from(data['profile']))
          : null,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'expiresInSeconds': expiresInSeconds,
      'user': userInfo?.toJson(),
      'profile': profile?.toJson(),
    };
  }
}

class UserInfo {
  final String? id;
  final String? name;
  final String? username;
  final String? email;
  final String? role;
  final String? designation;
  final String? accessStatus;
  final String? eldoriaCareId;
  final String? eldoriaCareName;
  final UserPermissions? permissions;
  final String? superUserEmail;

  UserInfo({
    this.id,
    this.name,
    this.username,
    this.email,
    this.role,
    this.designation,
    this.accessStatus,
    this.eldoriaCareId,
    this.eldoriaCareName,
    this.permissions,
    this.superUserEmail,
  });

  factory UserInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserInfo();

    return UserInfo(
      id: json['id']?.toString(),

      name: json['name']?.toString() ?? json['username']?.toString(),

      username: json['username']?.toString(),

      email: json['email']?.toString(),

      role: json['role']?.toString(),

      designation: json['designation']?.toString(),

      accessStatus: json['accessStatus']?.toString(),

      eldoriaCareId: json['eldoriaCareId']?.toString(),

      eldoriaCareName: json['eldoriaCareName']?.toString(),

      permissions: json['permissions'] != null
          ? UserPermissions.fromJson(
              Map<String, dynamic>.from(json['permissions']),
            )
          : null,

      superUserEmail: json['superUserEmail']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'role': role,
      'designation': designation,
      'accessStatus': accessStatus,
      'eldoriaCareId': eldoriaCareId,
      'eldoriaCareName': eldoriaCareName,
      'permissions': permissions,
      'superUserEmail': superUserEmail,
    };
  }
}

class UserPermissions {
  final bool jobPosting;
  final bool jobBooster;
  final bool resdex;

  UserPermissions({
    this.jobPosting = false,
    this.jobBooster = false,
    this.resdex = false,
  });

  factory UserPermissions.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserPermissions();

    return UserPermissions(
      jobPosting: json['jobPosting'] == true,
      jobBooster: json['jobBooster'] == true,
      resdex: json['resdex'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobPosting': jobPosting,
      'jobBooster': jobBooster,
      'resdex': resdex,
    };
  }
}

class Profile {
  final String? id;
  final UserInfo? user;
  final String? phone;
  final String? altPhone;
  final String? headline;
  final String? summary;
  final String? totalExperience;
  final String? currentTitle;
  final String? currenteldoriaCare;
  final String? noticePeriod;
  final String? currentCity;
  final String? currentState;
  final String? currentCountry;
  final List<dynamic>? preferredLocations;
  final List<dynamic>? preferredRoles;
  final List<dynamic>? skills;
  final String? linkedInUrl;
  final String? portfolioUrl;
  final String? expectedSalary;
  final String? lastScannedQrToken;
  final Resume? resume;
  final int? profileCompletion;
  final String? updatedAt;
  final String? lastUpdated;

  Profile({
    this.id,
    this.user,
    this.phone,
    this.altPhone,
    this.headline,
    this.summary,
    this.totalExperience,
    this.currentTitle,
    this.currenteldoriaCare,
    this.noticePeriod,
    this.currentCity,
    this.currentState,
    this.currentCountry,
    this.preferredLocations,
    this.preferredRoles,
    this.skills,
    this.linkedInUrl,
    this.portfolioUrl,
    this.expectedSalary,
    this.lastScannedQrToken,
    this.resume,
    this.profileCompletion,
    this.updatedAt,
    this.lastUpdated,
  });

  factory Profile.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Profile();

    return Profile(
      id: json['id']?.toString(),

      user: json['user'] != null
          ? UserInfo.fromJson(Map<String, dynamic>.from(json['user']))
          : null,

      phone: json['phone']?.toString(),

      altPhone: json['altPhone']?.toString(),

      headline: json['headline']?.toString(),

      summary: json['summary']?.toString(),

      totalExperience: json['totalExperience']?.toString(),

      currentTitle: json['currentTitle']?.toString(),

      currenteldoriaCare: json['currenteldoriaCare']?.toString(),

      noticePeriod: json['noticePeriod']?.toString(),

      currentCity: json['currentCity']?.toString(),

      currentState: json['currentState']?.toString(),

      currentCountry: json['currentCountry']?.toString(),

      preferredLocations: json['preferredLocations'] is List
          ? List<dynamic>.from(json['preferredLocations'])
          : [],

      preferredRoles: json['preferredRoles'] is List
          ? List<dynamic>.from(json['preferredRoles'])
          : [],

      skills: json['skills'] is List ? List<dynamic>.from(json['skills']) : [],

      linkedInUrl: json['linkedInUrl']?.toString(),

      portfolioUrl: json['portfolioUrl']?.toString(),

      expectedSalary: json['expectedSalary']?.toString(),

      lastScannedQrToken: json['lastScannedQrToken']?.toString(),

      resume: json['resume'] != null
          ? Resume.fromJson(Map<String, dynamic>.from(json['resume']))
          : null,

      profileCompletion: json['profileCompletion'] is int
          ? json['profileCompletion']
          : int.tryParse(json['profileCompletion']?.toString() ?? ''),

      updatedAt: json['updatedAt']?.toString(),

      lastUpdated: json['lastUpdated']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'phone': phone,
      'altPhone': altPhone,
      'headline': headline,
      'summary': summary,
      'totalExperience': totalExperience,
      'currentTitle': currentTitle,
      'currenteldoriaCare': currenteldoriaCare,
      'noticePeriod': noticePeriod,
      'currentCity': currentCity,
      'currentState': currentState,
      'currentCountry': currentCountry,
      'preferredLocations': preferredLocations,
      'preferredRoles': preferredRoles,
      'skills': skills,
      'linkedInUrl': linkedInUrl,
      'portfolioUrl': portfolioUrl,
      'expectedSalary': expectedSalary,
      'lastScannedQrToken': lastScannedQrToken,
      'resume': resume?.toJson(),
      'profileCompletion': profileCompletion,
      'updatedAt': updatedAt,
      'lastUpdated': lastUpdated,
    };
  }
}

class Resume {
  final String? fileName;
  final String? url;
  final String? storageProvider;
  final int? sizeBytes;
  final String? mimeType;
  final String? uploadedAt;

  Resume({
    this.fileName,
    this.url,
    this.storageProvider,
    this.sizeBytes,
    this.mimeType,
    this.uploadedAt,
  });

  factory Resume.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Resume();

    return Resume(
      fileName: json['fileName']?.toString(),

      url: json['url']?.toString(),

      storageProvider: json['storageProvider']?.toString(),

      sizeBytes: json['sizeBytes'] is int
          ? json['sizeBytes']
          : int.tryParse(json['sizeBytes']?.toString() ?? ''),

      mimeType: json['mimeType']?.toString(),

      uploadedAt: json['uploadedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'url': url,
      'storageProvider': storageProvider,
      'sizeBytes': sizeBytes,
      'mimeType': mimeType,
      'uploadedAt': uploadedAt,
    };
  }
}

class eldoriaCare {
  final String? id;
  final String? name;
  final String? logoUrl;
  final String? coverImageUrl;
  final String? industry;
  final String? about;
  final String? eldoriaCareSize;
  final String? foundedYear;
  final String? tagline;
  final String? type;
  final List<String>? specialties;
  final List<eldoriaCarePerk>? perks;
  final String? linkedIn;
  final String? status;
  final String? packageType;
  final int? jobLimit;
  final int? activeJobCount;
  final int? remainingSlots;
  final String? email;
  final String? phone;
  final String? website;
  final String? accountManager;
  final String? configurationNotes;
  final eldoriaCareLocation? location;
  final String? updatedAt;
  final String? lastUpdated;

  eldoriaCare({
    this.id,
    this.name,
    this.logoUrl,
    this.coverImageUrl,
    this.industry,
    this.about,
    this.eldoriaCareSize,
    this.foundedYear,
    this.tagline,
    this.type,
    this.specialties,
    this.perks,
    this.linkedIn,
    this.status,
    this.packageType,
    this.jobLimit,
    this.activeJobCount,
    this.remainingSlots,
    this.email,
    this.phone,
    this.website,
    this.accountManager,
    this.configurationNotes,
    this.location,
    this.updatedAt,
    this.lastUpdated,
  });

  factory eldoriaCare.fromJson(Map<String, dynamic>? json) {
    if (json == null) return eldoriaCare();

    return eldoriaCare(
      id: json['id']?.toString(),

      name: json['name']?.toString(),

      logoUrl: json['logoUrl']?.toString(),

      coverImageUrl: json['coverImageUrl']?.toString(),

      industry: json['industry']?.toString(),

      about: json['about']?.toString(),

      eldoriaCareSize: json['eldoriaCareSize']?.toString(),

      foundedYear: json['foundedYear']?.toString(),

      tagline: json['tagline']?.toString(),

      type: json['type']?.toString(),

      specialties: json['specialties'] is List
          ? List<String>.from(
              (json['specialties'] as List).map((e) => e.toString()),
            )
          : [],

      perks: json['perks'] is List
          ? (json['perks'] as List)
                .whereType<Map>()
                .map((e) => eldoriaCarePerk.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : [],

      linkedIn: json['linkedIn']?.toString(),

      status: json['status']?.toString(),

      packageType: json['packageType']?.toString(),

      jobLimit: json['jobLimit'] is int
          ? json['jobLimit']
          : int.tryParse(json['jobLimit']?.toString() ?? ''),

      activeJobCount: json['activeJobCount'] is int
          ? json['activeJobCount']
          : int.tryParse(json['activeJobCount']?.toString() ?? ''),

      remainingSlots: json['remainingSlots'] is int
          ? json['remainingSlots']
          : int.tryParse(json['remainingSlots']?.toString() ?? ''),

      email: json['email']?.toString(),

      phone: json['phone']?.toString(),

      website: json['website']?.toString(),

      accountManager: json['accountManager']?.toString(),

      configurationNotes: json['configurationNotes']?.toString(),

      location: json['location'] != null
          ? eldoriaCareLocation.fromJson(
              Map<String, dynamic>.from(json['location']),
            )
          : null,

      updatedAt: json['updatedAt']?.toString(),

      lastUpdated: json['lastUpdated']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'coverImageUrl': coverImageUrl,
      'industry': industry,
      'about': about,
      'eldoriaCareSize': eldoriaCareSize,
      'foundedYear': foundedYear,
      'tagline': tagline,
      'type': type,
      'specialties': specialties,
      'perks': perks?.map((e) => e.toJson()).toList(),
      'linkedIn': linkedIn,
      'status': status,
      'packageType': packageType,
      'jobLimit': jobLimit,
      'activeJobCount': activeJobCount,
      'remainingSlots': remainingSlots,
      'email': email,
      'phone': phone,
      'website': website,
      'accountManager': accountManager,
      'configurationNotes': configurationNotes,
      'location': location?.toJson(),
      'updatedAt': updatedAt,
      'lastUpdated': lastUpdated,
    };
  }
}

class eldoriaCarePerk {
  final String? label;
  final String? icon;
  final String? id;

  eldoriaCarePerk({this.label, this.icon, this.id});

  factory eldoriaCarePerk.fromJson(Map<String, dynamic>? json) {
    if (json == null) return eldoriaCarePerk();

    return eldoriaCarePerk(
      label: json['label']?.toString(),
      icon: json['icon']?.toString(),
      id: json['_id']?.toString() ?? json['id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'icon': icon, '_id': id};
  }
}

class eldoriaCareLocation {
  final String? city;
  final String? region;
  final String? zone;
  final String? address;
  final String? pincode;

  eldoriaCareLocation({
    this.city,
    this.region,
    this.zone,
    this.address,
    this.pincode,
  });

  factory eldoriaCareLocation.fromJson(Map<String, dynamic>? json) {
    if (json == null) return eldoriaCareLocation();

    return eldoriaCareLocation(
      city: json['city']?.toString(),
      region: json['region']?.toString(),
      zone: json['zone']?.toString(),
      address: json['address']?.toString(),
      pincode: json['pincode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'region': region,
      'zone': zone,
      'address': address,
      'pincode': pincode,
    };
  }
}
