import 'package:get/get.dart';
import '../../../utils/helpers/user_session.dart';
import '../../../services/address_api.dart';

class AddressController extends GetxController {
  var isLoading = true.obs;
  var addresses = <Map<String, dynamic>>[].obs; // danh sách địa chỉ từ API
  var selectedAddressIndex = 0.obs; // ✅ chỉ số địa chỉ được chọn

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

      final data = await AddressAPI.getAddresses(token);
      if (data != null && data is List) {
        addresses.value = List<Map<String, dynamic>>.from(data);
        // ✅ Nếu chưa chọn địa chỉ, chọn địa chỉ đầu tiên (nếu có)
        if (addresses.isNotEmpty) selectedAddressIndex.value = 0;
      }
    } catch (e) {
      print("Error fetchAddresses: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Thêm địa chỉ mới
  Future<bool> addAddress(Map<String, dynamic> address) async {
    try {
      isLoading.value = true;
      final token = await UserSession.getToken();
      if (token == null) return false;

      final success = await AddressAPI.createAddress(address, token);
      if (success) {
        await fetchAddresses();
        return true; // ✅ báo thành công
      } else {
        return false;
      }
    } catch (e) {
      print("Error addAddress: $e");
      Get.snackbar("Error", "Cannot add address");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Chọn 1 địa chỉ khi người dùng nhấn vào
  void selectAddress(int index) {
    if (index >= 0 && index < addresses.length) {
      selectedAddressIndex.value = index;
    }
  }

  /// ✅ Lấy địa chỉ hiện đang được chọn
  Map<String, dynamic>? get selectedAddress {
    if (addresses.isEmpty) return null;
    return addresses[selectedAddressIndex.value];
  }

  /// Xóa địa chỉ theo ID
  Future<bool> deleteAddress(int id) async {
    try {
      isLoading.value = true;
      final token = await UserSession.getToken();
      if (token == null) return false;

      final success = await AddressAPI.deleteAddress(id, token);
      if (success) {
        Get.snackbar("Success", "Address deleted successfully");
        await fetchAddresses(); // refresh lại danh sách
        return true;
      } else {
        Get.snackbar("Error", "Failed to delete address");
        return false;
      }
    } catch (e) {
      print("Error deleteAddress: $e");
      Get.snackbar("Error", "Cannot delete address");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateAddress(int id, Map<String, dynamic> address) async {
    try {
      isLoading.value = true;
      final token = await UserSession.getToken();
      if (token == null) return false;

      final success = await AddressAPI.updateAddress(id, address, token);
      if (success) {
        await fetchAddresses(); // refresh list
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error updateAddress: $e");
      Get.snackbar("Error", "Cannot update address");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
