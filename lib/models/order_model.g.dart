// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  orderNumber: json['orderNumber'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  subtotal: (json['subtotal'] as num).toDouble(),
  tax: (json['tax'] as num).toDouble(),
  shipping: (json['shipping'] as num).toDouble(),
  total: (json['total'] as num).toDouble(),
  status: json['status'] as String,
  paymentStatus: json['paymentStatus'] as String,
  shippingAddress: json['shippingAddress'] as String,
  billingAddress: json['billingAddress'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  shippedAt: json['shippedAt'] == null
      ? null
      : DateTime.parse(json['shippedAt'] as String),
  deliveredAt: json['deliveredAt'] == null
      ? null
      : DateTime.parse(json['deliveredAt'] as String),
  trackingNumber: json['trackingNumber'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'orderNumber': instance.orderNumber,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'tax': instance.tax,
      'shipping': instance.shipping,
      'total': instance.total,
      'status': instance.status,
      'paymentStatus': instance.paymentStatus,
      'shippingAddress': instance.shippingAddress,
      'billingAddress': instance.billingAddress,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'shippedAt': instance.shippedAt?.toIso8601String(),
      'deliveredAt': instance.deliveredAt?.toIso8601String(),
      'trackingNumber': instance.trackingNumber,
      'notes': instance.notes,
    };
