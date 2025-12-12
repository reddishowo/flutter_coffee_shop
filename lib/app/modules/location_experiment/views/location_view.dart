import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart'; // Add url_launcher to pubspec.yaml if needed
import '../controllers/location_controller.dart';
import '../../../theme/app_theme.dart';

class LocationView extends GetView<LocationController> {
  const LocationView({super.key});

  // Your Coffee Shop Coordinates
  final LatLng shopLocation = const LatLng(-7.97918829279658, 112.61148768673092);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Make map go behind app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.brownDark),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      body: Stack(
        children: [
          // 1. The Map
          Obx(() => FlutterMap(
            mapController: controller.mapController,
            options: MapOptions(
              initialCenter: shopLocation, // Center on your shop
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.coffeeshop.app',
              ),
              // Marker Layer
              MarkerLayer(
                markers: [
                  // SHOP MARKER
                  Marker(
                    point: shopLocation,
                    width: 100,
                    height: 100,
                    child: Column(
                      children: const [
                        Icon(Icons.location_on, color: AppTheme.brownDark, size: 50),
                        Text("We are here!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                  // USER MARKER (If available)
                  if (controller.currentPosition.value != null)
                    Marker(
                      point: LatLng(
                        controller.currentPosition.value!.latitude,
                        controller.currentPosition.value!.longitude
                      ),
                      width: 60,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2)
                        ),
                        child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
                      ),
                    ),
                ],
              ),
            ],
          )),

          // 2. Bottom Info Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black12)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Coffee Shop Malang",
                    style: TextStyle(fontFamily: 'Serif', fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.brownDark),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.map, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(child: Text("Jl. Besar Ijen No. 99, Malang, Jawa Timur", style: TextStyle(color: Colors.black54))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Text("Open Daily: 08:00 - 22:00", style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                         // Open external Google Maps
                         _launchMaps();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brownDark,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      icon: const Icon(Icons.directions, color: Colors.white),
                      label: const Text("Get Directions", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchMaps() async {
    final googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=${shopLocation.latitude},${shopLocation.longitude}");
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      Get.snackbar("Error", "Could not open maps");
    }
  }
}