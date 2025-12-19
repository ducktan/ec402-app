import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  final String baseUrl = "http://192.168.23.1:5000/api";

  /// Lấy toàn bộ category
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final res = await http.get(Uri.parse("$baseUrl/categories"));
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return List<Map<String, dynamic>>.from(body['data'] ?? []);
    }
    throw Exception("Failed to fetch categories");
  }

  /// Lấy category theo ID
  Future<Map<String, dynamic>> fetchCategoryById(int id) async {
    final res = await http.get(Uri.parse("$baseUrl/categories/$id"));
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return Map<String, dynamic>.from(body['data'] ?? {});
    }
    throw Exception("Failed to fetch category details");
  }

  /// Lấy sản phẩm theo category ID
  Future<Map<String, dynamic>> fetchProductsByCategoryId(int id) async {
    final res = await http.get(Uri.parse("$baseUrl/categories/$id/products"));

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);

      return {
        'count': body['count'] ?? 0,
        'data': List<Map<String, dynamic>>.from(body['data'] ?? [])
      };
    }

    throw Exception("Failed to fetch products by category");
  }
}
