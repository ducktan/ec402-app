import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../utils/helpers/user_session.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var user = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      // get token when login
      final token = await UserSession.getToken();
      if (token == null) {
        print("--> No token found, please login again.");
        isLoading.value = false;
        return;
      }

      final data = await ApiService.getUserProfile(token);
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
      await fetchUserProfile(); // refresh lại dữ liệu sau khi update
    }
    isLoading.value = false;
  }

  Future<void> pickAvatar() async {
    // chọn ảnh từ gallery, upload lên server (tùy bạn cài thêm)
  }

  Future<void> closeAccount() async {
    // xác nhận rồi xóa account
  }


}
