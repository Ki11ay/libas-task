// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  photoURL: json['photoURL'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  address: json['address'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  isEmailVerified: json['isEmailVerified'] as bool,
  favoriteProducts:
      (json['favoriteProducts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  preferences: json['preferences'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'displayName': instance.displayName,
  'photoURL': instance.photoURL,
  'phoneNumber': instance.phoneNumber,
  'address': instance.address,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'isEmailVerified': instance.isEmailVerified,
  'favoriteProducts': instance.favoriteProducts,
  'preferences': instance.preferences,
};
