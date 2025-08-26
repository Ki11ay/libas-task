import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final List<String> favoriteProducts;
  final Map<String, dynamic>? preferences;
  final String? fcmToken;
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.isEmailVerified,
    this.favoriteProducts = const [],
    this.preferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    List<String>? favoriteProducts,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      preferences: preferences ?? this.preferences,
    );
  }
}
