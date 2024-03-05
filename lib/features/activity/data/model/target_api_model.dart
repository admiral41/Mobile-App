import 'package:bigtalk/features/activity/domain/entity/target_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'target_api_model.g.dart';
@JsonSerializable()
class TargetUserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? targetUserId;
  final String? name;

  const TargetUserApiModel({
    this.targetUserId,
    this.name,
  });

  const TargetUserApiModel.empty()
      : targetUserId = '',
        name = '';
  Map<String, dynamic> toJson() => _$TargetUserApiModelToJson(this);

  factory TargetUserApiModel.fromJson(Map<String, dynamic> json) =>
      _$TargetUserApiModelFromJson(json);

  TargetUserEntity toEntity() => TargetUserEntity(
        id: targetUserId,
        name: name,
      );

  TargetUserApiModel fromEntity(TargetUserEntity entity) => TargetUserApiModel(
        targetUserId: entity.id,
        name: entity.name,
      );

  List<TargetUserEntity> toEntityList(List<TargetUserApiModel> list) =>
      list.map((e) => e.toEntity()).toList();

  @override
  List<Object?> get props => [targetUserId, name];
}
