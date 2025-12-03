import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/product_api.dart';
import '../../../services/api_service.dart';

class SearchPageController extends GetxController {
  static SearchPageController get instance => Get.find();

  var searchResults = <dynamic>[].obs; 
  var brands = <dynamic>[].obs;
  var categories = <dynamic>[].obs;
  
  var isLoading = false.obs;
  
  // ✅ THÊM BIẾN NÀY: Để kiểm tra xem có đang tìm kiếm không
  var isSearching = false.obs; 

  final searchTextController = TextEditingController();
  
  // Các biến filter khác...
  var selectedSort = 'Name'.obs; 
  var minPrice = TextEditingController();
  var maxPrice = TextEditingController();
  var selectedCategoryId = Rx<int?>(null);

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  // Hàm xử lý khi gõ phím
  void onSearchChanged(String query) {
    // ✅ CẬP NHẬT TRẠNG THÁI TÌM KIẾM
    isSearching.value = query.isNotEmpty; 

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        search(query: query);
      } else {
        // Nếu xóa hết chữ -> Xóa kết quả tìm kiếm
        searchResults.clear();
      }
    });
  }

  void fetchInitialData() async {
    try {
      // Không bật loading toàn màn hình ở đây để tránh nháy
      var b = await ApiService.getBrands();
      var c = await ApiService.getCategories();
      brands.assignAll(b);
      categories.assignAll(c);
    } catch (e) {
      print("Error init data: $e");
    }
  }

  void search({String? query}) async {
    String keyword = query ?? searchTextController.text;
    if (keyword.isEmpty && selectedCategoryId.value == null) return;

    try {
      isLoading.value = true;
      
      double? min = double.tryParse(minPrice.text);
      double? max = double.tryParse(maxPrice.text);

      var results = await ProductApi.searchProducts(
        query: keyword,
        minPrice: min,
        maxPrice: max,
        categoryId: selectedCategoryId.value,
        sort: selectedSort.value
      );
      
      searchResults.assignAll(results);
      print("🔍 Tìm thấy ${results.length} sản phẩm");

    } catch (e) {
      print("Lỗi search: $e");
    } finally {
      isLoading.value = false;
    }
  }
  
  // ... (Các hàm reset, onClose giữ nguyên) ...
  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}