// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_post_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPostDTO _$GetPostDTOFromJson(Map<String, dynamic> json) => GetPostDTO(
      success: json['success'] as bool,
      count: json['count'] as int?,
      posts: (json['posts'] as List<dynamic>)
          .map((e) => PostApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetPostDTOToJson(GetPostDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'posts': instance.posts,
    };
