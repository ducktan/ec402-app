import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/login_model.dart';
import '../models/signup_model.dart';
import '../utils/helpers/user_session.dart'; // 👈 import file UserSession
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';


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
    

        await UserSession.saveUserSession(
          token: data["token"],
          userId: data['user']['id'],
          name: data['user']['name'],
          email: data['user']['email'],
          role: data['user']['role'],
        );

        // data gồm: { message, token, user }
        return {
          "token": data["token"],
          "user": data["user"],
        };
      } else {
        print("Verify OTP failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error verifying OTP: $e");
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
    print(token);

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
        print("==> Response status: ${response.statusCode}");
        print("==> Response body: ${response.body}");

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

  


   static Future<Map<String, dynamic>?> uploadAvatar(File file, String token) async {
    try {
      final uri = Uri.parse('$baseUrl/users/upload-avatar');
      print('----->>> Uploading file: ${file.path}');

      // 🔍 Xác định kiểu ảnh dựa vào phần mở rộng
      final ext = file.path.split('.').last.toLowerCase();
      String mimeSubtype;
      switch (ext) {
        case 'png':
          mimeSubtype = 'png';
          break;
        case 'jpg':
        case 'jpeg':
          mimeSubtype = 'jpeg';
          break;
        case 'gif':
          mimeSubtype = 'gif';
          break;
        default:
          mimeSubtype = 'jpeg';
      }

      // 🔧 Tạo request multipart
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(
          await http.MultipartFile.fromPath(
            'avatar',
            file.path,
            contentType: MediaType('image', mimeSubtype), // ✅ quan trọng
          ),
        );

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('✅ Upload success: $respStr');
        try {
          return jsonDecode(respStr);
        } catch (_) {
          return {'avatar_url': respStr};
        }
      } else {
        print('❌ Upload failed: ${response.statusCode}, $respStr');
        return null;
      }
    } catch (e) {
      print('⚠️ Error uploading avatar: $e');
      return null;
    }
  }


// Address APIs can be added here similarly
/// Lấy danh sách địa chỉ
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
        // giả sử API trả về list trong key "data" hoặc trả thẳng list
        if (body is List) return body;
        if (body['data'] != null && body['data'] is List) {
          return body['data'];
        }
      } else {
        print("getAddresses failed: ${response.body}");
      }
    } catch (e) {
      print("Error getAddresses: $e");
    }
    return null;
  }

  /// Tạo địa chỉ mới
  static Future<bool> createAddress(Map<String, dynamic> data, String token) async {
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
        return true;
      } else {
        print("createAddress failed: ${response.body}");
      }
    } catch (e) {
      print("Error createAddress: $e");
    }
    return false;
  }

  // 


  // Duc check 
  // 1. Lấy danh sách Brands
  static Future<List<dynamic>> getBrands() async {
    try {
      // Gọi tới: /api/shop/brands
      final response = await http.get(Uri.parse("$baseUrl/brands"));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'];
      }
    } catch (e) {
      print("Error getBrands: $e");
    }
    return [];
  }

  // 2. Lấy danh sách Categories
  static Future<List<dynamic>> getCategories() async {
    try {
      // Gọi tới: /api/shop/categories
      final response = await http.get(Uri.parse("$baseUrl/categories"));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'];
      }
    } catch (e) {
      print("Error getCategories: $e");
    }
    return [];
  }

  // 3. Tìm kiếm sản phẩm
  static Future<List<dynamic>> searchProducts({
    String? query,
    double? minPrice,
    double? maxPrice,
    int? categoryId,
    String? sort,
  }) async {
    try {
      // Xây dựng URL với query params
      String url = "$baseUrl/products/search?q=1"; // q=1 làm mồi để nối & phía sau

      if (query != null && query.isNotEmpty) url += "&query=$query";
      if (minPrice != null) url += "&minPrice=$minPrice";
      if (maxPrice != null) url += "&maxPrice=$maxPrice";
      if (categoryId != null) url += "&categoryId=$categoryId";
      if (sort != null) url += "&sort=$sort";

      print("🔵 API URL: $url");

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'];
      }
    } catch (e) {
      print("Error searchProducts: $e");
    }
    return [];
  }

  static Future<List<dynamic>> getProductReviews(int productId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/reviews/$productId"));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'];
      }
    } catch (e) {
      print("Error getProductReviews: $e");
    }
    return [];
  }
  // Gửi đánh giá lên Server
  static Future<bool> createReview(int productId, int rating, String comment) async {
    // Lấy token từ UserSession (giả sử bạn đã lưu token ở đó)
    final token = await UserSession.getToken(); 
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reviews"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "product_id": productId,
          "rating": rating,
          "comment": comment,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        // In lỗi từ server trả về (ví dụ: chưa mua hàng)
        final json = jsonDecode(response.body);
        print("Lỗi tạo review: ${json['message']}");
        Get.snackbar("Lỗi", json['message']); // Hiển thị thông báo cho user
        return false;
      }
    } catch (e) {
      print("Error createReview: $e");
      return false;
    }
  }



}
