import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ec402_app/utils/helpers/user_session.dart';

class GameService {
  // LƯU Ý QUAN TRỌNG:
  // Nếu chạy trên Android Emulator: dùng 10.0.2.2
  // Nếu chạy trên máy thật: dùng IP LAN của máy tính (ví dụ 192.168.1.x)
  static const String baseUrl = 'http://192.168.23.1:5000/api';

  static Future<Map<String, dynamic>> spinWheel() async {
    final token = await UserSession.getToken();

    if (token == null) {
      throw Exception('Bạn chưa đăng nhập!');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/game/spin'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Gửi kèm token
      },
      body: jsonEncode({}), // Body rỗng
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data; // Trả về {success: true, index: 2, ...}
    } else {
      // Xử lý lỗi (ví dụ: đã quay rồi, hoặc token hết hạn)
      throw Exception(data['message'] ?? 'Lỗi kết nối server');
    }
  }
}