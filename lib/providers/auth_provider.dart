import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  UserModel? _userProfile;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _firebaseService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserProfile();
        _captureFCMToken();
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  Future<void> _captureFCMToken() async {
    try {
      final messaging = FirebaseMessaging.instance;
      
      // Request permission
      final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get FCM token
        final token = await messaging.getToken();
        if (token != null && _user != null) {
          // Save token to user profile
          await _firebaseService.updateUserProfile(_user!.uid, {
            'fcmToken': token,
            'lastLoginAt': DateTime.now().toIso8601String(),
          });
          
          // Send welcome back notification
          _sendWelcomeBackNotification();
        }
      }
    } catch (e) {
      print('Error capturing FCM token: $e');
    }
  }

  Future<void> _sendWelcomeBackNotification() async {
    try {
      // This would typically be sent from your backend
      // For now, we'll just log it
      print('Welcome back notification should be sent to user: ${_user?.email}');
    } catch (e) {
      print('Error sending welcome back notification: $e');
    }
  }

  Future<void> _loadUserProfile() async {
    if (_user != null) {
      try {
        _userProfile = await _firebaseService.getUserProfile(_user!.uid);
        notifyListeners();
      } catch (e) {
        _error = e.toString();
        notifyListeners();
      }
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _firebaseService.signInWithEmailAndPassword(email, password);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password, String displayName) async {
    try {
      _setLoading(true);
      _clearError();
      
      final userCredential = await _firebaseService.createUserWithEmailAndPassword(email, password);
      
      if (userCredential.user != null) {
        // Capture FCM token for new user
        String? fcmToken;
        try {
          final messaging = FirebaseMessaging.instance;
          final settings = await messaging.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

          if (settings.authorizationStatus == AuthorizationStatus.authorized) {
            fcmToken = await messaging.getToken();
          }
        } catch (e) {
          print('Error getting FCM token during signup: $e');
        }

        // Create user profile
        final userModel = UserModel(
          id: userCredential.user!.uid,
          email: email,
          displayName: displayName,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isEmailVerified: false,
        );
        
        await _firebaseService.createUserProfile(userModel);
        
        // Save FCM token if available
        if (fcmToken != null) {
          await _firebaseService.updateUserProfile(userCredential.user!.uid, {
            'fcmToken': fcmToken,
            'lastLoginAt': DateTime.now().toIso8601String(),
          });
        }
        
        // Send welcome notification
        _sendWelcomeNotification(email, displayName);
        
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _sendWelcomeNotification(String email, String displayName) async {
    try {
      // This would typically be sent from your backend
      // For now, we'll just log it
      print('Welcome notification should be sent to new user: $email ($displayName)');
    } catch (e) {
      print('Error sending welcome notification: $e');
    }
  }

  // Method to send discount notifications (can be called from other parts of the app)
  Future<void> sendDiscountNotification(String userId, String discountCode, double discountPercent) async {
    try {
      if (_userProfile != null && _userProfile!.fcmToken != null) {
        // This would typically be sent from your backend
        print('Discount notification should be sent to user: ${_userProfile!.email}');
        print('Discount: $discountPercent% off with code: $discountCode');
      }
    } catch (e) {
      print('Error sending discount notification: $e');
    }
  }

  // Method to send purchase completion notification
  Future<void> sendPurchaseCompletionNotification(String userId, String orderId, double totalAmount) async {
    try {
      if (_userProfile != null && _userProfile!.fcmToken != null) {
        // This would typically be sent from your backend
        print('Purchase completion notification should be sent to user: ${_userProfile!.email}');
        print('Order: $orderId completed with total: \$${totalAmount.toStringAsFixed(2)}');
      }
    } catch (e) {
      print('Error sending purchase completion notification: $e');
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        // Check if user profile exists, if not create one
        var profile = await _firebaseService.getUserProfile(userCredential.user!.uid);
        if (profile == null) {
          profile = UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            displayName: userCredential.user!.displayName,
            photoURL: userCredential.user!.photoURL,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isEmailVerified: userCredential.user!.emailVerified,
          );
          await _firebaseService.createUserProfile(profile);
        }
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _googleSignIn.signOut();
      await _firebaseService.signOut();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _firebaseService.resetPassword(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      _clearError();
      
      if (_user != null) {
        await _firebaseService.updateUserProfile(_user!.uid, data);
        await _loadUserProfile();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
