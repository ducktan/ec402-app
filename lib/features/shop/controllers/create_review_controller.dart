import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';

class CreateReviewController extends GetxController {
  final int productId;
  CreateReviewController({required this.productId});

  var rating = 5.obs;
  final commentController = TextEditingController();
  var isSubmitting = false.obs;

  // Hàm gửi đánh giá
  void submitReview() async {
    if (commentController.text.trim().isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập nội dung đánh giá");
      return;
    }

    isSubmitting.value = true;

    // Gọi API
    bool success = await ApiService.createReview(
      productId,
      rating.value,
      commentController.text,
    );

    isSubmitting.value = false;

    if (success) {
      Get.snackbar("Thành công", "Cảm ơn bạn đã đánh giá!");
      Get.back(result: true); // Đóng màn hình và báo thành công để reload list
    }
    else {
      Get.snackbar("Lỗi", "Gửi đánh giá thất bại. Vui lòng thử lại.");
    }
  }
}