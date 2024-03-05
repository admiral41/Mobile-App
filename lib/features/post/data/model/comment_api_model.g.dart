// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentApiModel _$CommentApiModelFromJson(Map<String, dynamic> json) =>
    CommentApiModel(
      user: json['user'] as String?,
      comment: json['comment'] as String?,
      commentId: json['_id'] as String?,
      createdAt: json['createdAt'] as String?,
      owner: json['owner'] == null
          ? null
          : OwnerApiModel.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentApiModelToJson(CommentApiModel instance) =>
    <String, dynamic>{
      '_id': instance.commentId,
      'user': instance.user,
      'comment': instance.comment,
      'createdAt': instance.createdAt,
      'owner': instance.owner,
    };
