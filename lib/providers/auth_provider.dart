import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';
import '../services/notification_service.dart';

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
        // For iOS, wait a bit for APNS token to be available
        if (Platform.isIOS) {
          await Future.delayed(const Duration(seconds: 3));
        }
        
        // Get FCM token
        final token = await messaging.getToken();
        if (token != null && _user != null) {
          // Save token to user profile
          await _firebaseService.updateUserProfile(_user!.uid, {
            'fcmToken': token,
            'lastLoginAt': DateTime.now().toIso8601String(),
          });
          
          // Send welcome back notification
          sendWelcomeBackNotification();
        }
      }
    } catch (e) {
      print('Error capturing FCM token: $e');
      // Don't fail the entire auth process if FCM token capture fails
    }
  }

  Future<void> sendWelcomeBackNotification() async {
    try {
      if (_userProfile?.displayName != null) {
        await NotificationService().sendWelcomeBackNotification(_userProfile!.displayName!);
      }
    } catch (e) {
      print('Error sending welcome back notification: $e');
    }
  }

  Future<void> _loadUserProfile() async {
    if (_user != null) {
      try {
        print('Loading user profile for: ${_user!.uid}');
        _userProfile = await _firebaseService.getUserProfile(_user!.uid);
        
        // If profile doesn't exist, create a default one
        if (_userProfile == null) {
          print('User profile not found, creating default profile');
          _userProfile = UserModel(
            id: _user!.uid,
            email: _user!.email ?? '',
            displayName: _user!.displayName ?? 'User',
            photoURL: _user!.photoURL,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isEmailVerified: _user!.emailVerified,
          );
          
          await _firebaseService.createUserProfile(_userProfile!);
          print('Default user profile created');
        } else {
          print('User profile loaded: ${_userProfile?.displayName}');
        }
        
        notifyListeners();
      } catch (e) {
        print('Error loading user profile: $e');
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
      
      // Load user profile after successful sign in
      if (_user != null) {
        await _loadUserProfile();
      }
      
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
            // For iOS, wait a bit for APNS token to be available
            if (Platform.isIOS) {
              await Future.delayed(const Duration(seconds: 3));
            }
            fcmToken = await messaging.getToken();
          }
        } catch (e) {
          print('Error getting FCM token during signup: $e');
          // Don't fail the entire signup process if FCM token capture fails
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
        sendWelcomeNotification(email, displayName);
        
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

  Future<void> sendWelcomeNotification(String email, String displayName) async {
    try {
      await NotificationService().sendWelcomeNotification(displayName);
    } catch (e) {
      print('Error sending welcome notification: $e');
    }
  }

  // Method to send discount notifications (can be called from other parts of the app)
  Future<void> sendDiscountNotification(String userId, String discountCode, double discountPercent) async {
    try {
      await NotificationService().sendDiscountNotification(discountCode, discountPercent);
    } catch (e) {
      print('Error sending discount notification: $e');
    }
  }

  // Method to send periodic discount notifications (can be called from a timer or background task)
  Future<void> sendPeriodicDiscountNotification() async {
    try {
      if (_userProfile != null) {
        // Generate a random discount code
        final discountCode = 'SAVE${DateTime.now().millisecondsSinceEpoch % 1000}';
        final discountPercent = 15.0 + (DateTime.now().millisecondsSinceEpoch % 20); // 15-35% off
        
        // Send local notification
        await NotificationService().sendDiscountNotification(discountCode, discountPercent);
        
        // Save to Firestore for tracking
        await _firebaseService.updateUserProfile(_user!.uid, {
          'lastDiscountNotification': DateTime.now().toIso8601String(),
          'lastDiscountCode': discountCode,
        });
      }
    } catch (e) {
      print('Error sending periodic discount notification: $e');
    }
  }

  // Method to send purchase completion notification
  Future<void> sendPurchaseCompletionNotification(String userId, String orderId, double totalAmount) async {
    try {
      await NotificationService().sendPurchaseCompletionNotification(orderId, totalAmount);
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
