import 'package:bigtalk/features/activity/domain/entity/target_entity.dart';
import 'package:bigtalk/features/activity/domain/entity/target_post_entity.dart';
import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final String? id;
  final TargetUserEntity? user;
  final String actionType;
  final TargetUserEntity? targetUser;
  final TargetPostEntity? post;
  final String createdAt;

  const ActivityEntity(
      {required this.id,
      required this.user,
      required this.actionType,
      required this.targetUser,
      required this.post,
      required this.createdAt});

  @override
  List<Object?> get props =>
      [id, user, actionType, targetUser, post, createdAt];

  factory ActivityEntity.fromJson(Map<String, dynamic> json) => ActivityEntity(
        id: json['_id'],
        user: json['user'] != null
            ? TargetUserEntity.fromJson(json['user'] as Map<String, dynamic>)
            : null,
        actionType: json['actionType'],
        targetUser: json['targetUser'] != null
            ? TargetUserEntity.fromJson(
                json['targetUser'] as Map<String, dynamic>)
            : null,
        post: json['post'] != null
            ? TargetPostEntity.fromJson(json['post'] as Map<String, dynamic>)
            : null,
        createdAt: json['createdAt'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user': user?.toJson(),
        'actionType': actionType,
        'targetUser': targetUser?.toJson(),
        'post': post?.toJson(),
        'createdAt': createdAt,
      };
}
