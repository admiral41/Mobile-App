import 'dart:io';

import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/features/post/data/repository/post_remote_repo_impl.dart';
import 'package:bigtalk/features/post/domain/entity/post_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postRepositoryProvider = Provider<IPostRepository>((ref) {
  return ref.watch(postRemoteRepositoryProvider);
});

abstract class IPostRepository {
  Future<Either<Failure, bool>> deletePost(String postId);
  Future<Either<Failure, List<PostEntity>>> getPostsOfFollowingUsers();
  Future<Either<Failure, bool>> likePost(String postId);
  Future<Either<Failure, bool>> unlikePost(String postId);
  Future<Either<Failure, bool>> createPost(PostEntity post, File image);
  Future<Either<Failure, bool>> createComment(String postId, String comment);
  Future<Either<Failure, List<PostEntity>>> getPostByUserIdApi(String id);
  //getPostsByUserCommentsApi
  Future<Either<Failure, List<PostEntity>>> getPostsByUserCommentsApi(
      String id);
  //getCommentByPostID
  Future<Either<Failure, List<PostEntity>>> getCommentByPostID(String postId);
}
