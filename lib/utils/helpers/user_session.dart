import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  // 🔹 Lưu token và thông tin user sau khi login
  static Future<void> saveUserSession({
    required String token,
    required int userId,
    required String name,
    required String email,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt('userId', userId);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    await prefs.setString('userRole', role);
  }

  // 🔹 Lấy token (dùng khi gọi API)
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 🔹 Lấy thông tin user (ví dụ dùng ở Profile)
  static Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId');
    final name = prefs.getString('userName');
    final email = prefs.getString('userEmail');
    final role = prefs.getString('userRole');

    if (id == null || name == null || email == null || role == null) return null;

    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  // 🔹 Xóa session khi logout
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userRole');
  }

  // 🔹 Kiểm tra người dùng đã login chưa
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }
}
