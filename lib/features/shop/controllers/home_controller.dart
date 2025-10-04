import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final carousalCurrentIndex = 0.obs;
  final username = ''.obs; // 👈 thêm biến lưu tên user

  void updatePageIndicator(index) {
    carousalCurrentIndex.value = index;
  }

  void setUser(String name) {
    username.value = name;
  }
}
