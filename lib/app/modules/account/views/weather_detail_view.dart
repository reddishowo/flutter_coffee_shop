import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/account_controller.dart';
import '../../../theme/app_theme.dart';

class WeatherDetailView extends GetView<AccountController> {
  const WeatherDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita gunakan data yang sudah ada di AccountController
    // Controller sudah di-put di halaman sebelumnya (AccountView), jadi aman pakai Get.find/GetView

    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(
        title: const Text("Weather Details"),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isWeatherLoading.value) return const Center(child: CircularProgressIndicator());
        
        final isHot = controller.temp > 25;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 1. Lokasi & Tanggal
              Text(
                controller.locationName.value,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Serif'),
              ),
              Text(
                DateTime.now().toString().substring(0, 10),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // 2. Icon Besar & Suhu
              Icon(
                _getWeatherIcon(controller.weatherCode),
                size: 100,
                color: AppTheme.brownDark,
              ),
              const SizedBox(height: 10),
              Text(
                "${controller.temp.toStringAsFixed(1)}°",
                style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: AppTheme.brownDark),
              ),
              Text(
                _getWeatherDesc(controller.weatherCode),
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // 3. Grid Detail (Humidity, Wind, Pressure)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoItem(Icons.water_drop, "${controller.humidity}%", "Humidity"),
                    _buildInfoItem(Icons.air, "${controller.wind} km/h", "Wind Speed"),
                    _buildInfoItem(Icons.thermostat, isHot ? "Hot" : "Cool", "Feels Like"),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 4. Coffee Recommendation
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.brownDark, AppTheme.brownCard]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Coffee Recommendation",
                      style: TextStyle(color: AppTheme.beigeAccent, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isHot 
                        ? "Cuaca panas! Saatnya menyegarkan diri dengan Iced Americano atau Cold Brew. 🧊"
                        : "Cuaca sejuk. Nikmati kehangatan Hot Cappuccino atau Latte. ☕",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.brownDark),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // Helper untuk Icon berdasarkan WMO Code
  IconData _getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code >= 1 && code <= 3) return Icons.cloud;
    if (code >= 45 && code <= 48) return Icons.foggy;
    if (code >= 51 && code <= 67) return Icons.grain; // Gerimis/Hujan Ringan
    if (code >= 80 && code <= 99) return Icons.thunderstorm; // Hujan Deras
    return Icons.wb_cloudy;
  }

  // Helper untuk Deskripsi
  String _getWeatherDesc(int code) {
    if (code == 0) return "Cerah";
    if (code >= 1 && code <= 3) return "Berawan";
    if (code >= 45 && code <= 48) return "Berkabut";
    if (code >= 51 && code <= 67) return "Hujan";
    if (code >= 80 && code <= 99) return "Badai Petir";
    return "Mendung";
  }
}