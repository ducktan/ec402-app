import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../services/category_api.dart';
import '../../../services/brand_api.dart';

class SearchPageController extends GetxController {
  static SearchPageController get instance => Get.find();

  var brands = <dynamic>[].obs;
  var categories = <dynamic>[].obs;
  var searchResults = <dynamic>[].obs;
  var isLoading = false.obs;

  final searchTextController = TextEditingController();

  // --- BIẾN CHO BỘ LỌC (FILTER) ---
  // ✅ SỬA LẠI: Mặc định là 'Name' (khớp với item trong Dropdown)
  var selectedSort = 'Name'.obs; 
  
  var minPrice = TextEditingController();
  var maxPrice = TextEditingController();
  var selectedCategoryId = Rx<int?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  void fetchInitialData() async {
    try {
      isLoading.value = true;
      var b = await ApiService.getBrands();
      var c = await ApiService.getCategories();
      brands.assignAll(b);
      categories.assignAll(c);
    } finally {
      isLoading.value = false;
    }
  }

  void search({String? query}) async {
    String currentQuery = query ?? searchTextController.text;
    
    try {
      isLoading.value = true;
      
      double? min = double.tryParse(minPrice.text);
      double? max = double.tryParse(maxPrice.text);

      var results = await ApiService.searchProducts(
        query: currentQuery,
        minPrice: min,
        maxPrice: max,
        categoryId: selectedCategoryId.value,
        sort: selectedSort.value
      );
      
      searchResults.assignAll(results);
      
      if (results.isEmpty) {
        Get.snackbar("Thông báo", "Không tìm thấy sản phẩm nào phù hợp");
      }
    } catch (e) {
      print("Lỗi tìm kiếm: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void resetFilters() {
    minPrice.clear();
    maxPrice.clear();
    selectedCategoryId.value = null;
    // ✅ SỬA LẠI: Reset về 'Name'
    selectedSort.value = 'Name'; 
    search(); 
  }
}