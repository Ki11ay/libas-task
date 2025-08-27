import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/config.dart';
import '../services/firebase_service.dart';

class LocationService {
  // Get API key from configuration
  static String get _googleMapsApiKey => AppConfig.googleMapsApiKey;
  
  /// Request location permissions
  static Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return permission == LocationPermission.whileInUse || 
           permission == LocationPermission.always;
  }
  
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
      // Check if API key is configured
      if (!AppConfig.isGoogleMapsConfigured) {
        print('Warning: Google Maps API key not configured. Please update the API key in config.dart');
        return null;
      }

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
        } else if (data['status'] == 'REQUEST_DENIED') {
          print('Error: Google Maps API request denied. Check your API key and billing.');
          return null;
        } else if (data['status'] == 'OVER_QUERY_LIMIT') {
          print('Error: Google Maps API quota exceeded.');
          return null;
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
      
      // Return coordinates even if address lookup fails
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'timestamp': position.timestamp?.toIso8601String(),
      };
    } catch (e) {
      print('Error getting location data: $e');
      return null;
    }
  }

  /// Capture and save user location to Firebase
  static Future<bool> captureAndSaveUserLocation(String userId) async {
    try {
      print('📍 Starting location capture for user: $userId');
      
      // Request permission first
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        print('❌ Location permission denied');
        return false;
      }
      
      // Get location data
      final locationData = await getLocationData();
      if (locationData == null) {
        print('❌ Failed to get location data');
        return false;
      }
      
      print('📍 Location captured: ${locationData['latitude']}, ${locationData['longitude']}');
      
      // Update user profile in Firebase
      final firebaseService = FirebaseService();
      await firebaseService.updateUserProfile(userId, {
        'latitude': locationData['latitude'],
        'longitude': locationData['longitude'],
        'accuracy': locationData['accuracy'],
        'city': locationData['city'],
        'state': locationData['state'],
        'zipCode': locationData['zipCode'],
        'country': locationData['country'],
        'streetName': locationData['streetName'],
        'streetNumber': locationData['streetNumber'],
        'formattedAddress': locationData['formattedAddress'],
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      print('✅ Location data saved to Firebase successfully');
      return true;
      
    } catch (e) {
      print('❌ Error capturing and saving location: $e');
      return false;
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
