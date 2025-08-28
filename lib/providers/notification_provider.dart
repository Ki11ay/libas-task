import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;
  bool _permissionGranted = false;
  String? _fcmToken;
  
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get permissionGranted => _permissionGranted;
  String? get fcmToken => _fcmToken;
  
  NotificationProvider() {
    _initialize();
  }
  
  Future<void> _initialize() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Initialize notification service
      await _notificationService.initialize();
      
      // Get FCM token
      _fcmToken = await _notificationService.getToken();
      
      // Check permission status - Firebase Messaging 15.x doesn't have getPermissionStatus
      // We'll check this when requesting permission
      _permissionGranted = false;
      
      // Listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        _fcmToken = token;
        notifyListeners();
      });
      
      // Load existing notifications
      await _loadNotifications();
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> _loadNotifications() async {
    // Load notifications from local storage or Firestore
    // This is a placeholder - implement based on your storage strategy
    _notifications = [];
    notifyListeners();
  }
  
  Future<void> requestPermission() async {
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
      
      _permissionGranted = settings.authorizationStatus == AuthorizationStatus.authorized;
      
      if (_permissionGranted) {
        _fcmToken = await _notificationService.getToken();
      }
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _notificationService.subscribeToTopic(topic);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _notificationService.unsubscribeFromTopic(topic);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
  
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
  
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }
  
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }
  
  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
