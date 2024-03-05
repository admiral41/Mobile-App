import 'dart:io';

import 'package:bigtalk/core/common/snackbar/my_snackbar.dart';
import 'package:bigtalk/features/post/domain/entity/post_entity.dart';
import 'package:bigtalk/features/post/domain/use_case/post_use_case.dart';
import 'package:bigtalk/features/post/presentation/state/post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postViewModelProvider = StateNotifierProvider<PostViewModel, PostState>(
  (ref) => PostViewModel(ref.read(postUseCaseProvider)),
);

class PostViewModel extends StateNotifier<PostState> {
  final PostUseCase postUseCase;

  PostViewModel(this.postUseCase) : super(PostState.initial()) {
    getPostsOfFollowingUsers();
  }

  getPostsOfFollowingUsers() async {
    state = state.copyWith(isLoading: true);
    final result = await postUseCase.getPostsOfFollowingUsers();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        isError: true,
        message: failure.message,
      ),
      (posts) => state = state.copyWith(
        isLoading: false,
        posts: posts,
      ),
    );
  }

  void deletePost(BuildContext context, String postId) async {
    state = state.copyWith(isLoading: true);
    final data = await postUseCase.deletePost(postId);
    data.fold(
      (l) {
        showSnackBar(message: l.error, context: context, color: Colors.red);
        state = state.copyWith(isLoading: false, error: l.error);
      },
      (r) {
        state.posts.removeWhere((post) => post.id == postId);
        state = state.copyWith(isLoading: false, error: null);
        showSnackBar(
          message: 'Post deleted successfully',
          context: context,
        );
      },
    );
  }

  void createPost(PostEntity post, File? image) async {
    state = state.copyWith(isLoading: true);
    final result = await postUseCase.createPost(post, image!);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        isError: true,
        message: failure.message,
      ),
      (success) {
        state = state.copyWith(
          isLoading: false,
          message: 'Post created successfully',
        );
      },
    );
  }

  void createComment(String postId, String comment) async {
    state = state.copyWith(isLoading: true);
    final result = await postUseCase.createComment(postId, comment);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        isError: true,
        message: failure.message,
      ),
      (success) {
        state = state.copyWith(
          isLoading: false,
          message: 'Comment created successfully',
        );
      },
    );
  }

  //getPostByUserIdApi
  //getPostByUserIdApi
  getPostByUserIdApi(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await postUseCase.getPostByUserIdApi(id);
      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            isError: true,
            message: failure.message,
            posts: [], // Clear posts in case of failure
          );
        },
        (posts) {
          final userPosts =
              posts.where((post) => post.owner?.id == id).toList();
          state = state.copyWith(
            isLoading: false,
            posts: userPosts,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isError: true,
        message: 'Error: $e',
        posts: [], // Clear posts in case of failure
      );
    }
  }

//getPostsByUserCommentsApi
  getPostsByUserCommentsApi(String userId) async {
    state = state.copyWith(isLoading: true);
    final result = await postUseCase.getPostsByUserCommentsApi(userId);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isError: true,
          message: failure.message,
          userComment: [], // Clear comments in case of failure
        );
      },
      (posts) {
        print('All Posts: $posts');
        final userComments = posts.where((post) {
          final comments = post.comments ?? [];
          return comments.any((comment) => comment.user == userId);
        }).toList();
        print('User Comments: $userComments');
        state = state.copyWith(
          isLoading: false,
          userComment: userComments,
        );
      },
    );
  }

  //getCommentByPostID
  // ViewModel method
  getCommentByPostID(String postId) async {
    state = state.copyWith(isLoading: true);
    final result = await postUseCase.getCommentByPostID(postId);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isError: true,
          message: failure.message,
          userComment: [], // Clear comments in case of failure
        );
      },
      (comments) {
        state = state.copyWith(
          isLoading: false,
          userComment: comments,
        );
      },
    );
  }

  void likePost(String postId) async {
    state = state.copyWith(isLoading: true);

    final result = await postUseCase.likePost(postId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isError: true,
          message: failure.error,
        );
      },
      (success) {
        state = state.copyWith(
          isLoading: false,
          message: 'Post liked/unliked successfully',
          posts: state.posts.map((post) {
            if (post.id == postId) {
              // If post.likes is null or empty, create a new list with the user id
              final updatedLikes = post.likes ?? [];
              if (updatedLikes.contains('userId')) {
                updatedLikes.remove('userId'); // Remove if liked
              } else {
                updatedLikes.add('userId'); // Add if unliked
              }
              return post.copyWith(likes: updatedLikes);
            }
            return post;
          }).toList(),
        );
      },
    );
  }

  void dislikePost(String postId) async {
    state = state.copyWith(isLoading: true);

    final result = await postUseCase.unlikePost(postId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isError: true,
          message: failure.error,
        );
      },
      (success) {
        state = state.copyWith(
          isLoading: false,
          message: 'Post liked/unliked successfully',
          posts: state.posts.map((post) {
            if (post.id == postId) {
              // If post.likes is null or empty, create a new list with the user id
              final updatedLikes = post.likes ?? [];
              if (updatedLikes.contains('userId')) {
                updatedLikes.remove('userId'); // Remove if liked
              } else {
                updatedLikes.add('userId'); // Add if unliked
              }
              return post.copyWith(likes: updatedLikes);
            }
            return post;
          }).toList(),
        );
      },
    );
  }
}
