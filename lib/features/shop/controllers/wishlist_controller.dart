import 'package:get/get.dart';
import '../../../services/wishlist_api.dart';
import './product_controller.dart';

class WishlistController extends GetxController {
  final WishlistApi _api = WishlistApi();

  // lưu nguyên object sản phẩm trong wishlist
  final wishlistProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    try {
      final data = await _api.fetchMyWishlist();
      wishlistProducts.assignAll(
        data.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList()
      );
    } catch (e) {
      print("Error loading wishlist: $e");
    }
  }

  bool isFavorite(int productId) =>
      wishlistProducts.any((p) => p['id'] == productId);

  Future<void> toggleWishlist(int productId) async {
  final existingIndex = wishlistProducts.indexWhere((p) => p['id'] == productId);
  if (existingIndex != -1) {
    await _api.removeFromWishlist(productId);
    wishlistProducts.removeAt(existingIndex);
  } else {
    await _api.addToWishlist(productId);
    
    // Lấy object product từ cached products (ví dụ từ ProductController)
    final productController = Get.find<ProductController>();
    final product = productController.products.firstWhere((p) => p['id'] == productId, orElse: () => {});
    if (product.isNotEmpty) wishlistProducts.add(product);
  }
}
}
