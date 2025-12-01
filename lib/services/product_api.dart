import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ProductApi {
  static const String baseUrl = ApiService.baseUrl;

  // 1. Tìm kiếm sản phẩm (Search & Filter)
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

  // 2. Lấy danh sách Brands
  static Future<List<dynamic>> getBrands() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/brands"));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'] ?? json;
      }
    } catch (e) {
      print("🔴 [ProductApi] Error getBrands: $e");
    }
    return [];
  }

  // 3. Lấy danh sách Categories
  static Future<List<dynamic>> getCategories() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/categories"));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'] ?? json;
      }
    } catch (e) {
      print("🔴 [ProductApi] Error getCategories: $e");
    }
    return [];
  }

  // ✅ 4. LẤY TẤT CẢ SẢN PHẨM (Hàm bạn đang thiếu)
  static Future<List<dynamic>> fetchProducts() async {
    try {
      // Gọi tới API: /api/products (Xem lại app.js backend của bạn)
      final response = await http.get(Uri.parse("$baseUrl/products"));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'];
      } else {
        print("🔴 [ProductApi] Error fetchProducts: ${response.statusCode}");
      }
    } catch (e) {
      print("🔴 [ProductApi] Exception fetchProducts: $e");
    }
    return [];
  }
}
