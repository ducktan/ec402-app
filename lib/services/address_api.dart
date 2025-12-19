import 'dart:convert';
import 'package:http/http.dart' as http;

class AddressAPI {
  static const String baseUrl = "http://192.168.23.1:5000/api";

  /// 🔹 Lấy danh sách địa chỉ
  static Future<List<dynamic>?> getAddresses(String token) async {
    try {
      final url = Uri.parse('$baseUrl/users/addresses');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // API có thể trả về mảng trực tiếp hoặc có key "data"
        if (body is List) return body;
        if (body['data'] != null && body['data'] is List) {
          return body['data'];
        }
      } else {
        print("❌ getAddresses failed: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("⚠️ Error getAddresses: $e");
    }
    return null;
  }

  /// 🔹 Tạo địa chỉ mới
  static Future<bool> createAddress(
      Map<String, dynamic> data, String token) async {
    try {
      final url = Uri.parse('$baseUrl/users/addresses');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("✅ Address created successfully");
        return true;
      } else {
        print("❌ createAddress failed: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Error createAddress: $e");
    }
    return false;
  }

  /// 🔹 Cập nhật địa chỉ
  static Future<bool> updateAddress(
      int id, Map<String, dynamic> data, String token) async {
    try {
      final url = Uri.parse('$baseUrl/users/addresses/$id');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("✅ Address updated successfully");
        return true;
      } else {
        print("❌ updateAddress failed: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Error updateAddress: $e");
    }
    return false;
  }

  /// 🔹 Xóa địa chỉ
  static Future<bool> deleteAddress(int id, String token) async {
    try {
      final url = Uri.parse('$baseUrl/users/addresses/$id');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("✅ Address deleted successfully");
        return true;
      } else {
        print("❌ deleteAddress failed: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Error deleteAddress: $e");
    }
    return false;
  }
}
