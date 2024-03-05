// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetUserApiModel _$TargetUserApiModelFromJson(Map<String, dynamic> json) =>
    TargetUserApiModel(
      targetUserId: json['_id'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$TargetUserApiModelToJson(TargetUserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.targetUserId,
      'name': instance.name,
    };
