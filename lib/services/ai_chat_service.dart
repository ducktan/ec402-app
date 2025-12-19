import 'dart:convert';
import 'package:http/http.dart' as http;

class AiChatService {
  static const String baseUrl = 'http://192.168.23.1:5000/api/chat';

  static Future<String> sendPrompt(String prompt) async {
    print("promt là: $prompt"); 
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': prompt,
      }),
    );

    print("be trả về: $response");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['reply'];
    } else {
      throw Exception('AI error');
    }
  }
}
