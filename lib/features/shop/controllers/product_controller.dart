import 'package:get/get.dart';
import '../../../services/product_api.dart';

class ProductController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  /// Lấy dữ liệu từ API
  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final fetched = await ProductApi.fetchProducts();
      products.assignAll(fetched);
    } finally {
      isLoading.value = false;
    }
  }
}
