import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable the services');
    }
    
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
    
    return true;
  }

  Future<Position> getCurrentPosition() async {
    await _handleLocationPermission();
    
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> getCurrentCity() async {
    try {
      final position = await getCurrentPosition();
      
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return place.locality ?? place.subAdministrativeArea ?? 'Unknown';
      }
      
      return 'Unknown';
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      final position = await getCurrentPosition();
      
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'city': place.locality ?? place.subAdministrativeArea ?? 'Unknown',
          'country': place.country ?? 'Unknown',
          'address': '${place.street}, ${place.locality}, ${place.country}',
        };
      }
      
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'city': 'Unknown',
        'country': 'Unknown',
        'address': 'Unknown',
      };
    } catch (e) {
      rethrow;
    }
  }
}