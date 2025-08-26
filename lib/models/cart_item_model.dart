import 'package:json_annotation/json_annotation.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final DateTime addedAt;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.addedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  double get totalPrice => price * quantity;

  CartItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
