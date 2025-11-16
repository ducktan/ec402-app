import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ec402_app/services/api_service.dart';
import '../../../utils/helpers/user_session.dart';
import '../../shop/controllers/home_controller.dart';

class ProfileController extends GetxController {
  final homeCtrl = HomeController.instance;
  var isLoading = true.obs;
  var user = <String, dynamic>{}.obs;
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  /// Lấy thông tin user từ API
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;

      final token = await UserSession.getToken();
      if (token == null) {
        print("--> No token found, please login again.");
        isLoading.value = false;
        return;
      }

      final data = await ApiService.getUserProfile(token);
      if (data != null) {
        user.value = data;

        // 🔁 Đồng bộ tên/email/avatar sang HomeController
        homeCtrl.setUser(
          data['name'] ?? '',
          data['email'] ?? '',
          data['avatar'] ?? '',
        );
      } else {
        print("--> Failed to load user profile");
      }
    } catch (e) {
      print("--> Error fetchUserProfile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Cập nhật thông tin user
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final success = await ApiService.updateUserProfile(data);
      if (success) {
        // 🔁 Đồng bộ ngay vào HomeController
        homeCtrl.setUser(
          data['name'] ?? homeCtrl.username.value,
          data['email'] ?? homeCtrl.email.value,
          data['avatar'] ?? homeCtrl.avatarUrl.value,
        );

        // 🧩 Refresh lại user từ API để đảm bảo đồng bộ DB
        await fetchUserProfile();
        Get.snackbar("Thành công", "Cập nhật hồ sơ thành công!");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Cập nhật thất bại: $e");
      print("--> Error updateProfile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Chọn avatar từ thư viện và upload
  Future<void> pickAvatar() async {
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile == null) return; // user hủy chọn

      final file = File(pickedFile.path);

      final token = await UserSession.getToken();
      if (token == null) {
        Get.snackbar("Lỗi", "Không tìm thấy token, vui lòng đăng nhập lại");
        return;
      }

      Get.snackbar("Đang xử lý", "Đang tải ảnh đại diện lên...");

      final uploadResult = await ApiService.uploadAvatar(file, token);

      if (uploadResult != null && uploadResult['avatar_url'] != null) {
        final newAvatarUrl = uploadResult['avatar_url'];

        // 🔁 Update HomeController để UI đồng bộ toàn app
        homeCtrl.updateAvatar(newAvatarUrl);

        // 🧩 Refresh lại user để lưu vào user controller
        await fetchUserProfile();

        Get.snackbar("Thành công", "Cập nhật ảnh đại diện thành công!");
      } else {
        Get.snackbar("Lỗi", "Không thể tải ảnh lên, vui lòng thử lại");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể chọn ảnh: $e");
      print("--> Error pickAvatar: $e");
    }
  }

  /// Xóa tài khoản
  Future<void> closeAccount() async {
    // TODO: hiển thị dialog xác nhận, gọi API xóa account, sau đó:
    // HomeController.instance.clearUser();
    // Get.offAll(() => LoginScreen());
  }
}
