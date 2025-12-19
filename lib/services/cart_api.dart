import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../utils/helpers/user_session.dart';

class CartAPI {
  static const String baseUrl = 'http://192.168.23.1:5000/api';

  /// 🔹 Lấy danh sách sản phẩm trong giỏ hàng
  static Future<List<dynamic>> getCartItems(String token) async {
    final url = Uri.parse('$baseUrl/cart');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Look for the 'items' key instead of 'data' to match the backend response
      if (body['items'] != null && body['items'] is List) {
        return body['items'];
      }
      // If items are null or not a list, but status is 200, return empty list
      return []; 
    } else {
      // Throw an exception with the error message from the server
      throw Exception(body['message'] ?? 'Lỗi không xác định từ server');
    }
  }

  /// 🔹 Thêm sản phẩm vào giỏ hàng
  static Future<bool> addItemToCart(
    Map<String, dynamic> data,
    String token,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/cart/items');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar("Thành công", "Sản phẩm đã được thêm vào giỏ hàng");
        return true;
      } else {
        final error = jsonDecode(response.body)['message'] ?? "Đã xảy ra lỗi";
        Get.snackbar("Lỗi", error);
        print("addItemToCart failed: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể thêm sản phẩm vào giỏ hàng");
      print("Error addItemToCart: $e");
    }
    return false;
  }

  /// 🔹 Cập nhật số lượng sản phẩm
  /// 🔹 Cập nhật số lượng sản phẩm
  static Future<bool> updateCartItem(
    int productId, // Changed from cartItemId to productId
    int quantity,
    String token,
  ) async {
    try {
      // Endpoint now matches the backend route: /api/cart/items/:productId
      final url = Uri.parse('$baseUrl/cart/items/$productId'); 
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final error = jsonDecode(response.body)['message'] ?? "Lỗi khi cập nhật số lượng";
        Get.snackbar("Lỗi", error);
        print("updateCartItem failed: ${response.body}");
        return false;
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể kết nối đến server.");
      print("Error updateCartItem: $e");
      return false;
    }
  }

  /// 🔹 Xóa sản phẩm khỏi giỏ hàng
  static Future<bool> deleteCartItem(int productId, String token) async { // Changed from cartItemId
    try {
      // Endpoint now matches the backend route: /api/cart/items/:productId
      final url = Uri.parse('$baseUrl/cart/items/$productId');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar("Thành công", "Sản phẩm đã được xóa khỏi giỏ hàng");
        return true;
      } else {
        final error = jsonDecode(response.body)['message'] ?? "Không thể xóa sản phẩm";
        Get.snackbar("Lỗi", error);
        print("deleteCartItem failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Đã xảy ra lỗi khi xóa sản phẩm");
      print("Error deleteCartItem: $e");
      return false;
    }
  }
}