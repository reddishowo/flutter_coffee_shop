// File: /lib/app/services/weather_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String baseUrl = 'https://api.open-meteo.com/v1/forecast';

  // --- [BARU] Mengambil Data Lengkap (Suhu, Angin, Kelembapan, Kode) ---
  // Digunakan untuk halaman Detail Cuaca
  static Future<Map<String, dynamic>> getWeatherDetails(double lat, double long) async {
    final url = Uri.parse(
      '$baseUrl?latitude=$lat&longitude=$long&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m'
    );
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final current = data['current'];
      
      return {
        'temp': current['temperature_2m'].toDouble(),
        'humidity': current['relative_humidity_2m'], // Integer
        'wind': current['wind_speed_10m'], // Double
        'code': current['weather_code'], // Integer (WMO code)
      };
    } else {
      throw Exception('Gagal mengambil detail cuaca');
    }
  }

  // --- [LAMA] Hanya mengambil Suhu ---
  // Tetap dipertahankan agar kode lama tidak error
  static Future<double> getTemperature(double lat, double long) async {
    final url = Uri.parse('$baseUrl?latitude=$lat&longitude=$long&current_weather=true');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final temp = data['current_weather']['temperature'];
      return temp.toDouble();
    } else {
      throw Exception('Gagal mengambil data cuaca');
    }
  }

  // --- For Compatibility with API Experiment Page (Defaults to Malang) ---
  
  static Future<String> getRecommendationAsync() async {
    // Default to Malang coordinates for the simple API test button
    final temp = await getTemperature(-7.98, 112.63);
    return temp < 25 ? 'Kopi Panas ☕' : 'Es Kopi Dingin 🧊';
  }

  static void getRecommendationCallback(Function(String) callback) {
    getTemperature(-7.98, 112.63).then((temp) {
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