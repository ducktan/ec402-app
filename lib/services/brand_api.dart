import 'dart:convert';
import 'package:http/http.dart' as http;

class BrandService {
  final String baseUrl = "http://192.168.23.1:5000/api/brands";

  Future<List<Map<String, dynamic>>> fetchBrands() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(res.body); // jsonDecode trả về Map
      final List<dynamic> data = body['data']; // truy cập đúng key 'data'
      
      // ép List<dynamic> sang List<Map<String, dynamic>>
      return data.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception("Failed to load brands");
    }
  }

    Future<Map<String, dynamic>> fetchProductsByBrandId(int brandId) async {
    final res = await http.get(Uri.parse('$baseUrl/$brandId/products'));

    if (res.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(res.body);
      return data; // data['count'], data['data']
    } else {
      throw Exception("Failed to load products");
    }
  }

  // Lấy brand theo ID
  Future<Map<String, dynamic>> fetchBrandById(int brandId) async {
    final res = await http.get(Uri.parse('$baseUrl/$brandId'));

    if (res.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(res.body);
      return body['data'] ?? {}; // trả về object brand
    } else {
      throw Exception("Failed to load brand with id $brandId");
    }
  }
}
