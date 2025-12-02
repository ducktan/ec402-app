import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ec402_app/utils/helpers/user_session.dart';


class WishlistApi {
  final String baseUrl = "http://192.168.23.1:5000/api/wishlist";

  /// Lấy wishlist của chính mình
  Future<List<Map<String, dynamic>>> fetchMyWishlist() async {
    final token = await UserSession.getToken();
    if (token == null) throw Exception("User not logged in");

    final res = await http.get(
      Uri.parse("$baseUrl/my"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return List<Map<String, dynamic>>.from(body);
    }
    throw Exception("Failed to fetch wishlist");
  }

  /// Thêm sản phẩm vào wishlist
  Future<void> addToWishlist(int productId) async {
    final token = await UserSession.getToken();
    if (token == null) throw Exception("User not logged in");

    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'productId': productId}),
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['message'] ?? 'Add to wishlist failed');
    }
  }

  /// Xóa sản phẩm khỏi wishlist
  Future<void> removeFromWishlist(int productId) async {
    final token = await UserSession.getToken();
    if (token == null) throw Exception("User not logged in");

    final res = await http.delete(
      Uri.parse("$baseUrl/$productId"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['message'] ?? 'Remove from wishlist failed');
    }
  }
}
