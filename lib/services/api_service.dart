import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_model.dart';

class ApiService {
  // Login API
  static Future<LoginResponse?> login(String email, String password) async {
    const String url = "http://10.0.0.2:5000/api/auth/login"; // đổi thành API thật

    try {
      // --- Print request
      print("Login Request -> email: $email, password: $password");

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      // --- Print response status + body
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Login success -> parsed data: $data"); // debug parsed JSON
        return LoginResponse.fromJson(data);
      } else {
        print("Login failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }
}
