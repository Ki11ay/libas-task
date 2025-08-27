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
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  city: json['city'] as String?,
  state: json['state'] as String?,
  zipCode: json['zipCode'] as String?,
  country: json['country'] as String?,
  streetName: json['streetName'] as String?,
  streetNumber: json['streetNumber'] as String?,
  formattedAddress: json['formattedAddress'] as String?,
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
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'city': instance.city,
  'state': instance.state,
  'zipCode': instance.zipCode,
  'country': instance.country,
  'streetName': instance.streetName,
  'streetNumber': instance.streetNumber,
  'formattedAddress': instance.formattedAddress,
  'createdAt': UserModel._timestampToJson(instance.createdAt),
  'updatedAt': UserModel._timestampToJson(instance.updatedAt),
  'isEmailVerified': instance.isEmailVerified,
  'favoriteProducts': instance.favoriteProducts,
  'preferences': instance.preferences,
  'fcmToken': instance.fcmToken,
  'lastLoginAt': UserModel._timestampToJson(instance.lastLoginAt),
};
