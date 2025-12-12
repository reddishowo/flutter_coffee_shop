import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../services/weather_service.dart';
import '../../../services/location_service.dart'; // Ensure LocationService is created

class AccountController extends GetxController {
  final LocationService _locationService = LocationService();

  // Observables
  var weatherTemp = 0.0.obs;
  var isWeatherLoading = false.obs;
  var isWeatherError = false.obs;
  var locationName = "Loading...".obs; // Dynamic Name

  @override
  void onInit() {
    super.onInit();
    fetchWeather(); // Fetch automatically on start
  }

  void fetchWeather() async {
    isWeatherLoading.value = true;
    isWeatherError.value = false;
    locationName.value = "Detecting Location...";
    
    try {
      // 1. Get GPS Location
      Position? position = await _locationService.getGPSLocation();
      // Fallback to Network if GPS fails
      position ??= await _locationService.getNetworkLocation();

      if (position != null) {
        // 2. Fetch Weather for Real Coordinates
        final temp = await WeatherService.getTemperature(position.latitude, position.longitude);
        weatherTemp.value = temp;

        // 3. Logic to update location name
        // If coordinate is far from Malang (-7.98), show "Current Location"
        if ((position.latitude - -7.98).abs() > 0.1) {
           locationName.value = "Current Location";
        } else {
           locationName.value = "Malang, Indonesia";
        }
      } else {
        // Location permission denied or service off
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