import 'package:cloud_functions/cloud_functions.dart';
import '../models/notification_model.dart';

class CloudFunctionsService {
  static final CloudFunctionsService _instance = CloudFunctionsService._internal();
  factory CloudFunctionsService() => _instance;
  CloudFunctionsService._internal();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Send push notification to specific user
  Future<void> sendPushNotificationToUser({
    required String userId,
    required String title,
    required String body,
    String? payload,
    Map<String, dynamic>? data,
    NotificationType type = NotificationType.general,
  }) async {
    try {
      await _functions.httpsCallable('sendPushNotificationToUser').call({
        'userId': userId,
        'title': title,
        'body': body,
        'payload': payload,
        'data': data,
        'type': type.name,
      });
    } catch (e) {
      throw Exception('Failed to send push notification: $e');
    }
  }

  // Send push notification to topic
  Future<void> sendPushNotificationToTopic({
    required String topic,
    required String title,
    required String body,
    String? payload,
    Map<String, dynamic>? data,
    NotificationType type = NotificationType.general,
  }) async {
    try {
      await _functions.httpsCallable('sendPushNotificationToTopic').call({
        'topic': topic,
        'title': title,
        'body': body,
        'payload': payload,
        'data': data,
        'type': type.name,
      });
    } catch (e) {
      throw Exception('Failed to send push notification to topic: $e');
    }
  }

  // Send welcome notification
  Future<void> sendWelcomeNotification({
    required String userId,
    required String userName,
  }) async {
    await sendPushNotificationToUser(
      userId: userId,
      title: 'Welcome to Libas! 🎉',
      body: 'Hi $userName! We\'re excited to have you on board. Start exploring our amazing products!',
      payload: 'welcome',
      type: NotificationType.welcome,
      data: {
        'userName': userName,
        'action': 'welcome',
      },
    );
  }

  // Send welcome back notification
  Future<void> sendWelcomeBackNotification({
    required String userId,
    required String userName,
  }) async {
    await sendPushNotificationToUser(
      userId: userId,
      title: 'Welcome back! 👋',
      body: 'Hi $userName! We missed you. Check out our latest arrivals and exclusive offers!',
      payload: 'welcome_back',
      type: NotificationType.welcomeBack,
      data: {
        'userName': userName,
        'action': 'welcome_back',
      },
    );
  }

  // Send discount notification
  Future<void> sendDiscountNotification({
    required String userId,
    required String discountCode,
    required double discountPercent,
  }) async {
    await sendPushNotificationToUser(
      userId: userId,
      title: 'Special Offer! 💰',
      body: 'Get $discountPercent% off with code $discountCode. Limited time only!',
      payload: 'discount',
      type: NotificationType.discount,
      data: {
        'discountCode': discountCode,
        'discountPercent': discountPercent,
        'action': 'discount',
      },
    );
  }

  // Send purchase completion notification
  Future<void> sendPurchaseCompletionNotification({
    required String userId,
    required String orderId,
    required double totalAmount,
  }) async {
    await sendPushNotificationToUser(
      userId: userId,
      title: 'Order Confirmed! ✅',
      body: 'Your order #$orderId has been confirmed. Total: \$${totalAmount.toStringAsFixed(2)}',
      payload: 'purchase_complete',
      type: NotificationType.purchaseComplete,
      data: {
        'orderId': orderId,
        'totalAmount': totalAmount,
        'action': 'purchase_complete',
      },
    );
  }

  // Send shipping update notification
  Future<void> sendShippingUpdateNotification({
    required String userId,
    required String orderId,
    required String status,
  }) async {
    await sendPushNotificationToUser(
      userId: userId,
      title: 'Shipping Update 📦',
      body: 'Order #$orderId: $status',
      payload: 'shipping_update',
      type: NotificationType.shippingUpdate,
      data: {
        'orderId': orderId,
        'status': status,
        'action': 'shipping_update',
      },
    );
  }

  // Send promotional notification to all users
  Future<void> sendPromotionalNotification({
    required String title,
    required String body,
    String? payload,
    Map<String, dynamic>? data,
  }) async {
    await sendPushNotificationToTopic(
      topic: 'all_users',
      title: title,
      body: body,
      payload: payload,
      data: data,
      type: NotificationType.promotional,
    );
  }

  // Send notification to users interested in specific category
  Future<void> sendCategoryNotification({
    required String category,
    required String title,
    required String body,
    String? payload,
    Map<String, dynamic>? data,
  }) async {
    await sendPushNotificationToTopic(
      topic: 'category_$category',
      title: title,
      body: body,
      payload: payload,
      data: data,
      type: NotificationType.promotional,
    );
  }
}
