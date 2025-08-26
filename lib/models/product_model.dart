import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final List<String> images;
  final String category;
  final List<String> tags;
  final int stockQuantity;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final bool isFeatured;
  final Map<String, dynamic>? specifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.images,
    required this.category,
    this.tags = const [],
    required this.stockQuantity,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isAvailable = true,
    this.isFeatured = false,
    this.specifications,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  double get discountPercentage => hasDiscount ? ((originalPrice! - price) / originalPrice! * 100).roundToDouble() : 0.0;

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    List<String>? images,
    String? category,
    List<String>? tags,
    int? stockQuantity,
    double? rating,
    int? reviewCount,
    bool? isAvailable,
    bool? isFeatured,
    Map<String, dynamic>? specifications,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      images: images ?? this.images,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
      specifications: specifications ?? this.specifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
