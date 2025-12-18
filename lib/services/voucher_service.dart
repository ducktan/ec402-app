import 'dart:convert';
import 'package:http/http.dart' as http;

class VoucherService {
  static const String baseUrl = "http://10.0.2.2:5000/api";

  static Future<List<dynamic>> fetchVouchers(String token) async {
    print("debug voucher: $token");
    final res = await http.get(
      Uri.parse("$baseUrl/available"),
      headers: {"Authorization": "Bearer $token"},
    );

    final data = jsonDecode(res.body);
    print("data chỗ ni: $data");
    return data["data"];
  }

  static Future<Map<String, dynamic>> applyVoucher({
    required String token,
    required String code,
    required double orderTotal,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/apply"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"code": code, "orderTotal": orderTotal}),
    );

    return jsonDecode(res.body);
  }
}
