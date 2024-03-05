import 'package:bigtalk/features/auth/data/model/avatar_api_model.dart';
import 'package:bigtalk/features/post/domain/entity/owner_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'owner_api_model.g.dart';

@JsonSerializable()
class OwnerApiModel {
  @JsonKey(name: '_id')
  final String? ownerId;
  final String? name;
  final AvatarApiModel? avatar;

  const OwnerApiModel({
    this.ownerId,
    this.name,
    this.avatar,
  });

  const OwnerApiModel.empty()
      : ownerId = '',
        name = '',
        avatar = const AvatarApiModel.empty();

  factory OwnerApiModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerApiModelToJson(this);

  OwnerEntity toEntity() => OwnerEntity(
        id: ownerId,
        name: name,
        avatar: avatar?.toEntity(), // Return the entire AvatarEntity
      );
  // Convert Entity to API Object
  OwnerApiModel fromEntity(OwnerEntity entity) => OwnerApiModel(
        ownerId: entity.id,
        name: entity.name,
        avatar: entity.avatar != null
            ? AvatarApiModel(
                publicId: entity.avatar!.publicId,
                url: entity.avatar!.url,
              )
            : const AvatarApiModel.empty(), // Handle null avatar
      );
  List<OwnerEntity> listFromJson(List<OwnerApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  String toString() {
    return 'OwnerApiModel{ownerId: $ownerId, name: $name, avatar: $avatar}';
  }
}
