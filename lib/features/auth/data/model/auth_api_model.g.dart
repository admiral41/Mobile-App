// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
      userId: json['_id'] as String?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      avatar: json['avatar'] == null
          ? null
          : AvatarApiModel.fromJson(json['avatar'] as Map<String, dynamic>),
      posts:
          (json['posts'] as List<dynamic>?)?.map((e) => e as String).toList(),
      followers: (json['followers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      following: (json['following'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'name': instance.name,
      'username': instance.username,
      'avatar': instance.avatar,
      'email': instance.email,
      'password': instance.password,
      'posts': instance.posts,
      'followers': instance.followers,
      'following': instance.following,
    };
