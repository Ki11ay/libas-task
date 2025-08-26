// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  originalPrice: (json['originalPrice'] as num?)?.toDouble(),
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  category: json['category'] as String,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  stockQuantity: (json['stockQuantity'] as num).toInt(),
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
  isAvailable: json['isAvailable'] as bool? ?? true,
  isFeatured: json['isFeatured'] as bool? ?? false,
  specifications: json['specifications'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'images': instance.images,
      'category': instance.category,
      'tags': instance.tags,
      'stockQuantity': instance.stockQuantity,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'isAvailable': instance.isAvailable,
      'isFeatured': instance.isFeatured,
      'specifications': instance.specifications,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
