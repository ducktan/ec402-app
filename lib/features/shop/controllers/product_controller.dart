import 'package:get/get.dart';
import '../../../services/product_api.dart';

class ProductController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  /// New: sản phẩm chi tiết
  var productDetail = <String, dynamic>{}.obs;
  var isLoadingDetail = false.obs;

  /// New: sản phẩm liên quan
  var relatedProducts = <Map<String, dynamic>>[].obs;
  var isLoadingRelated = false.obs;

  /// Lấy danh sách sản phẩm
  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final fetched = await ProductApi.fetchProducts();
      products.assignAll(fetched);
    } finally {
      isLoading.value = false;
    }
  }

  /// Lấy chi tiết sản phẩm
  Future<void> loadProductDetail(int id) async {
    try {
      isLoadingDetail(true);
      final data = await ProductApi.fetchProductDetail(id);
      if (data != null) productDetail.assignAll(data);
    } finally {
      isLoadingDetail(false);
    }
  }

  /// Lấy sản phẩm liên quan
  Future<void> loadRelated(int id) async {
    try {
      isLoadingRelated(true);
      final data = await ProductApi.fetchRelatedProducts(id);
      relatedProducts.assignAll(data);
    } finally {
      isLoadingRelated(false);
    }
  }
}
