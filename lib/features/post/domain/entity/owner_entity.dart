import 'package:bigtalk/features/auth/domain/entity/avatar_entity.dart';
import 'package:equatable/equatable.dart';

class OwnerEntity extends Equatable {
  final String? id;
  final String? name;
  final AvatarEntity? avatar;

  const OwnerEntity({
    this.id,
    this.name,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, name, avatar];

  factory OwnerEntity.fromJson(Map<String, dynamic> json) => OwnerEntity(
        id: json['_id'],
        name: json['name'],
        avatar: json['avatar'] != null
            ? AvatarEntity(
                publicId: json['avatar']['public_id'],
                url: json['avatar']['url'],
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'avatar': avatar?.toJson(),
      };
}
