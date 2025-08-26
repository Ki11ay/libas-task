import 'package:json_annotation/json_annotation.dart';
import 'cart_item_model.dart';

part 'order_model.g.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded
}

@JsonSerializable()
class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final OrderStatus status;
  final String? trackingNumber;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? estimatedDelivery;
  final String? shippingAddress;
  final String? paymentMethod;
  final String? stripePaymentIntentId;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    this.trackingNumber,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.estimatedDelivery,
    this.shippingAddress,
    this.paymentMethod,
    this.stripePaymentIntentId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  OrderModel copyWith({
    String? id,
    String? userId,
    List<CartItemModel>? items,
    double? totalAmount,
    OrderStatus? status,
    String? trackingNumber,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? estimatedDelivery,
    String? shippingAddress,
    String? paymentMethod,
    String? stripePaymentIntentId,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      stripePaymentIntentId: stripePaymentIntentId ?? this.stripePaymentIntentId,
    );
  }
}
