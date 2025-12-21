import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../services/weather_service.dart';
import '../../../services/location_service.dart';

class AccountController extends GetxController {
  final LocationService _locationService = LocationService();

  // Observables
  var weatherData = <String, dynamic>{}.obs; // Simpan semua data disini
  var isWeatherLoading = false.obs;
  var isWeatherError = false.obs;
  var locationName = "Loading...".obs;

  // Getter helper
  double get temp => weatherData['temp'] ?? 0.0;
  int get humidity => weatherData['humidity'] ?? 0;
  double get wind => weatherData['wind'] ?? 0.0;
  int get weatherCode => weatherData['code'] ?? 0;

  @override
  void onInit() {
    super.onInit();
    fetchWeather();
  }

  void fetchWeather() async {
    isWeatherLoading.value = true;
    isWeatherError.value = false;
    locationName.value = "Detecting Location...";
    
    try {
      Position? position = await _locationService.getGPSLocation();
      position ??= await _locationService.getNetworkLocation();

      if (position != null) {
        // Ambil Data Lengkap
        final data = await WeatherService.getWeatherDetails(position.latitude, position.longitude);
        weatherData.value = data;

        // Logic Nama Lokasi
        if ((position.latitude - -7.98).abs() > 0.1) {
           locationName.value = "Current Location";
        } else {
           locationName.value = "Malang, Indonesia";
        }
      } else {
        isWeatherError.value = true;
        locationName.value = "Unknown Location";
      }
    } catch (e) {
      isWeatherError.value = true;
      print("Weather Error: $e");
    } finally {
      isWeatherLoading.value = false;
    }
  }
}