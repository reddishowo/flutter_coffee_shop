import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  static const String baseUrl = 'https://fakestoreapi.com/products/category';

  static Future<List<dynamic>> getProductsByCategory(String category) async {
    final url = Uri.parse('$baseUrl/$category');
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(url);
      stopwatch.stop();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('HTTP Fetch time: ${stopwatch.elapsedMilliseconds} ms');
        return data;
      } else {
        throw Exception('HTTP Error ${response.statusCode}');
      }
    } catch (e) {
      print('HTTP Error: $e');
      rethrow;
    }
  }
}
