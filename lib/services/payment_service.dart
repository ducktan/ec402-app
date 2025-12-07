import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ec402_app/utils/helpers/user_session.dart';

class PaymentService {
  static const String baseUrl = "http://192.168.23.1:5000/api/orders";

  static Future<String> createPaymentIntent(double amount) async {
    final url = Uri.parse("$baseUrl/create-payment-intent");

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': amount}),
    );

    final data = jsonDecode(res.body);

    return data["clientSecret"];
  }

  static Future<void> createTransaction({
    required int orderId,
    required String provider, // "stripe"
    required double amount,
    required String status, // "success", "pending", "failed"
  }) async {
    final token = await UserSession.getToken();
    final url = Uri.parse("${baseUrl}/create-transaction");

    final body = {
      "order_id": orderId,
      "provider": provider,
      "amount": amount,
      "status": status,
      "transaction_code": "",
    };

    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(
          "Tạo transaction thất bại: ${res.statusCode} ${res.body}");
    }
  }
}