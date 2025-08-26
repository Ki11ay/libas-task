import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  // Custom JSON converters for Firestore Timestamps
  static DateTime _timestampFromJson(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    } else if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return DateTime.now();
  }

  static dynamic _timestampToJson(DateTime date) {
    return date.toIso8601String();
  }

  static double _ratingFromJson(dynamic rating) {
    if (rating is num) {
      return rating.toDouble();
    } else if (rating is String) {
      return double.tryParse(rating) ?? 0.0;
    }
    return 0.0;
  }

  static int _reviewCountFromJson(dynamic reviewCount) {
    if (reviewCount is num) {
      return reviewCount.toInt();
    } else if (reviewCount is String) {
      return int.tryParse(reviewCount) ?? 0;
    }
    return 0;
  }
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final List<String> images;
  final String category;
  final List<String> tags;
  final bool isAvailable;
  final int stockQuantity;
  @JsonKey(fromJson: _ratingFromJson)
  final double rating;
  @JsonKey(fromJson: _reviewCountFromJson)
  final int reviewCount;
  final Map<String, dynamic>? specifications;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.images,
    required this.category,
    required this.tags,
    required this.isAvailable,
    required this.stockQuantity,
    required this.rating,
    required this.reviewCount,
    this.specifications,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    List<String>? images,
    String? category,
    List<String>? tags,
    bool? isAvailable,
    int? stockQuantity,
    double? rating,
    int? reviewCount,
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
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isAvailable: isAvailable ?? this.isAvailable,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      specifications: specifications ?? this.specifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper method to check if product is on sale
  bool get isOnSale => originalPrice != null && originalPrice! > price;
  
  // Helper method to calculate discount percentage
  double? get discountPercentage {
    if (originalPrice == null || originalPrice! <= price) return null;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }
}
