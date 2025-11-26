import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final carousalCurrentIndex = 0.obs;
  final username = ''.obs; // 👈 thêm biến lưu tên user
  final email = ''.obs;
  final avatarUrl = ''.obs; // 👈 thêm dòng này

  void updatePageIndicator(index) {
    carousalCurrentIndex.value = index;
  }

  void setUser(String name, String mail, String? avatar) {
    username.value = name;
    email.value = mail;
    avatarUrl.value = avatar ?? ''; // nếu không có thì để rỗng
  }

  // ✅ Thêm 2 hàm sau:
  /// Cập nhật avatar realtime sau khi upload
  void updateAvatar(String newUrl) {
    avatarUrl.value = newUrl;
  }

  /// Xóa thông tin user khi logout
  void clearUser() {
    username.value = '';
    email.value = '';
    avatarUrl.value = '';
  }
}
