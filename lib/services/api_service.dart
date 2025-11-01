import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_model.dart';
import '../models/signup_model.dart';
import '../utils/helpers/user_session.dart'; // 👈 import file UserSession
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ApiService {
  static const String baseUrl = "http://192.168.23.1:5000/api"; // đổi theo IP backend

  // =========================================================
  // 🟢 LOGIN
  // =========================================================
  static Future<LoginResponse?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");

    try {
      print("Login Request → email: $email, password: $password");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(data);

        // ✅ Lưu session bằng UserSession
        await UserSession.saveUserSession(
          token: loginResponse.token,
          userId: loginResponse.user.id,
          name: loginResponse.user.name,
          email: loginResponse.user.email,
          role: loginResponse.user.role,
        );


        return loginResponse;
      } else {
        print("❌ Login failed: ${response.statusCode}, body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Login error: $e");
      return null;
    }
  }

  // =========================================================
  // 🟢 SIGNUP
  // =========================================================
  static Future<SignupResponse?> signup(SignupRequest data) async {
    final url = Uri.parse("$baseUrl/auth/register");

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data.toJson()),
      );

      final json = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        print("✅ Signup success: ${json['message']}");
        return SignupResponse.fromJson(json);
      } else {
        print("❌ Signup failed: ${res.statusCode}");
        return SignupResponse(message: json['message'] ?? 'Signup failed');
      }
    } catch (e) {
      print("⚠️ Signup error: $e");
      return SignupResponse(message: "Error: $e");
    }
  }

  // =========================================================
  // 🔴 LOGOUT
  // =========================================================
  static Future<bool> logout() async {
    try {
      await UserSession.clearSession(); // ✅ Xóa toàn bộ thông tin lưu trữ
      print("✅ Logout success: local session cleared");
      return true;
    } catch (e) {
      print("⚠️ Logout error: $e");
      return false;
    }
  }


    // =========================================================
  // 🟡 LOGIN OTP - GỬI OTP (Gen OTP)
  // =========================================================
  static Future<bool> loginOTP(String phone) async {
    final url = Uri.parse("$baseUrl/auth/login-otp");

    try {
      print("📨 Sending OTP to: $phone");
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phone}),
      );

      if (res.statusCode == 200) {
        print("✅ OTP sent successfully");
        return true;
      } else {
        print("❌ OTP request failed: ${res.statusCode}, body: ${res.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ OTP send error: $e");
      return false;
    }
  }

  // ------------------ VERIFY OTP ------------------
  static Future<Map<String, dynamic>?> verifyOTP(String phone, String otp) async {
    final url = Uri.parse("$baseUrl/auth/verify-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phone, "otp": otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        // data gồm: { message, token, user }
        return {
          "token": data["token"],
          "user": data["user"],
        };
      } else {
        print("❌ Verify OTP failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error verifying OTP: $e");
      return null;
    }
  }

  // ✅ Get user info using token
  static Future<Map<String, dynamic>?> getUserProfile(String token) async {
    final url = Uri.parse("$baseUrl/users");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // { id, name, email, phone, ... }
      } else {
        print("❌ Get user failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error getting user profile: $e");
      return null;
    }
  }



  static Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    final token = await UserSession.getToken();
    try {
      print(token);
      final url = Uri.parse('$baseUrl/users');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token ?? ''}',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Profile updated successfully");
        return true;
      } else {
        final body = jsonDecode(response.body);
        Get.snackbar("Error", body['message'] ?? "Failed to update profile");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to connect to server");
      print("==> API updateUserProfile error: $e");
      return false;
    }
  }
}
