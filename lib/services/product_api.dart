import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductApi {
  static const String baseUrl = "http://192.168.23.1:5000/api";

  /// Fetch danh sách sản phẩm
  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/products"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final products = data['data'] as List<dynamic>;
        return products.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print("--> Error fetchProducts: $e");
      return [];
    }
  }
}
