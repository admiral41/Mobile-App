// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_activity_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetActivityDTO _$GetActivityDTOFromJson(Map<String, dynamic> json) =>
    GetActivityDTO(
      success: json['success'] as bool,
      count: json['count'] as int?,
      activities: (json['activities'] as List<dynamic>)
          .map((e) => ActivityApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetActivityDTOToJson(GetActivityDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'activities': instance.activities,
    };
