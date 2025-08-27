import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double? originalPrice;
  final int quantity;
  final String? size;
  final String? color;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    this.originalPrice,
    required this.quantity,
    this.size,
    this.color,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  CartItem copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    double? originalPrice,
    int? quantity,
    String? size,
    String? color,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }

  // Calculate total price for this item
  double get totalPrice => price * quantity;
  
  // Check if item is on sale
  bool get isOnSale => originalPrice != null && originalPrice! > price;
  
  // Calculate discount percentage
  double? get discountPercentage {
    if (!isOnSale) return null;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }
}

@JsonSerializable()
class Cart {
  final String userId;
  final List<CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cart({
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  
  // Custom toJson method to properly serialize the items list
  @override
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Cart copyWith({
    String? userId,
    List<CartItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cart(
      userId: userId ?? this.userId,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Calculate total items count
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  // Calculate subtotal (before tax/shipping)
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  // Calculate total savings from sales
  double get totalSavings {
    return items.fold(0.0, (sum, item) {
      if (item.isOnSale) {
        return sum + ((item.originalPrice! - item.price) * item.quantity);
      }
      return sum;
    });
  }
  
  // Check if cart is empty
  bool get isEmpty => items.isEmpty;
  
  // Check if cart has items
  bool get hasItems => items.isNotEmpty;
  
  // Get unique products count
  int get uniqueProductsCount => items.length;
  
  // Add item to cart
  Cart addItem(CartItem newItem) {
    final existingItemIndex = items.indexWhere((item) => 
      item.productId == newItem.productId && 
      item.size == newItem.size && 
      item.color == newItem.color
    );

    List<CartItem> newItems;
    if (existingItemIndex != -1) {
      // Update existing item quantity
      newItems = List.from(items);
      newItems[existingItemIndex] = newItems[existingItemIndex].copyWith(
        quantity: newItems[existingItemIndex].quantity + newItem.quantity
      );
    } else {
      // Add new item
      newItems = [...items, newItem];
    }

    return copyWith(
      items: newItems,
      updatedAt: DateTime.now(),
    );
  }
  
  // Update item quantity
  Cart updateItemQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      return removeItem(itemId);
    }

    final newItems = items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    return copyWith(
      items: newItems,
      updatedAt: DateTime.now(),
    );
  }
  
  // Remove item from cart
  Cart removeItem(String itemId) {
    final newItems = items.where((item) => item.id != itemId).toList();
    return copyWith(
      items: newItems,
      updatedAt: DateTime.now(),
    );
  }
  
  // Clear all items
  Cart clear() {
    return copyWith(
      items: [],
      updatedAt: DateTime.now(),
    );
  }
  
  // Check if product is in cart
  bool containsProduct(String productId, {String? size, String? color}) {
    return items.any((item) => 
      item.productId == productId && 
      (size == null || item.size == size) &&
      (color == null || item.color == color)
    );
  }
  
  // Get item by product ID
  CartItem? getItemByProduct(String productId, {String? size, String? color}) {
    try {
      return items.firstWhere((item) => 
        item.productId == productId && 
        (size == null || item.size == size) &&
        (color == null || item.color == color)
      );
    } catch (e) {
      return null;
    }
  }
}
