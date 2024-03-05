import 'dart:io';

import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/features/post/domain/entity/post_entity.dart';
import 'package:bigtalk/features/post/domain/repository/post_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postUseCaseProvider = Provider<PostUseCase>(
  (ref) => PostUseCase(
    postRepository: ref.watch(postRepositoryProvider),
  ),
);

class PostUseCase {
  final IPostRepository postRepository;

  PostUseCase({required this.postRepository});

  Future<Either<Failure, bool>> createPost(PostEntity post, File image) {
    return postRepository.createPost(post, image);
  }

  Future<Either<Failure, bool>> deletePost(String postId) {
    return postRepository.deletePost(postId);
  }

  Future<Either<Failure, List<PostEntity>>> getPostsOfFollowingUsers() {
    return postRepository.getPostsOfFollowingUsers();
  }

  Future<Either<Failure, bool>> likePost(String postId) {
    return postRepository.likePost(postId);
  }

  Future<Either<Failure, bool>> unlikePost(String postId) {
    return postRepository.unlikePost(postId);
  }

  Future<Either<Failure, bool>> createComment(String postId, String comment) {
    return postRepository.createComment(postId, comment);
  }

  Future<Either<Failure, List<PostEntity>>> getPostByUserIdApi(String id) {
    return postRepository.getPostByUserIdApi(id);
  }

  Future<Either<Failure, List<PostEntity>>> getPostsByUserCommentsApi(
      String id) {
    return postRepository.getPostsByUserCommentsApi(id);
  }

  //getCommentByPostID
  Future<Either<Failure, List<PostEntity>>> getCommentByPostID(String postId) {
    return postRepository.getCommentByPostID(postId);
  }
}
