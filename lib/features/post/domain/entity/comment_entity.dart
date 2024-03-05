import 'package:bigtalk/features/post/domain/entity/owner_entity.dart';
import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String? user;
  final String? comment;
  final String? id;
  final String? createdAt;
  final OwnerEntity? owner;

  const CommentEntity({
    this.user,
    this.comment,
    this.id,
    this.createdAt,
    this.owner,
  });

  @override
  List<Object?> get props => [user, comment, id, createdAt, owner];

  factory CommentEntity.fromJson(Map<String, dynamic> json) => CommentEntity(
        user: json['user'],
        comment: json['comment'],
        id: json['_id'],
        createdAt: json['createdAt'],
        owner:
            json['owner'] != null ? OwnerEntity.fromJson(json['owner']) : null,
      );

  Map<String, dynamic> toJson() => {
        'user': user,
        'comment': comment,
        '_id': id,
        'createdAt': createdAt,
        'owner': owner?.toJson(),
      };
}
