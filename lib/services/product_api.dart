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

  /// Fetch chi tiết sản phẩm
  static Future<Map<String, dynamic>?> fetchProductDetail(int id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/products/$id"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']; // backend bạn trả {data: {...}}
      } else {
        print("Failed to load product detail: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("--> Error fetchProductDetail: $e");
      return null;
    }
  }

  /// Fetch sản phẩm liên quan
  static Future<List<Map<String, dynamic>>> fetchRelatedProducts(int id) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/products/$id/related"));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final items = data['data'] as List<dynamic>;
        return items.cast<Map<String, dynamic>>();
      } else {
        print("Failed to load related products: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      print("--> Error fetchRelatedProducts: $e");
      return [];
    }
  }

  //  Tìm kiếm sản phẩm (Search & Filter)
  static Future<List<dynamic>> searchProducts({
    String? query,
    double? minPrice,
    double? maxPrice,
    int? categoryId,
    String? sort,
  }) async {
    try {
      String url = "$baseUrl/products/search?q=1";

      if (query != null && query.isNotEmpty) url += "&query=$query";
      if (minPrice != null && minPrice > 0) url += "&minPrice=$minPrice";
      if (maxPrice != null && maxPrice > 0) url += "&maxPrice=$maxPrice";
      if (categoryId != null) url += "&categoryId=$categoryId";
      if (sort != null && sort.isNotEmpty) url += "&sort=$sort";

      print("🔵 [ProductApi] Calling: $url");

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'];
      } else {
        print("🔴 [ProductApi] Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("🔴 [ProductApi] Exception: $e");
    }
    return [];
  }
}
