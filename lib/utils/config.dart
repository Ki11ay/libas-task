class AppConfig {
  // Google Maps API Configuration
  static const String googleMapsApiKey = 'AIzaSyB7FY7ZviJ0zorphBr5k4q5tmsH8OGBzqY';
  
  // Firebase Configuration (these should be in firebase_options.dart)
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
  
  // App Configuration
  static const String appName = 'Libas';
  static const String appVersion = '1.0.0';
  
  // Feature Flags
  static const bool enableLocationServices = true;
  static const bool enablePushNotifications = true;
  static const bool enableGoogleSignIn = true;
  
  // API Endpoints
  static const String baseUrl = 'https://your-api-domain.com';
  
  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration locationTimeout = Duration(seconds: 15);
  
  // Cache Settings
  static const Duration imageCacheDuration = Duration(days: 7);
  static const Duration dataCacheDuration = Duration(hours: 1);
  
  // Validation
  static bool get isGoogleMapsConfigured => googleMapsApiKey.isNotEmpty && 
                                           googleMapsApiKey != 'YOUR_GOOGLE_MAPS_API_KEY' &&
                                           googleMapsApiKey.length > 20;
  
  static void validateConfiguration() {
    if (!isGoogleMapsConfigured) {
      //print('⚠️  Warning: Google Maps API key not configured!');
      //print('   Please update the googleMapsApiKey in lib/utils/config.dart');
      //print('   Location services will not work properly without this key.');
    }
  }
}
