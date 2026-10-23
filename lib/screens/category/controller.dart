import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/repository.dart';
import 'package:eldoriaCare/model/services_model.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/logger.dart';
import 'package:eldoriaCare/widget/soon_bottom_sheet.dart';

class CategoryController extends GetxController {
  static CategoryController get to => Get.find();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString categoryId = ''.obs;
  final Rxn<OperationalCategoryItem> category = Rxn<OperationalCategoryItem>();
  final RxList<OperationalServiceItem> services =
      <OperationalServiceItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    categoryId.value = args?.toString() ?? 'elder';
    fetchCategoryServices();
  }

  // ── Computed Getters ────────────────────────────────────────────────────
  String get categoryName => category.value?.name ?? 'Category';

  String get categoryDesc => category.value?.desc ?? '';

  bool get isComingSoon => category.value?.comingSoon == true;

  bool get isEquipment => category.value?.kind == 'equipment';

  bool get hasServices => services.isNotEmpty;

  // ── API Fetching & Data Resolution ──────────────────────────────────────
  Future<void> fetchCategoryServices({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await Repository.instance.getServices(
        category: categoryId.value.isNotEmpty ? categoryId.value : 'all',
      );
      Logger.m(tag: 'Fetch Category Services Response', value: response);

      if (response != null && response is Map) {
        final parsed = ServicesResponse.fromJson(
          Map<String, dynamic>.from(response),
        );

        if (parsed.success && parsed.data != null) {
          final data = parsed.data!;
          final catIdLower = categoryId.value.trim().toLowerCase();

          // 1. Try to find the matching category
          final matchedCat = data.categories.firstWhereOrNull((c) {
            return c.id.toLowerCase() == catIdLower ||
                c.categoryId.toLowerCase() == catIdLower ||
                c.name.toLowerCase() == catIdLower;
          });

          if (matchedCat != null) {
            category.value = matchedCat;

            if (matchedCat.services.isNotEmpty) {
              services.assignAll(matchedCat.services);
            } else {
              // Filter services by category identifier/name
              final filtered = data.services.where((s) {
                return s.categoryId.toLowerCase() ==
                        matchedCat.id.toLowerCase() ||
                    s.categoryId.toLowerCase() ==
                        matchedCat.categoryId.toLowerCase() ||
                    s.category.toLowerCase() == matchedCat.name.toLowerCase() ||
                    s.categoryName.toLowerCase() ==
                        matchedCat.name.toLowerCase();
              }).toList();
              services.assignAll(filtered);
            }
          } else {
            // Fallback: match directly on services if category item not in categories list
            final filtered = data.services.where((s) {
              return s.categoryId.toLowerCase() == catIdLower ||
                  s.category.toLowerCase() == catIdLower ||
                  s.categoryName.toLowerCase() == catIdLower;
            }).toList();

            if (filtered.isNotEmpty) {
              category.value = OperationalCategoryItem(
                id: categoryId.value,
                name: filtered.first.categoryName.isNotEmpty
                    ? filtered.first.categoryName
                    : filtered.first.category,
                desc: filtered.first.categoryDesc,
                icon: filtered.first.categoryIcon,
                kind: filtered.first.kind,
              );
              services.assignAll(filtered);
            }
          }
        } else {
          errorMessage.value = parsed.message.isNotEmpty
              ? parsed.message
              : 'Failed to load category services';
        }
      }
    } catch (e) {
      Logger.e(tag: 'Fetch Category Services Error', value: e);
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ── Actions ─────────────────────────────────────────────────────────────
  void onServiceAction(BuildContext context, OperationalServiceItem service) {
    if (service.comingSoon || isComingSoon) {
      SoonBottomSheet.show(context, title: service.name, iconKey: service.icon);
    } else {
      Get.toNamed(
        AppRoutes.book,
        arguments: service.serviceId.isNotEmpty
            ? service.serviceId
            : service.id,
      );
    }
  }

  void onHelpPressed() {
    Get.toNamed(AppRoutes.help);
  }
}
