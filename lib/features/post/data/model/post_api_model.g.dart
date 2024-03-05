// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostApiModel _$PostApiModelFromJson(Map<String, dynamic> json) => PostApiModel(
      postId: json['_id'] as String?,
      caption: json['caption'] as String,
      image: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
      owner: OwnerApiModel.fromJson(json['owner'] as Map<String, dynamic>),
      likes: (json['likes'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: json['createdAt'] as String?,
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CommentApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostApiModelToJson(PostApiModel instance) =>
    <String, dynamic>{
      '_id': instance.postId,
      'caption': instance.caption,
      'image': instance.image,
      'owner': instance.owner,
      'likes': instance.likes,
      'createdAt': instance.createdAt,
      'comments': instance.comments,
    };
