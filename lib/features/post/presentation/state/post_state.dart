import 'package:bigtalk/features/auth/domain/entity/auth_entity.dart';
import 'package:bigtalk/features/post/domain/entity/post_entity.dart';

class PostState {
  final bool isLoading;
  final String? error;
  final String message;
  final List<PostEntity> posts;
  final List<AuthEntity>? users;
  final List<PostEntity>? userComment;

  const PostState({
    this.users,
    required this.isLoading,
    this.error,
    required this.message,
    required this.posts,
    required this.userComment,
  });

  factory PostState.initial() {
    return const PostState(
      isLoading: false,
      error: null,
      message: '',
      posts: [],
      users: [],
      userComment: [],
    );
  }

  PostState copyWith({
    bool? isLoading,
    bool? isError,
    String? message,
    String? error,
    List<PostEntity>? posts,
    List<PostEntity>? userComment,
  }) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
      posts: posts ?? this.posts,
      users: users ?? users,
      userComment: userComment ?? this.userComment,
    );
  }
}
