import 'package:get/get.dart';
import '../../../services/product_api.dart';

class ProductController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final fetched = await ProductApi.fetchProducts();

      // ✅ SỬA LỖI: Thêm .cast<Map<String, dynamic>>()
      products.assignAll(fetched.cast<Map<String, dynamic>>());
    } finally {
      isLoading.value = false;
    }
  }
}
