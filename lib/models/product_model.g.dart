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
  imageUrl: json['imageUrl'] as String,
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  category: json['category'] as String,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  isAvailable: json['isAvailable'] as bool,
  stockQuantity: (json['stockQuantity'] as num).toInt(),
  rating: ProductModel._ratingFromJson(json['rating']),
  reviewCount: ProductModel._reviewCountFromJson(json['reviewCount']),
  specifications: json['specifications'] as Map<String, dynamic>?,
  createdAt: ProductModel._timestampFromJson(json['createdAt']),
  updatedAt: ProductModel._timestampFromJson(json['updatedAt']),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'imageUrl': instance.imageUrl,
      'images': instance.images,
      'category': instance.category,
      'tags': instance.tags,
      'isAvailable': instance.isAvailable,
      'stockQuantity': instance.stockQuantity,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'specifications': instance.specifications,
      'createdAt': ProductModel._timestampToJson(instance.createdAt),
      'updatedAt': ProductModel._timestampToJson(instance.updatedAt),
    };
