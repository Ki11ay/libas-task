import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? payload;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;
  final Map<String, dynamic>? data;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    required this.timestamp,
    this.isRead = false,
    required this.type,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? payload,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, body: $body, isRead: $isRead, type: $type)';
  }
}

enum NotificationType {
  @JsonValue('welcome')
  welcome,
  @JsonValue('welcome_back')
  welcomeBack,
  @JsonValue('discount')
  discount,
  @JsonValue('purchase_complete')
  purchaseComplete,
  @JsonValue('shipping_update')
  shippingUpdate,
  @JsonValue('general')
  general,
  @JsonValue('promotional')
  promotional,
}
