class ServicesResponse {
  final bool success;
  final String message;
  final ServicesData? data;

  ServicesResponse({this.success = false, this.message = '', this.data});

  factory ServicesResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ServicesResponse();

    return ServicesResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? ServicesData.fromJson(Map<String, dynamic>.from(json['data']))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class ServicesData {
  final ServiceLocation? location;
  final List<OperationalServiceItem> services;
  final List<OperationalCategoryItem> categories;
  final int totalServices;

  ServicesData({
    this.location,
    this.services = const [],
    this.categories = const [],
    this.totalServices = 0,
  });

  factory ServicesData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ServicesData();

    final rawServices = json['services'] is List
        ? (json['services'] as List)
        : [];
    final rawCategories = json['categories'] is List
        ? (json['categories'] as List)
        : [];

    return ServicesData(
      location: json['location'] is Map<String, dynamic>
          ? ServiceLocation.fromJson(
              Map<String, dynamic>.from(json['location']),
            )
          : null,
      services: rawServices
          .whereType<Map>()
          .map(
            (e) =>
                OperationalServiceItem.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
      categories: rawCategories
          .whereType<Map>()
          .map(
            (e) =>
                OperationalCategoryItem.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
      totalServices: json['totalServices'] is int
          ? json['totalServices']
          : int.tryParse(json['totalServices']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'location': location?.toJson(),
    'services': services.map((e) => e.toJson()).toList(),
    'categories': categories.map((e) => e.toJson()).toList(),
    'totalServices': totalServices,
  };
}

class ServiceLocation {
  final String city;
  final String cityName;
  final bool isAddedByAdmin;
  final bool isLive;
  final bool isServiceable;
  final String? area;
  final CareDeskContact? careDesk;
  final StaffStats? staff;
  final String? notice;

  ServiceLocation({
    this.city = '',
    this.cityName = '',
    this.isAddedByAdmin = false,
    this.isLive = false,
    this.isServiceable = false,
    this.area,
    this.careDesk,
    this.staff,
    this.notice,
  });

  factory ServiceLocation.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ServiceLocation();

    return ServiceLocation(
      city: json['city']?.toString() ?? '',
      cityName: json['cityName']?.toString() ?? '',
      isAddedByAdmin: json['isAddedByAdmin'] == true,
      isLive: json['isLive'] == true,
      isServiceable: json['isServiceable'] == true,
      area: json['area']?.toString(),
      careDesk: json['careDesk'] is Map<String, dynamic>
          ? CareDeskContact.fromJson(
              Map<String, dynamic>.from(json['careDesk']),
            )
          : null,
      staff: json['staff'] is Map<String, dynamic>
          ? StaffStats.fromJson(Map<String, dynamic>.from(json['staff']))
          : null,
      notice: json['notice']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'cityName': cityName,
    'isAddedByAdmin': isAddedByAdmin,
    'isLive': isLive,
    'isServiceable': isServiceable,
    if (area != null) 'area': area,
    'careDesk': careDesk?.toJson(),
    'staff': staff?.toJson(),
    if (notice != null) 'notice': notice,
  };
}

class CareDeskContact {
  final String phone;
  final String whatsapp;

  CareDeskContact({this.phone = '', this.whatsapp = ''});

  factory CareDeskContact.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CareDeskContact();

    return CareDeskContact(
      phone: json['phone']?.toString() ?? '',
      whatsapp: json['whatsapp']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'phone': phone, 'whatsapp': whatsapp};
}

class StaffStats {
  final int registeredCaregivers;
  final int availableNow;

  StaffStats({this.registeredCaregivers = 0, this.availableNow = 0});

  factory StaffStats.fromJson(Map<String, dynamic>? json) {
    if (json == null) return StaffStats();

    return StaffStats(
      registeredCaregivers: json['registeredCaregivers'] is int
          ? json['registeredCaregivers']
          : int.tryParse(json['registeredCaregivers']?.toString() ?? '0') ?? 0,
      availableNow: json['availableNow'] is int
          ? json['availableNow']
          : int.tryParse(json['availableNow']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'registeredCaregivers': registeredCaregivers,
    'availableNow': availableNow,
  };
}

class OperationalServiceItem {
  final dynamic id;
  final String code;
  final String serviceId;
  final String name;
  final String category;
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryDesc;
  final int categoryOrder;
  final String type;
  final String kind;
  final String desc;
  final String icon;
  final String? image;
  final String priceMode;
  final int price;
  final String priceFormatted;
  final String unit;
  final List<String> options;
  final List<String> tasks;
  final String? cityId;
  final String? city;
  final bool enabled;
  final bool comingSoon;
  final int order;
  final String? createdAt;
  final String? updatedAt;
  final bool availableInLocation;
  final String serviceableCity;
  final String careDeskPhone;
  final String careDeskWhatsapp;

  OperationalServiceItem({
    this.id,
    this.code = '',
    this.serviceId = '',
    required this.name,
    this.category = '',
    this.categoryId = '',
    this.categoryName = '',
    this.categoryIcon = 'cross',
    this.categoryDesc = '',
    this.categoryOrder = 1,
    this.type = 'care',
    this.kind = 'care',
    this.desc = '',
    this.icon = 'cross',
    this.image,
    this.priceMode = 'contact',
    this.price = 0,
    this.priceFormatted = 'Contact for price',
    this.unit = 'per visit',
    this.options = const [],
    this.tasks = const [],
    this.cityId,
    this.city,
    this.enabled = true,
    this.comingSoon = false,
    this.order = 1,
    this.createdAt,
    this.updatedAt,
    this.availableInLocation = true,
    this.serviceableCity = '',
    this.careDeskPhone = '',
    this.careDeskWhatsapp = '',
  });

  String get priceLabel {
    if (priceFormatted.trim().isNotEmpty &&
        priceFormatted != 'Contact for price') {
      return priceFormatted;
    }
    if (price > 0) {
      final formatted =
          '₹${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
      return unit.isNotEmpty ? '$formatted $unit' : formatted;
    }
    return 'Contact for price';
  }

  factory OperationalServiceItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return OperationalServiceItem(name: '');
    }

    final List<String> optList = [];
    if (json['options'] is List) {
      for (final o in json['options'] as List) {
        if (o != null) optList.add(o.toString());
      }
    }

    final List<String> taskList = [];
    if (json['tasks'] is List) {
      for (final t in json['tasks'] as List) {
        if (t != null) taskList.add(t.toString());
      }
    }

    return OperationalServiceItem(
      id: json['id'],
      code: json['code']?.toString() ?? '',
      serviceId: json['serviceId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
      categoryIcon: json['categoryIcon']?.toString() ?? 'cross',
      categoryDesc: json['categoryDesc']?.toString() ?? '',
      categoryOrder: json['categoryOrder'] is int
          ? json['categoryOrder']
          : int.tryParse(json['categoryOrder']?.toString() ?? '1') ?? 1,
      type: json['type']?.toString() ?? 'care',
      kind: json['kind']?.toString() ?? 'care',
      desc: json['desc']?.toString() ?? '',
      icon: json['icon']?.toString() ?? 'cross',
      image: json['image']?.toString(),
      priceMode: json['priceMode']?.toString() ?? 'contact',
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      priceFormatted: json['priceFormatted']?.toString() ?? '',
      unit: json['unit']?.toString() ?? 'per visit',
      options: optList,
      tasks: taskList,
      cityId: json['cityId']?.toString(),
      city: json['city']?.toString(),
      enabled: json['enabled'] != false,
      comingSoon: json['comingSoon'] == true,
      order: json['order'] is int
          ? json['order']
          : int.tryParse(json['order']?.toString() ?? '1') ?? 1,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      availableInLocation: json['availableInLocation'] != false,
      serviceableCity: json['serviceableCity']?.toString() ?? '',
      careDeskPhone: json['careDeskPhone']?.toString() ?? '',
      careDeskWhatsapp: json['careDeskWhatsapp']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'serviceId': serviceId,
    'name': name,
    'category': category,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'categoryIcon': categoryIcon,
    'categoryDesc': categoryDesc,
    'categoryOrder': categoryOrder,
    'type': type,
    'kind': kind,
    'desc': desc,
    'icon': icon,
    if (image != null) 'image': image,
    'priceMode': priceMode,
    'price': price,
    'priceFormatted': priceFormatted,
    'unit': unit,
    'options': options,
    'tasks': tasks,
    if (cityId != null) 'cityId': cityId,
    if (city != null) 'city': city,
    'enabled': enabled,
    'comingSoon': comingSoon,
    'order': order,
    if (createdAt != null) 'createdAt': createdAt,
    if (updatedAt != null) 'updatedAt': updatedAt,
    'availableInLocation': availableInLocation,
    'serviceableCity': serviceableCity,
    'careDeskPhone': careDeskPhone,
    'careDeskWhatsapp': careDeskWhatsapp,
  };
}

class OperationalCategoryItem {
  final String id;
  final String categoryId;
  final String name;
  final String desc;
  final String icon;
  final String kind;
  final String type;
  final int order;
  final bool enabled;
  final bool comingSoon;
  final int servicesCount;
  final int liveCount;
  final List<OperationalServiceItem> services;

  OperationalCategoryItem({
    required this.id,
    this.categoryId = '',
    required this.name,
    this.desc = '',
    this.icon = 'cross',
    this.kind = 'care',
    this.type = 'care',
    this.order = 1,
    this.enabled = true,
    this.comingSoon = false,
    this.servicesCount = 0,
    this.liveCount = 0,
    this.services = const [],
  });

  factory OperationalCategoryItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return OperationalCategoryItem(id: '', name: '');
    }

    final rawServices = json['services'] is List
        ? (json['services'] as List)
        : [];

    return OperationalCategoryItem(
      id: json['id']?.toString() ?? json['categoryId']?.toString() ?? '',
      categoryId:
          json['categoryId']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      desc: json['desc']?.toString() ?? '',
      icon: json['icon']?.toString() ?? 'cross',
      kind: json['kind']?.toString() ?? 'care',
      type: json['type']?.toString() ?? 'care',
      order: json['order'] is int
          ? json['order']
          : int.tryParse(json['order']?.toString() ?? '1') ?? 1,
      enabled: json['enabled'] != false,
      comingSoon: json['comingSoon'] == true,
      servicesCount: json['servicesCount'] is int
          ? json['servicesCount']
          : int.tryParse(json['servicesCount']?.toString() ?? '0') ?? 0,
      liveCount: json['liveCount'] is int
          ? json['liveCount']
          : int.tryParse(json['liveCount']?.toString() ?? '0') ?? 0,
      services: rawServices
          .whereType<Map>()
          .map(
            (e) =>
                OperationalServiceItem.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryId': categoryId,
    'name': name,
    'desc': desc,
    'icon': icon,
    'kind': kind,
    'type': type,
    'order': order,
    'enabled': enabled,
    'comingSoon': comingSoon,
    'servicesCount': servicesCount,
    'liveCount': liveCount,
    'services': services.map((e) => e.toJson()).toList(),
  };
}
