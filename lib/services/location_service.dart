import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static const String _googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with your actual API key
  
  /// Get current location with permission handling
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can get the location
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
    );
  }

  /// Get address from coordinates using Google Maps Geocoding API
  static Future<Map<String, String>?> getAddressFromCoordinates(
    double latitude, 
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?'
        'latlng=$latitude,$longitude'
        '&key=$_googleMapsApiKey'
      );

      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final result = data['results'][0];
          final addressComponents = result['address_components'];
          
          Map<String, String> addressData = {};
          
          for (var component in addressComponents) {
            final types = component['types'] as List;
            final value = component['long_name'] as String;
            
            if (types.contains('street_number')) {
              addressData['streetNumber'] = value;
            } else if (types.contains('route')) {
              addressData['streetName'] = value;
            } else if (types.contains('locality')) {
              addressData['city'] = value;
            } else if (types.contains('administrative_area_level_1')) {
              addressData['state'] = value;
            } else if (types.contains('postal_code')) {
              addressData['zipCode'] = value;
            } else if (types.contains('country')) {
              addressData['country'] = value;
            }
          }
          
          // Add formatted address
          addressData['formattedAddress'] = result['formatted_address'];
          
          return addressData;
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting address from coordinates: $e');
      return null;
    }
  }

  /// Get location data including coordinates and address
  static Future<Map<String, dynamic>?> getLocationData() async {
    try {
      final position = await getCurrentLocation();
      if (position == null) return null;
      
      final addressData = await getAddressFromCoordinates(
        position.latitude, 
        position.longitude,
      );
      
      if (addressData != null) {
        return {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
          'timestamp': position.timestamp?.toIso8601String(),
          ...addressData,
        };
      }
      
      return null;
    } catch (e) {
      print('Error getting location data: $e');
      return null;
    }
  }

  /// Calculate distance between two points
  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Get last known position (cached)
  static Future<Position?> getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      print('Error getting last known position: $e');
      return null;
    }
  }
}
