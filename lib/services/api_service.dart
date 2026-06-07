import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // 🔑 IMPORTANT: Replace this with your actual RapidAPI key
  static const String _apiKey = 'API_KEY_HERE';
  static const String _baseUrl =
      'https://real-time-product-search.p.rapidapi.com';

  static Future<List<Product>> searchProducts(String query) async {
    final uri = Uri.parse('$_baseUrl/search-v2').replace(
      queryParameters: {
        'q': query,
        'country': 'us',
        'language': 'en',
        'page': '1',
        'limit': '20',
        'sort_by': 'BEST_MATCH',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'X-RapidAPI-Key': _apiKey,
        'X-RapidAPI-Host': 'real-time-product-search.p.rapidapi.com',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['data'] != null) {
        final products = data['data']['products'] as List<dynamic>? ?? [];
        return products
            .map((p) => Product.fromJson(p as Map<String, dynamic>))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
