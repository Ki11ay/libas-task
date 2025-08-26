import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

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
    
    // Show local notification
    _showLocalNotification(
      title: message.notification?.title ?? 'New Message',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  // Handle background messages
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Background message received: ${message.notification?.title}');
    // Handle background message logic here
  }

  // Handle when app is opened from notification
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('App opened from notification: ${message.notification?.title}');
    // Navigate to specific screen based on message data
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

  // Send welcome notification
  Future<void> sendWelcomeNotification(String userName) async {
    await _showLocalNotification(
      title: 'Welcome to Libas! 🎉',
      body: 'Hi $userName! We\'re excited to have you on board. Start exploring our amazing products!',
      payload: 'welcome',
    );
  }

  // Send welcome back notification
  Future<void> sendWelcomeBackNotification(String userName) async {
    await _showLocalNotification(
      title: 'Welcome back! 👋',
      body: 'Hi $userName! We missed you. Check out our latest arrivals and exclusive offers!',
      payload: 'welcome_back',
    );
  }

  // Send discount notification
  Future<void> sendDiscountNotification(String discountCode, double discountPercent) async {
    await _showLocalNotification(
      title: 'Special Offer! 💰',
      body: 'Get $discountPercent% off with code $discountCode. Limited time only!',
      payload: 'discount',
    );
  }

  // Send purchase completion notification
  Future<void> sendPurchaseCompletionNotification(String orderId, double totalAmount) async {
    await _showLocalNotification(
      title: 'Order Confirmed! ✅',
      body: 'Your order #$orderId has been confirmed. Total: \$${totalAmount.toStringAsFixed(2)}',
      payload: 'purchase_complete',
    );
  }

  // Send shipping update notification
  Future<void> sendShippingUpdateNotification(String orderId, String status) async {
    await _showLocalNotification(
      title: 'Shipping Update 📦',
      body: 'Order #$orderId: $status',
      payload: 'shipping_update',
    );
  }
}
