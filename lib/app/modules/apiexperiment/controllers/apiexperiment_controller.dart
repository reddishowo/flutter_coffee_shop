import 'package:get/get.dart';
import '../../../services/http_service.dart';
import '../../../services/dio_service.dart';
import '../../../services/weather_service.dart';

class ApiexperimentController extends GetxController {
  var result = ''.obs;
  var recommendation = ''.obs;

  Future<void> fetchWithHttp() async {
    result.value = 'Mengambil data via HTTP...';
    try {
      final data = await HttpService.getProductsByCategory('electronics');
      result.value = 'HTTP Sukses: ${data.length} produk ditemukan.';
    } catch (e) {
      result.value = 'HTTP Error: $e';
    }
  }

  Future<void> fetchWithDio() async {
    result.value = 'Mengambil data via Dio...';
    try {
      final data = await DioService.getProductsByCategory('electronics');
      result.value = 'Dio Sukses: ${data.length} produk ditemukan.';
    } catch (e) {
      result.value = 'Dio Error: $e';
    }
  }

  Future<void> testAsyncHandling() async {
    recommendation.value = 'Memuat rekomendasi (async-await)...';
    final rec = await WeatherService.getRecommendationAsync();
    recommendation.value = 'Rekomendasi (async-await): $rec';
  }

  Future<void> testCallbackHandling() async {
    recommendation.value = 'Memuat rekomendasi (callback)...';
    WeatherService.getRecommendationCallback((rec) {
      recommendation.value = 'Rekomendasi (callback): $rec';
    });
  }
}
