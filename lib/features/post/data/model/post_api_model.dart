import 'package:bigtalk/features/post/domain/entity/post_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import 'comment_api_model.dart';
import 'owner_api_model.dart';

part 'post_api_model.g.dart';

final postApiModelProvider = Provider<PostApiModel>(
  (ref) => const PostApiModel.empty(),
);

@JsonSerializable()
class PostApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? postId;
  final String caption;
  final List<String> image;
  final OwnerApiModel owner;
  final List<String> likes;
  final String? createdAt;
  final List<CommentApiModel> comments;

  const PostApiModel({
    this.postId,
    required this.caption,
    required this.image,
    required this.owner,
    required this.likes,
    required this.createdAt,
    required this.comments,
  });

  const PostApiModel.empty()
      : postId = '',
        caption = '',
        image = const [],
        owner = const OwnerApiModel.empty(),
        likes = const [],
        createdAt = '',
        comments = const [];
  Map<String, dynamic> toJson() => _$PostApiModelToJson(this);

  factory PostApiModel.fromJson(Map<String, dynamic> json) =>
      _$PostApiModelFromJson(json);

  PostEntity toEntity() => PostEntity(
        id: postId,
        caption: caption,
        image: image,
        owner: owner.toEntity(),
        likes: likes,
        createdAt: createdAt,
        comments: comments != null
            ? comments.map((comment) => comment.toEntity()).toList()
            : [], // Handle null comments
      );

  // Convert Entity to API Object
  PostApiModel fromEntity(PostEntity entity) => PostApiModel(
        postId: entity.id,
        caption: entity.caption ?? '',
        image: entity.image ?? [],
        owner: const OwnerApiModel().fromEntity(entity.owner!),
        likes: entity.likes ?? [],
        createdAt: entity.createdAt ?? '',
        comments: entity.comments != null
            ? entity.comments!
                .map((comment) => const CommentApiModel().fromEntity(comment))
                .toList()
            : [], // Handle null comments
      );

  // Convert API List to Entity List
  List<PostEntity> toEntityList(List<PostApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props =>
      [postId, caption, image, owner, likes, createdAt, comments];
}
