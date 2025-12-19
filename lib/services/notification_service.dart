import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  static const baseUrl = "http://192.168.23.1:5000/api/notifications";

  static Future<List<dynamic>> fetchNotifications(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/my"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return jsonDecode(res.body)["data"];
  }
}
