// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_by_id_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserByIdDto _$GetUserByIdDtoFromJson(Map<String, dynamic> json) =>
    GetUserByIdDto(
      success: json['success'] as bool,
      message: json['message'] as String?,
      user: json['user'] == null
          ? null
          : AuthApiModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetUserByIdDtoToJson(GetUserByIdDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'user': instance.user,
    };
