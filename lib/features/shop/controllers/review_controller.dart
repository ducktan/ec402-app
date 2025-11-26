import 'package:get/get.dart';
import '../../../services/api_service.dart';

class ReviewController extends GetxController {
  var reviews = <dynamic>[].obs;
  var isLoading = false.obs;

  // Gọi hàm này khi vào màn hình chi tiết sản phẩm hoặc màn hình All Reviews
  void fetchReviews(int productId) async {
    try {
      isLoading.value = true;
      var data = await ApiService.getProductReviews(productId);
      reviews.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }
}