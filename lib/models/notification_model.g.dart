// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      payload: json['payload'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'payload': instance.payload,
      'timestamp': instance.timestamp.toIso8601String(),
      'isRead': instance.isRead,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'data': instance.data,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.welcome: 'welcome',
  NotificationType.welcomeBack: 'welcome_back',
  NotificationType.discount: 'discount',
  NotificationType.purchaseComplete: 'purchase_complete',
  NotificationType.shippingUpdate: 'shipping_update',
  NotificationType.general: 'general',
  NotificationType.promotional: 'promotional',
};
