import 'package:get/get.dart';
import '../../../services/brand_api.dart';

class BrandController extends GetxController {
  // === Reactive state ===
  var isLoading = false.obs;
  var brands = <Map<String, dynamic>>[].obs;          // Toàn bộ brand
  var products = <Map<String, dynamic>>[].obs;        // Sản phẩm theo brand
  var productCount = 0.obs;
  var brand = <String, dynamic>{}.obs;               // Brand hiện tại
  var brandCache = <int, Map<String, dynamic>>{}.obs; // Cache brand theo ID

  final BrandService _service = BrandService();

  @override
  void onInit() {
    super.onInit();
    fetchBrands(); // load toàn bộ brand khi khởi tạo
  }

  /// Lấy toàn bộ brand
  Future<void> fetchBrands() async {
    try {
      isLoading(true);
      final data = await _service.fetchBrands();
      brands.assignAll(List<Map<String, dynamic>>.from(data));


      // Lưu vào cache luôn
      for (var b in brands) {
        final id = b['id'];
        if (id != null) {
          brandCache[id] = b;
        }
      }
    } catch (e) {
      print("Error fetching brands: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Lấy brand theo ID + lưu cache
  Future<Map<String, dynamic>> fetchBrandById(int brandId) async {
    try {
      // Nếu đã có cache → dùng luôn
      if (brandCache.containsKey(brandId)) {
        return brandCache[brandId]!;
      }

      isLoading(true);
      final data = await _service.fetchBrandById(brandId);

      // Lưu vào cache và cập nhật brand hiện tại
      brandCache[brandId] = Map<String, dynamic>.from(data);
      brand.assignAll(data);

      return data;
    } catch (e) {
      print("Error fetching brand by id $brandId: $e");
      return {};
    } finally {
      isLoading(false);
    }
  }

  /// Hàm tiện ích lấy brand name theo ID
  String getBrandName(dynamic brandId) {
    if (brandId == null) return "Unknown";

    final int id = brandId is int ? brandId : int.tryParse(brandId.toString()) ?? 0;
    if (brandCache.containsKey(id)) {
      return brandCache[id]!['name'] ?? "Unknown";
    }

    fetchBrandById(id); // async, UI sẽ update sau
    return "Loading...";
  }

  /// Lấy sản phẩm theo brand
  Future<void> fetchProducts(int brandId) async {
    try {
      isLoading(true);
      final data = await _service.fetchProductsByBrandId(brandId);
      productCount.value = data['count'] ?? 0;

      final list = data['data'] ?? [];
      products.assignAll(List<Map<String, dynamic>>.from(list));
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading(false);
    }
  }
}
