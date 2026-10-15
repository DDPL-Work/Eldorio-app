import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/client_data_controller.dart';
import 'package:eldoriaCare/model/client_models.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String val) {
    searchQuery.value = val;
  }

  void clearSearch() {
    searchQuery.value = '';
    searchController.clear();
  }

  List<ServiceItem> get searchResults {
    if (searchQuery.value.trim().isEmpty) return [];
    return ClientDataController.to.searchServices(searchQuery.value);
  }
}
