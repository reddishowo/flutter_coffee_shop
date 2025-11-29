import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import '../controllers/location_controller.dart';
import '../../../theme/app_theme.dart';

class LocationView extends GetView<LocationController> {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eksperimen Lokasi')),
      body: Column(
        children: [
          // Panel Kontrol Atas (Data & Tombol)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Display Data
                Obx(() {
                  final pos = controller.currentPosition.value;
                  return Card(
                    color: AppTheme.creamBackground,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(controller.statusMessage.value, 
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.brownDark)),
                          const Divider(),
                          if (pos != null) ...[
                            _rowDetail("Latitude", "${pos.latitude}"),
                            _rowDetail("Longitude", "${pos.longitude}"),
                            _rowDetail("Accuracy", "${pos.accuracy.toStringAsFixed(2)} m"),
                            _rowDetail("Altitude", "${pos.altitude.toStringAsFixed(2)} m"),
                            _rowDetail("Speed", "${pos.speed.toStringAsFixed(2)} m/s"),
                            _rowDetail("Time", DateFormat('HH:mm:ss').format(DateTime.now())),
                          ] else
                            const Text("Belum ada data lokasi."),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                // Tombol Eksperimen
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: controller.isLoading.value ? null : controller.fetchNetworkLocation,
                        icon: const Icon(Icons.wifi, size: 18),
                        label: const Text("Network"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: controller.isLoading.value ? null : controller.fetchGPSLocation,
                        icon: const Icon(Icons.gps_fixed, size: 18),
                        label: const Text("GPS"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: controller.startLiveTracking,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green[100]),
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: const Text("Start Live"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: controller.stopLiveTracking,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
                        icon: const Icon(Icons.stop, size: 18),
                        label: const Text("Stop"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Bagian Peta (OpenStreetMap via flutter_map)
          Expanded(
            child: Obx(
              () => FlutterMap(
                mapController: controller.mapController,
                options: MapOptions(
                  initialCenter: controller.mapCenter.value, // Menggunakan initialCenter di v6
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.coffeeshop', // Ganti dengan package name Anda
                  ),
                  // Marker posisi saat ini
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: controller.mapCenter.value,
                        width: 80,
                        height: 80,
                        child: const Icon(
                          Icons.location_history,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                  // Garis Jejak (Polyline) untuk Live Tracking
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: controller.routePoints.toList(),
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}