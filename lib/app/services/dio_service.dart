import 'package:dio/dio.dart';

class DioService {
  static const String baseUrl = 'https://fakestoreapi.com/products/category';

  static final Dio _dio = Dio(BaseOptions(connectTimeout: Duration(seconds: 5)))
    ..interceptors.add(LogInterceptor(
      request: true,
      requestHeader: false,
      responseBody: true,
      error: true,
      logPrint: (obj) => print('Dio Log: $obj'),
    ));

  static Future<List<dynamic>> getProductsByCategory(String category) async {
    final stopwatch = Stopwatch()..start();

    try {
      final response = await _dio.get('$baseUrl/$category');
      stopwatch.stop();
      print('Dio Fetch time: ${stopwatch.elapsedMilliseconds} ms');

      return response.data;
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      rethrow;
    }
  }
}
