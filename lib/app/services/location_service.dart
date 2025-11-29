import 'package:geolocator/geolocator.dart';

class LocationService {
  // Cek izin dan service lokasi
  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Mendapatkan Lokasi Akurasi Tinggi (GPS simulation)
  Future<Position?> getGPSLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best, // High precision
    );
  }

  // Mendapatkan Lokasi Akurasi Rendah (Network simulation)
  Future<Position?> getNetworkLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low, // Coarse precision (Cell tower/Wifi)
    );
  }

  // Stream untuk Live Location
  Stream<Position> getLiveLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5, // Update setiap bergerak 5 meter
      ),
    );
  }
}