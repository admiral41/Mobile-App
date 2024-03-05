import 'package:bigtalk/features/post/data/model/owner_api_model.dart';
import 'package:bigtalk/features/post/domain/entity/comment_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_api_model.g.dart';

@JsonSerializable()
class CommentApiModel {
  @JsonKey(name: '_id')
  final String? commentId;
  final String? user;
  final String? comment;
  final String? createdAt;
  final OwnerApiModel? owner;

  const CommentApiModel(
      {this.user, this.comment, this.commentId, this.createdAt, this.owner});

  factory CommentApiModel.fromJson(Map<String, dynamic> json) =>
      _$CommentApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentApiModelToJson(this);

  CommentEntity toEntity() => CommentEntity(
        id: commentId,
        user: user,
        comment: comment,
        createdAt: createdAt,
        owner: owner?.toEntity(),
      );
  List<CommentEntity> listFromJson(List<CommentApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  CommentApiModel fromEntity(CommentEntity entity) => CommentApiModel(
        commentId: entity.id,
        user: entity.user,
        comment: entity.comment,
        createdAt: entity.createdAt,
        owner: owner?.fromEntity(entity.owner!),
      );

  @override
  String toString() {
    return 'CommentApiModel{commentId: $commentId, user: $user, comment: $comment, createdAt: $createdAt , owner: $owner}';
  }
}
