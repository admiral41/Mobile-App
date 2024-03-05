// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityApiModel _$ActivityApiModelFromJson(Map<String, dynamic> json) =>
    ActivityApiModel(
      activityId: json['_id'] as String?,
      user: json['user'] == null
          ? null
          : TargetUserApiModel.fromJson(json['user'] as Map<String, dynamic>),
      actionType: json['actionType'] as String,
      targetUser: json['targetUser'] == null
          ? null
          : TargetUserApiModel.fromJson(
              json['targetUser'] as Map<String, dynamic>),
      post: json['post'] == null
          ? null
          : TargetPostApiModel.fromJson(json['post'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$ActivityApiModelToJson(ActivityApiModel instance) =>
    <String, dynamic>{
      '_id': instance.activityId,
      'user': instance.user,
      'actionType': instance.actionType,
      'targetUser': instance.targetUser,
      'post': instance.post,
      'createdAt': instance.createdAt,
    };
