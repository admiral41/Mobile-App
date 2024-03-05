import 'package:bigtalk/features/auth/data/model/avatar_api_model.dart';
import 'package:bigtalk/features/auth/domain/entity/auth_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_api_model.g.dart';

final authApiModelProvider = Provider<AuthApiModel>((ref) {
  return AuthApiModel(
    email: '',
    name: '',
    username: '',
    password: '',
  );
});

@JsonSerializable()
class AuthApiModel {
  @JsonKey(name: '_id')
  final String? userId;
  final String? name;
  final String? username;
  final AvatarApiModel? avatar; // Use AvatarEntity here
  final String? email;
  final String? password;
  final List<String>? posts;
  final List<String>? followers;
  final List<String>? following;

  AuthApiModel({
    this.userId,
    this.name,
    this.username,
    this.email,
    this.password,
    this.avatar, // Use AvatarEntity here
    this.posts,
    this.followers,
    this.following,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  AuthEntity toEntity() => AuthEntity(
        id: userId,
        name: name,
        username: username,
        password: password ?? '',
        email: email,
        avatar: avatar != null ? avatar!.toEntity() : null,
        posts: posts,
        followers: followers,
        following: following,
      );

  List<AuthEntity> listFromJson(List<AuthApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  String toString() {
    return 'AuthApiModel(id: $userId, name: $name, username: $username, password: $password, email: $email, avatar: $avatar, posts: $posts, followers: $followers, following: $following, )';
  }
}
