import 'package:bigtalk/features/auth/domain/entity/avatar_entity.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final AvatarEntity? avatar;
  final String? id;
  final String? name;

  const UserEntity({this.id, this.name, this.avatar});

  @override
  List<Object?> get props => [id, name, avatar];

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['_id'],
      name: json['name'],
      avatar:
          json['avatar'] != null ? AvatarEntity.fromJson(json['avatar']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'avatar': avatar?.toJson(),
      };

  UserEntity copyWith({
    String? id,
    String? name,
    AvatarEntity? avatar,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }
}
