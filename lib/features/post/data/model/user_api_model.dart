import 'package:bigtalk/features/auth/data/model/avatar_api_model.dart';
import 'package:bigtalk/features/post/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final AvatarApiModel? avatar;

  const UserApiModel({
    this.id,
    this.name,
    this.avatar,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        avatar: avatar?.toEntity(),
      );

  static List<UserEntity> listFromJson(List<UserApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  static UserApiModel fromEntity(UserEntity entity) => UserApiModel(
        id: entity.id,
        name: entity.name,
        avatar: entity.avatar != null
            ? AvatarApiModel(
                publicId: entity.avatar!.publicId,
                url: entity.avatar!.url,
              )
            : const AvatarApiModel.empty(), // Handle null avatar
      );

  @override
  String toString() {
    return 'UserApiModel{id: $id, name: $name, avatar: $avatar}';
  }
}
