import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_model.dart';
import '../models/signup_model.dart';

class ApiService {
  static const String baseUrl = "http://192.168.23.1:5000/api"; // đổi theo IP BE ông
  // Login API
  static Future<LoginResponse?> login(String email, String password) async {
    const String url = "http://192.168.23.1:5000/api/auth/login"; // đổi thành API thật

    try {
      print("Login Request -> email: $email, password: $password");

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Login success -> parsed data: $data");
        return LoginResponse.fromJson(data);
      } else {
        print("Login failed: ${response.statusCode}, body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }


  static Future<SignupResponse?> signup(SignupRequest data) async {
    final url = Uri.parse("$baseUrl/auth/register");

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data.toJson()),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final json = jsonDecode(res.body);
        return SignupResponse.fromJson(json);
      } else {
        final json = jsonDecode(res.body);
        return SignupResponse(message: json['message'] ?? 'Signup failed');
      }
    } catch (e) {
      return SignupResponse(message: "Error: $e");
    }
  }

}
