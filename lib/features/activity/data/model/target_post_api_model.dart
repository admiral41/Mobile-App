import 'package:bigtalk/features/activity/domain/entity/target_post_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'target_post_api_model.g.dart';

@JsonSerializable()
class TargetPostApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? caption;

  const TargetPostApiModel({
    this.id,
    this.caption,
  });

  const TargetPostApiModel.empty()
      : id = '',
        caption = '';
  Map<String, dynamic> toJson() => _$TargetPostApiModelToJson(this);
  factory TargetPostApiModel.fromJson(Map<String, dynamic> json) =>
      _$TargetPostApiModelFromJson(json);

  TargetPostEntity toEntity() => TargetPostEntity(
        id: id,
        caption: caption,
      );
  TargetPostApiModel fromEntity(TargetPostEntity entity) => TargetPostApiModel(
        id: entity.id,
        caption: entity.caption,
      );

  List<TargetPostEntity> listFromJson(List<TargetPostApiModel> models) =>
      models.map((model) => model.toEntity()).toList();
  @override
  List<Object?> get props => [id, caption];
}
