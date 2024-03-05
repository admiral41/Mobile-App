import 'package:bigtalk/features/auth/domain/entity/avatar_entity.dart';
import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? id;
  final String? name;
  final String? username;
  final AvatarEntity? avatar;
  final String? password;
  final String? email;
  final List<String>? posts;
  final List<String>? followers;
  final List<String>? following;

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        avatar,
        password,
        email,
        posts,
        followers,
        following,
      ];

  const AuthEntity({
    this.id,
    this.name,
    this.username,
    this.password,
    this.email,
    this.avatar,
    this.posts,
    this.followers,
    this.following,
  });

  factory AuthEntity.fromJson(Map<String, dynamic> json) => AuthEntity(
        id: json['_id'],
        name: json['name'],
        username: json['username'],
        email: json['email'],
        password: json['password'],
        avatar: json['avatar'] != null
            ? AvatarEntity(
                publicId: json['avatar']['public_id'],
                url: json['avatar']['url'],
              )
            : null,
        posts: json['posts'] != null ? List<String>.from(json['posts']) : null,
        followers: json['followers'] != null
            ? List<String>.from(json['followers'])
            : null,
        following: json['following'] != null
            ? List<String>.from(json['following'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'username': username,
        'email': email,
        'password': password,
        'avatar': avatar != null ? avatar!.toJson() : null,
        'posts': List<dynamic>.from(posts?.map((x) => x) ?? []),
        'followers': List<dynamic>.from(followers?.map((x) => x) ?? []),
        'following': List<dynamic>.from(following?.map((x) => x) ?? []),
      };
}
