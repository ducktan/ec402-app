import 'package:get/get.dart';
import '../../../utils/helpers/user_session.dart';
import '../../../services/api_service.dart';

class AddressController extends GetxController {
  var isLoading = true.obs;
  var addresses = <Map<String, dynamic>>[].obs; // dùng Map

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  /// Lấy danh sách địa chỉ từ API
  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      final token = await UserSession.getToken();
      if (token == null) return;

      final data = await ApiService.getAddresses(token);
      if (data != null && data is List) {
        addresses.value = List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print("Error fetchAddresses: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Thêm địa chỉ mới
  Future<void> addAddress(Map<String, dynamic> address) async {
    try {
      isLoading.value = true;
      final token = await UserSession.getToken();
      if (token == null) return;

      final success = await ApiService.createAddress(address, token);
      if (success) {
        Get.snackbar("Success", "Address added successfully");
        await fetchAddresses(); // refresh list
      }
    } catch (e) {
      print("Error addAddress: $e");
      Get.snackbar("Error", "Cannot add address");
    } finally {
      isLoading.value = false;
    }
  }
}
