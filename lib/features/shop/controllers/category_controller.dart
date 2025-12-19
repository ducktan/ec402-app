import 'package:get/get.dart';
import '../../../services/category_api.dart';

class CategoryController extends GetxController {
  final CategoryService _service = CategoryService();

  var isLoadingCategories = false.obs;
  var isLoadingProducts = false.obs;

  var categories = <Map<String, dynamic>>[].obs;
  var selectedCategory = <String, dynamic>{}.obs;

  var products = <Map<String, dynamic>>[].obs;
  var productCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// Lấy danh sách category
  Future<void> fetchCategories() async {
    try {
      isLoadingCategories(true);
      final data = await _service.fetchCategories();
      categories.assignAll(data);
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      isLoadingCategories(false);
    }
  }

  /// Chọn category + fetch sản phẩm
  Future<void> selectCategory(int categoryId) async {
    try {
      isLoadingProducts(true);

      // Fetch details
      final detail = await _service.fetchCategoryById(categoryId);
      selectedCategory.assignAll(detail);

      // Fetch sản phẩm theo category
      final prod = await _service.fetchProductsByCategoryId(categoryId);
      productCount.value = prod['count'] ?? 0;
      products.assignAll(prod['data'] ?? []);

    } catch (e) {
      print("Error selecting category: $e");
    } finally {
      isLoadingProducts(false);
    }
  }
}
