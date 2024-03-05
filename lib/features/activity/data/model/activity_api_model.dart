import 'package:bigtalk/features/activity/data/model/target_api_model.dart';
import 'package:bigtalk/features/activity/data/model/target_post_api_model.dart';
import 'package:bigtalk/features/activity/domain/entity/activity_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_api_model.g.dart';

final activityApiModelProvider = Provider<ActivityApiModel>(
  (ref) => const ActivityApiModel.empty(),
);

@JsonSerializable()
class ActivityApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? activityId;
  final TargetUserApiModel? user;
  final String actionType;
  final TargetUserApiModel? targetUser;
  final TargetPostApiModel? post;
  final String createdAt;

  const ActivityApiModel(
      {this.activityId,
      this.user,
      required this.actionType,
      this.targetUser,
      this.post,
      required this.createdAt});

  const ActivityApiModel.empty()
      : activityId = '',
        user = const TargetUserApiModel.empty(),
        actionType = '',
        targetUser = const TargetUserApiModel.empty(),
        post = const TargetPostApiModel.empty(),
        createdAt = '';

  Map<String, dynamic> toJson() => _$ActivityApiModelToJson(this);

  factory ActivityApiModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityApiModelFromJson(json);

  ActivityEntity toEntity() => ActivityEntity(
        id: activityId,
        user: user?.toEntity(),
        actionType: actionType,
        targetUser: targetUser?.toEntity(),
        post: post?.toEntity(),
        createdAt: createdAt,
      );

  ActivityApiModel fromEntity(ActivityEntity entity) => ActivityApiModel(
        activityId: entity.id,
        user: const TargetUserApiModel().fromEntity(entity.user!),
        actionType: entity.actionType,
        targetUser: const TargetUserApiModel().fromEntity(entity.targetUser!),
        post: const TargetPostApiModel().fromEntity(entity.post!),
        createdAt: entity.createdAt,
      );
  // Convert API List to Entity List

  List<ActivityEntity> toEntityList(List<ActivityApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  // TODO: implement props
  List<Object?> get props => [
        activityId,
        user,
        actionType,
        targetUser,
        post,
        createdAt,
      ];
}
