import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart'; // Tambahkan ini
import '../../../services/location_service.dart';

class LocationController extends GetxController {
  final LocationService _service = LocationService();
  
  // Data Observables
  var currentPosition = Rxn<Position>();
  var address = ''.obs;
  var isLoading = false.obs;
  var statusMessage = 'Siap mengambil data'.obs;

  // Untuk Peta
  var mapCenter = const LatLng(-7.98, 112.63).obs; // Default Malang
  final MapController mapController = MapController();
  var routePoints = <LatLng>[].obs; // Jejak pergerakan

  // Stream Subscription
  StreamSubscription<Position>? _positionStream;

  // --- Fungsi Eksperimen 1 & 2 (Statis) ---

  Future<void> fetchGPSLocation() async {
    isLoading.value = true;
    statusMessage.value = "Mengambil data GPS...";
    
    final position = await _service.getGPSLocation();
    _updateUI(position, "Mode GPS (High Accuracy)");
    
    isLoading.value = false;
  }

  Future<void> fetchNetworkLocation() async {
    isLoading.value = true;
    statusMessage.value = "Mengambil data Network...";
    
    final position = await _service.getNetworkLocation();
    _updateUI(position, "Mode Network (Low Accuracy)");
    
    isLoading.value = false;
  }

  void _updateUI(Position? position, String source) {
    if (position != null) {
      currentPosition.value = position;
      mapCenter.value = LatLng(position.latitude, position.longitude);
      // Pindahkan kamera peta
      mapController.move(mapCenter.value, 16.0); 
      statusMessage.value = "Sukses: $source";
    } else {
      statusMessage.value = "Gagal mengambil lokasi atau izin ditolak.";
    }
  }

  // --- Fungsi Eksperimen 3 (Dinamis / Live) ---

  void startLiveTracking() {
    stopLiveTracking(); // Reset jika ada yang berjalan
    statusMessage.value = "Live Tracking Aktif...";
    routePoints.clear();

    _positionStream = _service.getLiveLocationStream().listen((Position position) {
      currentPosition.value = position;
      final newPoint = LatLng(position.latitude, position.longitude);
      
      mapCenter.value = newPoint;
      routePoints.add(newPoint);
      
      // Auto follow map
      mapController.move(newPoint, 17.0);
    });
  }

  void stopLiveTracking() {
    _positionStream?.cancel();
    _positionStream = null;
    statusMessage.value = "Tracking Dihentikan.";
  }

  @override
  void onClose() {
    _positionStream?.cancel();
    super.onClose();
  }
}