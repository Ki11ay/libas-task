import 'package:json_annotation/json_annotation.dart';
import 'cart_item_model.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartModel({
    required this.id,
    required this.userId,
    this.items = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => _$CartModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartModelToJson(this);

  double get totalAmount => items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;

  CartModel copyWith({
    String? id,
    String? userId,
    List<CartItemModel>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
