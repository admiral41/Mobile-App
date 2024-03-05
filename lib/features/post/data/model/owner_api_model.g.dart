// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnerApiModel _$OwnerApiModelFromJson(Map<String, dynamic> json) =>
    OwnerApiModel(
      ownerId: json['_id'] as String?,
      name: json['name'] as String?,
      avatar: json['avatar'] == null
          ? null
          : AvatarApiModel.fromJson(json['avatar'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OwnerApiModelToJson(OwnerApiModel instance) =>
    <String, dynamic>{
      '_id': instance.ownerId,
      'name': instance.name,
      'avatar': instance.avatar,
    };
