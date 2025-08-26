// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  trackingNumber: json['trackingNumber'] as String?,
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  estimatedDelivery: json['estimatedDelivery'] == null
      ? null
      : DateTime.parse(json['estimatedDelivery'] as String),
  shippingAddress: json['shippingAddress'] as String?,
  paymentMethod: json['paymentMethod'] as String?,
  stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'trackingNumber': instance.trackingNumber,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'estimatedDelivery': instance.estimatedDelivery?.toIso8601String(),
      'shippingAddress': instance.shippingAddress,
      'paymentMethod': instance.paymentMethod,
      'stripePaymentIntentId': instance.stripePaymentIntentId,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.processing: 'processing',
  OrderStatus.shipped: 'shipped',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
  OrderStatus.refunded: 'refunded',
};
