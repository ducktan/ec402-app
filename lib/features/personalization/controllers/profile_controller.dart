import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ec402_app/services/api_service.dart';
import '../../../utils/helpers/user_session.dart';
import '../../shop/controllers/home_controller.dart';
import 'package:dio/dio.dart' as dio;

class ProfileController extends GetxController {
  final homeCtrl = HomeController.instance;
  var isLoading = true.obs;
  var user = {}.obs;
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final token = await UserSession.getToken();
      if (token == null) {
        print("--> No token found, please login again.");
        isLoading.value = false;
        return;
      }
      print("debug token: $token");
      final data = await ApiService.getUserProfile(token);
      print("debug data respone: $data");
      if (data != null) {
        user.value = data;
      } else {
        print("--> Failed to load user profile");
      }
    } catch (e) {
      print("--> Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    isLoading.value = true;
    final success = await ApiService.updateUserProfile(data);
    if (success) {
      await fetchUserProfile(); // refresh lại dữ liệu
      Get.snackbar("Thành công", "Cập nhật hồ sơ thành công!");
    }
    isLoading.value = false;
  }

  Future<void> pickAvatar() async {
    final homeCtrl = HomeController.instance;

    try {
      // 1️⃣ Chọn ảnh từ thư viện
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile == null) return; // user hủy chọn ảnh

      final file = File(pickedFile.path);

      // 2️⃣ Lấy token đăng nhập
      final token = await UserSession.getToken();
      if (token == null) {
        Get.snackbar("Lỗi", "Không tìm thấy token, vui lòng đăng nhập lại");
        return;
      }

      // 3️⃣ Thông báo đang xử lý
      Get.snackbar("Đang xử lý", "Đang tải ảnh đại diện lên...");

      // 4️⃣ Gửi request upload lên server
      final uploadResult = await ApiService.uploadAvatar(file, token);

      // 5️⃣ Nếu upload thành công → cập nhật avatar toàn cục
      if (uploadResult != null && uploadResult['avatar_url'] != null) {
        final newAvatarUrl = uploadResult['avatar_url'];

        // 🔁 Cập nhật vào HomeController để đồng bộ UI toàn app
        homeCtrl.updateAvatar(newAvatarUrl);

        // 🧩 Nếu bạn có fetchUserProfile() thì vẫn gọi để sync DB
        await fetchUserProfile();

        Get.snackbar("Thành công", "Cập nhật ảnh đại diện thành công!");
      } else {
        Get.snackbar("Lỗi", "Không thể tải ảnh lên, vui lòng thử lại");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể chọn ảnh: $e");
    }
  }

  Future<void> closeAccount() async {
    // TODO: xác nhận rồi gọi API xóa tài khoản
  }
}
