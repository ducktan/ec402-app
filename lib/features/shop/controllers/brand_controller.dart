import 'package:get/get.dart';
import '../../../services/brand_api.dart';

class BrandController extends GetxController {
  var isLoading = false.obs;

  var brands = <Map<String, dynamic>>[].obs;
  var products = <Map<String, dynamic>>[].obs;
  var productCount = 0.obs;
  var brand = <String, dynamic>{}.obs; // brand hiện tại

  final BrandService _service = BrandService();

  @override
  void onInit() {
    super.onInit();
    fetchBrands();
  }

  Future<void> fetchBrands() async {
    try {
      isLoading(true);
      final data = await _service.fetchBrands();
      brands.assignAll(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      print("Error fetching brands: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchBrandById(int brandId) async {
    try {
      isLoading(true);
      final data = await _service.fetchBrandById(brandId);
      brand.assignAll(data); // cập nhật brand hiện tại
    } catch (e) {
      print("Error fetching brand by id $brandId: $e");
    } finally {
      isLoading(false);
    }
  }

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
