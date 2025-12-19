import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ec402_app/utils/helpers/user_session.dart';

class OrderService {
  static const String baseUrl =
      "http://192.168.23.1:5000/api/orders"; // Android emulator

  static Future<Map<String, dynamic>> createOrder({
    required String token,
    required String paymentMethod,
    required Map<String, dynamic> shippingAddress,
    required double totalAmount,
  }) async {
    final url = Uri.parse("$baseUrl");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "payment_method": paymentMethod,
        "shipping_address": shippingAddress,
        "total_amount": totalAmount,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Lỗi tạo đơn hàng");
    }
  }

  static Future<List<dynamic>> getMyOrders() async {
    final token = await UserSession.getToken();
    final url = Uri.parse("$baseUrl/me");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // body["data"] phải là List
      return body["data"] as List<dynamic>;
    } else {
      throw Exception(body["message"] ?? "Failed to load orders");
    }
  }

  // ============================
  // GET ORDER DETAIL BY ID
  // ============================
  static Future<Map<String, dynamic>> getDetailOrder(int id) async {
    final token = await UserSession.getToken();
    final url = Uri.parse("$baseUrl/$id");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(body);
      return body["data"] as Map<String, dynamic>;
    } else {
      throw Exception(body["message"] ?? "Failed to load order detail");
    }
  }


  static Future<bool> cancelOrder(int orderId) async {
    final token = await UserSession.getToken();
    final url = Uri.parse("$baseUrl/$orderId/cancel");

    final response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(body["message"] ?? "Failed to cancel order");
    }
  }
}
