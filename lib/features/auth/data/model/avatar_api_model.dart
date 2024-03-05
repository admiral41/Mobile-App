import 'package:bigtalk/features/auth/domain/entity/avatar_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'avatar_api_model.g.dart';

@JsonSerializable()
class AvatarApiModel {
  final String? publicId;
  final String? url;

  const AvatarApiModel({
    this.publicId,
    this.url,
  });

  const AvatarApiModel.empty()
      : publicId = '',
        url = '';

  factory AvatarApiModel.fromJson(Map<String, dynamic> json) =>
      _$AvatarApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarApiModelToJson(this);

  // convert avatar_api_model to avatar_entity
  AvatarEntity toEntity() => AvatarEntity(
        publicId: publicId ?? '',
        url: url ?? '',
      );

  // Convert avatar_api_model list to avatar_entity list
  List<AvatarEntity> listFromJson(List<AvatarApiModel> avatarApiModels) {
    return avatarApiModels.map((avatar) => avatar.toEntity()).toList();
  }

  // toModel
  AvatarApiModel fromEntity(AvatarEntity entity) => AvatarApiModel(
        publicId: entity.publicId ?? '',
        url: entity.url ?? '',
      );

  @override
  String toString() {
    return 'AvatarApiModel{publicId: $publicId, url: $url}';
  }
}
