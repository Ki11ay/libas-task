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
  createdAt: UserModel._timestampFromJson(json['createdAt']),
  updatedAt: UserModel._timestampFromJson(json['updatedAt']),
  isEmailVerified: json['isEmailVerified'] as bool,
  favoriteProducts:
      (json['favoriteProducts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  preferences: json['preferences'] as Map<String, dynamic>?,
  fcmToken: json['fcmToken'] as String?,
  lastLoginAt: UserModel._timestampFromJson(json['lastLoginAt']),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'displayName': instance.displayName,
  'photoURL': instance.photoURL,
  'phoneNumber': instance.phoneNumber,
  'address': instance.address,
  'createdAt': UserModel._timestampToJson(instance.createdAt),
  'updatedAt': UserModel._timestampToJson(instance.updatedAt),
  'isEmailVerified': instance.isEmailVerified,
  'favoriteProducts': instance.favoriteProducts,
  'preferences': instance.preferences,
  'fcmToken': instance.fcmToken,
  'lastLoginAt': UserModel._timestampToJson(instance.lastLoginAt),
};
