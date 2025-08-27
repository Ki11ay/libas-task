// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Libas';

  @override
  String get appTagline => 'Discover Your Style';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get products => 'Products';

  @override
  String get cart => 'Cart';

  @override
  String get profile => 'Profile';

  @override
  String get orders => 'Orders';

  @override
  String get favorites => 'Favorites';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String get inStock => 'In Stock';

  @override
  String get freeShipping => 'Free Shipping';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartEmptySubtitle => 'Add some products to get started';

  @override
  String get checkout => 'Checkout';

  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get shipping => 'Shipping';

  @override
  String get tax => 'Tax';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get shippingAddress => 'Shipping Address';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacy => 'Privacy';

  @override
  String get help => 'Help & Support';

  @override
  String get about => 'About';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get done => 'Done';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get retry => 'Retry';

  @override
  String get quantity => 'Quantity';

  @override
  String get description => 'Description';

  @override
  String get category => 'Category';

  @override
  String get rating => 'Rating';

  @override
  String get tags => 'Tags';

  @override
  String get stockStatus => 'Stock Status';

  @override
  String get available => 'Available';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get locationPermissionRequired => 'Location permission is required to provide better service';

  @override
  String get locationServicesDisabled => 'Location services are disabled';

  @override
  String get gettingLocation => 'Getting your location...';

  @override
  String locationCaptured(Object latitude, Object longitude) {
    return 'Location captured: $latitude, $longitude';
  }

  @override
  String get locationError => 'Error getting location';

  @override
  String get searchProducts => 'Search products...';

  @override
  String get allCategories => 'All Categories';

  @override
  String get sortBy => 'Sort By';

  @override
  String get newest => 'Newest';

  @override
  String get priceLowToHigh => 'Price: Low to High';

  @override
  String get priceHighToLow => 'Price: High to Low';

  @override
  String get highestRated => 'Highest Rated';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get tryAdjustingFilters => 'Try adjusting your search or filters';

  @override
  String get errorLoadingProducts => 'Error loading products';

  @override
  String get retryLoading => 'Retry';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get welcome => 'Welcome to Libas';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get locationUpdated => 'Location updated successfully';

  @override
  String get language => 'Language';

  @override
  String get languageSelection => 'Please select your preferred language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get updateLocation => 'Update Location';

  @override
  String get refreshLocation => 'Refresh your current location';

  @override
  String get updatingLocation => 'Updating location...';

  @override
  String get locationUpdateSuccess => 'Location updated successfully!';

  @override
  String get locationUpdateFailed => 'Failed to update location. Please check permissions.';

  @override
  String locationUpdateError(Object error) {
    return 'Failed to update location: $error';
  }

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get locationCaptureFailed => 'Failed to get location data';

  @override
  String get locationDataSaved => 'Location data saved to Firebase successfully';

  @override
  String locationCaptureError(Object error) {
    return 'Error capturing and saving location: $error';
  }

  @override
  String refreshingLocation(Object userId) {
    return 'Refreshing location for existing user: $userId';
  }

  @override
  String refreshingLocationError(Object error) {
    return 'Error refreshing user location: $error';
  }

  @override
  String checkingLocationData(Object error) {
    return 'Error checking location data: $error';
  }

  @override
  String startingLocationCapture(Object userId) {
    return 'Starting location capture for user: $userId';
  }

  @override
  String updatingUserProfile(Object data) {
    return 'Updating user profile with data: $data';
  }

  @override
  String get userProfileUpdateSuccess => 'User profile updated successfully';

  @override
  String userProfileUpdateError(Object error) {
    return 'Failed to update user profile: $error';
  }

  @override
  String get signOutConfirmation => 'Are you sure you want to sign out?';

  @override
  String languageChanged(Object language) {
    return 'Language changed to $language';
  }

  @override
  String get pleaseSignInToViewProfile => 'Please sign in to view your profile';

  @override
  String get user => 'User';

  @override
  String get viewOrderHistory => 'View your order history';

  @override
  String get savedProducts => 'Your saved products';

  @override
  String get manageDeliveryAddresses => 'Manage delivery addresses';

  @override
  String get savedPaymentMethods => 'Saved payment methods';

  @override
  String get manageNotificationPreferences => 'Manage notification preferences';

  @override
  String get privacyAndSecuritySettings => 'Privacy and security settings';

  @override
  String get getHelpAndSupport => 'Get help and support';

  @override
  String get appInformationAndVersion => 'App information and version';
}
