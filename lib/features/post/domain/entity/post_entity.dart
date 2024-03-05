import 'package:equatable/equatable.dart';

import 'comment_entity.dart';
import 'owner_entity.dart';

class PostEntity extends Equatable {
  final String? id;
  final String? caption;
  final List<String>? image;
  final OwnerEntity? owner;
  final List<String>? likes;
  final String? createdAt;
  final List<CommentEntity>? comments;

  const PostEntity({
    this.id,
    this.caption,
    this.image,
    this.owner,
    this.likes,
    this.createdAt,
    this.comments,
  });

  @override
  List<Object?> get props =>
      [id, caption, image, owner, likes, createdAt, comments];

  factory PostEntity.fromJson(Map<String, dynamic> json) {
    return PostEntity(
      id: json['_id'],
      caption: json['caption'],
      image: json['image'] != null ? List<String>.from(json['image']) : null,
      owner: json['owner'] != null ? OwnerEntity.fromJson(json['owner']) : null,
      likes: json['likes'] != null ? List<String>.from(json['likes']) : null,
      createdAt: json['createdAt'],
      comments: json['comments'] != null
          ? List<CommentEntity>.from(
              json['comments'].map((x) => CommentEntity.fromJson(x)),
            )
          : null, // Handle null comments
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'caption': caption,
        'image': image,
        'owner': owner?.toJson(),
        'likes': likes,
        'createdAt': createdAt,
        'comments': comments?.map((x) => x.toJson()).toList(),
      };
  PostEntity copyWith({
    String? id,
    String? caption,
    List<String>? image,
    OwnerEntity? owner,
    List<String>? likes,
    String? createdAt,
    List<CommentEntity>? comments,
  }) {
    return PostEntity(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      image: image ?? this.image,
      owner: owner ?? this.owner,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
    );
  }
}
