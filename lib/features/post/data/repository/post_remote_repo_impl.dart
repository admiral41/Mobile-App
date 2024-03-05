import 'dart:io';

import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/features/post/data/data_source/post_remote_data_source.dart';
import 'package:bigtalk/features/post/domain/entity/post_entity.dart';
import 'package:bigtalk/features/post/domain/repository/post_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postRemoteRepositoryProvider = Provider<IPostRepository>((ref) {
  return PostRemoteRepositoryImpl(
    postRemoteDataSource: ref.read(postRemoteDataSourceProvider),
  );
});

class PostRemoteRepositoryImpl implements IPostRepository {
  final PostRemoteDataSource postRemoteDataSource;

  PostRemoteRepositoryImpl({required this.postRemoteDataSource});

  @override
  Future<Either<Failure, bool>> deletePost(String postId) {
    return postRemoteDataSource.deletePost(postId);
  }

  @override
  Future<Either<Failure, bool>> likePost(String postId) {
    return postRemoteDataSource.likeAndUnlikePost(postId);
  }

  @override
  Future<Either<Failure, bool>> unlikePost(String postId) {
    return postRemoteDataSource.likeAndUnlikePost(postId);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getPostsOfFollowingUsers() {
    return postRemoteDataSource
        .getPostOfFollowingUsers(); // Changed method name here
  }

  @override
  Future<Either<Failure, bool>> createPost(PostEntity post, File image) {
    return postRemoteDataSource.createPost(post, image);
  }

  @override
  Future<Either<Failure, bool>> createComment(String postId, String comment) {
    return postRemoteDataSource.createComment(postId, comment);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getPostByUserIdApi(String id) {
    return postRemoteDataSource.getPostByUserIdApi(id);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getPostsByUserCommentsApi(
      String id) {
    return postRemoteDataSource.getPostsByUserCommentsApi(id);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getCommentByPostID(String postId) {
    return postRemoteDataSource.getCommentByPostID(postId);
  }
}
