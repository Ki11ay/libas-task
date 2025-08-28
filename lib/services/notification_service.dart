import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification_model.dart';
import 'cloud_functions_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService();

  Future<void> initialize() async {
    try {
      // Request permission for iOS
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Initialize local notifications
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(initSettings);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
      
      // Handle when app is opened from notification
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // For iOS, wait a bit for APNS token to be available
      if (Platform.isIOS) {
        await Future.delayed(const Duration(seconds: 2));
      }
    } catch (e) {
      print('Error initializing notification service: $e');
    }
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message received: ${message.notification?.title}');
    
    // Create notification model
    final notification = NotificationModel(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'New Message',
      body: message.notification?.body ?? '',
      payload: message.data['payload'],
      timestamp: DateTime.now(),
      type: _getNotificationTypeFromString(message.data['type']),
      data: message.data,
    );
    
    // Show local notification
    _showLocalNotification(
      title: notification.title,
      body: notification.body,
      payload: notification.payload,
    );
  }

  // Handle background messages
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Background message received: ${message.notification?.title}');
    // Handle background message logic here
    // You can save to local storage or Firestore
  }

  // Handle when app is opened from notification
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('App opened from notification: ${message.notification?.title}');
    // Navigate to specific screen based on message data
    _handleNotificationTap(message.data);
  }

  // Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Send welcome notification using cloud functions
  Future<void> sendWelcomeNotification(String userId, String userName) async {
    try {
      await _cloudFunctions.sendWelcomeNotification(
        userId: userId,
        userName: userName,
      );
    } catch (e) {
      print('Error sending welcome notification: $e');
      // Fallback to local notification
      await _showLocalNotification(
        title: 'Welcome to Libas! 🎉',
        body: 'Hi $userName! We\'re excited to have you on board. Start exploring our amazing products!',
        payload: 'welcome',
      );
    }
  }

  // Send welcome back notification using cloud functions
  Future<void> sendWelcomeBackNotification(String userId, String userName) async {
    try {
      await _cloudFunctions.sendWelcomeBackNotification(
        userId: userId,
        userName: userName,
      );
    } catch (e) {
      print('Error sending welcome back notification: $e');
      // Fallback to local notification
      await _showLocalNotification(
        title: 'Welcome back! 👋',
        body: 'Hi $userName! We missed you. Check out our latest arrivals and exclusive offers!',
        payload: 'welcome_back',
      );
    }
  }

  // Send discount notification using cloud functions
  Future<void> sendDiscountNotification(String userId, String discountCode, double discountPercent) async {
    try {
      await _cloudFunctions.sendDiscountNotification(
        userId: userId,
        discountCode: discountCode,
        discountPercent: discountPercent,
      );
    } catch (e) {
      print('Error sending discount notification: $e');
      // Fallback to local notification
      await _showLocalNotification(
        title: 'Special Offer! 💰',
        body: 'Get $discountPercent% off with code $discountCode. Limited time only!',
        payload: 'discount',
      );
    }
  }

  // Send purchase completion notification using cloud functions
  Future<void> sendPurchaseCompletionNotification(String userId, String orderId, double totalAmount) async {
    try {
      await _cloudFunctions.sendPurchaseCompletionNotification(
        userId: userId,
        orderId: orderId,
        totalAmount: totalAmount,
      );
    } catch (e) {
      print('Error sending purchase completion notification: $e');
      // Fallback to local notification
      await _showLocalNotification(
        title: 'Order Confirmed! ✅',
        body: 'Your order #$orderId has been confirmed. Total: \$${totalAmount.toStringAsFixed(2)}',
        payload: 'purchase_complete',
      );
    }
  }

  // Send shipping update notification using cloud functions
  Future<void> sendShippingUpdateNotification(String userId, String orderId, String status) async {
    try {
      await _cloudFunctions.sendShippingUpdateNotification(
        userId: userId,
        orderId: orderId,
        status: status,
      );
    } catch (e) {
      print('Error sending shipping update notification: $e');
      // Fallback to local notification
      await _showLocalNotification(
        title: 'Shipping Update 📦',
        body: 'Order #$orderId: $status',
        payload: 'shipping_update',
      );
    }
  }

  // Helper method to convert string to NotificationType
  NotificationType _getNotificationTypeFromString(String? typeString) {
    switch (typeString) {
      case 'welcome':
        return NotificationType.welcome;
      case 'welcome_back':
        return NotificationType.welcomeBack;
      case 'discount':
        return NotificationType.discount;
      case 'purchase_complete':
        return NotificationType.purchaseComplete;
      case 'shipping_update':
        return NotificationType.shippingUpdate;
      case 'promotional':
        return NotificationType.promotional;
      default:
        return NotificationType.general;
    }
  }

  // Handle notification tap based on payload
  void _handleNotificationTap(Map<String, dynamic> data) {
    final payload = data['payload'];
    final action = data['action'];
    
    // You can implement navigation logic here based on the payload or action
    print('Notification tapped with payload: $payload, action: $action');
  }
}
