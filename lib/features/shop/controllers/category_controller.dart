import 'package:get/get.dart';
import '../../../services/category_api.dart';

class CategoryController extends GetxController {
  final CategoryService _service = CategoryService();

  var isLoading = false.obs;

  var categories = <Map<String, dynamic>>[].obs;
  var selectedCategory = {}.obs;

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
      isLoading(true);
      final data = await _service.fetchCategories();
      categories.assignAll(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Chọn category → fetch products luôn
  Future<void> selectCategory(int categoryId) async {
    try {
      isLoading(true);

      final detail = await _service.fetchCategoryById(categoryId);
      selectedCategory.value = detail;

      final prod = await _service.fetchProductsByCategoryId(categoryId);
      productCount.value = prod['count'];
      products.assignAll(List<Map<String, dynamic>>.from(prod['data']));
    } catch (e) {
      print("Error selecting category: $e");
    } finally {
      isLoading(false);
    }
  }
}
