import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../services/location_service.dart';

class LocationController extends GetxController {
  final LocationService _service = LocationService();
  final MapController mapController = MapController();
  
  var currentPosition = Rxn<Position>();

  @override
  void onInit() {
    super.onInit();
    // Auto-fetch location when page opens
    _getCurrentLocation(); 
  }

  void _getCurrentLocation() async {
    // Try to get GPS location for user context
    final pos = await _service.getGPSLocation();
    if (pos != null) {
      currentPosition.value = pos;
    }
  }
}