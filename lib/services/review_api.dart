import 'dart:convert';
import 'package:http/http.dart' as http;

class ReviewApi {
  static const String baseUrl = "http://192.168.23.1:5000/api"; // đổi thành backend URL

  /// 1. Lấy tất cả review
  static Future<List<dynamic>> getAllReviews() async {
    final url = Uri.parse("$baseUrl/reviews");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception("Failed to load all reviews");
    }
  }

  /// 2. Lấy review theo reviewId
  static Future<Map<String, dynamic>> getReviewById(int reviewId) async {
    final url = Uri.parse("$baseUrl/reviews/$reviewId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load review $reviewId");
    }
  }

  /// 3. Lấy review theo productId
  static Future<Map<String, dynamic>> getReviewsByProduct(int productId) async {
    final url = Uri.parse("$baseUrl/reviews/product/$productId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load reviews for product $productId");
    }
  }

  /// 4. Thêm review (login required)
  static Future<Map<String, dynamic>> addReview({
    required int productId,
    required int userId,
    required int rating,
    String? comment,
    required String token,
  }) async {

    print ("debug api: adding review for product $productId by user $userId with rating $rating and comment: $comment");
    final url = Uri.parse("$baseUrl/reviews");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "productId": productId,
        "userId": userId,
        "rating": rating,
        "comment": comment ?? "",
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to add review");
    }
  }

  /// 5. Sửa review (login required)
  static Future<Map<String, dynamic>> updateReview({
    required int reviewId,
    required int rating,
    String? comment,
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/reviews/$reviewId");
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "rating": rating,
        "comment": comment ?? "",
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to update review $reviewId");
    }
  }

  /// 6. Xóa review (login required)
  static Future<Map<String, dynamic>> deleteReview({
    required int reviewId,
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/reviews/$reviewId");
    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to delete review $reviewId");
    }
  }
}
