import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String baseUrl = 'https://api.open-meteo.com/v1/forecast';

  static Future<double> getTemperature() async {
    final url = Uri.parse('$baseUrl?latitude=-7.98&longitude=112.63&current_weather=true');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final temp = data['current_weather']['temperature'];
      return temp.toDouble();
    } else {
      throw Exception('Gagal mengambil data cuaca');
    }
  }

  // Chained request versi async-await
  static Future<String> getRecommendationAsync() async {
    final temp = await getTemperature();
    return temp < 25 ? 'Kopi Panas ☕' : 'Es Kopi Dingin 🧊';
  }

  // Chained request versi callback chaining
  static void getRecommendationCallback(Function(String) callback) {
    getTemperature().then((temp) {
      if (temp < 25) {
        callback('Kopi Panas ☕');
      } else {
        callback('Es Kopi Dingin 🧊');
      }
    }).catchError((_) {
      callback('Gagal mengambil rekomendasi 😞');
    });
  }
}
