import 'dart:io';

import 'package:bigtalk/config/constants/api_endpoints.dart';
import 'package:bigtalk/core/network/http_service.dart';
import 'package:bigtalk/core/shared_prefs/user_shared_prefs.dart';
import 'package:bigtalk/features/post/data/dto/get_post_dto.dart';
import 'package:bigtalk/features/post/data/model/post_api_model.dart';
import 'package:bigtalk/features/post/domain/entity/post_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';

final postRemoteDataSourceProvider = Provider(
  (ref) => PostRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
    postApiModel: ref.read(postApiModelProvider),
  ),
);

class PostRemoteDataSource {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;
  final PostApiModel postApiModel;

  PostRemoteDataSource({
    required this.userSharedPrefs,
    required this.dio,
    required this.postApiModel,
  });

  // create post
  Future<Either<Failure, bool>> createPost(PostEntity post, File? image) async {
    try {
      String? token;
      await userSharedPrefs
          .getUserToken()
          .then((value) => value.fold((l) => null, (r) => token = r!));

      FormData formData = FormData.fromMap({
        'caption': post.caption,
        'image': image != null
            ? await MultipartFile.fromFile(image.path,
                filename: image.path.split('/').last)
            : null,
      });

      var response = await dio.post(
        ApiEndpoints.createPosts,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> deletePost(String postId) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold(
        (l) => token = null,
        (r) => token = r!,
      );
      Response response = await dio.delete(
        ApiEndpoints.deletePost.replaceAll(':id', postId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // Check the response and handle accordingly
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> likeAndUnlikePost(String postId) async {
    try {
      print('Like/Unlike Post Request:');
      print('Post ID: $postId');

      String url =
          '${ApiEndpoints.baseUrl}${ApiEndpoints.likeAndUnlikePost.replaceAll(':id', postId)}';

      // Get the current post to check if it's liked
      final postResponse = await dio.get(
        '${ApiEndpoints.baseUrl}post/$postId',
        options: await _getOptionsWithAuthHeader(),
      );

      // Check if 'likes' is null or not
      if (postResponse.data['likes'] != null) {
        bool isLiked =
            postResponse.data['likes'].contains(userSharedPrefs.getUserId());
        print("object $isLiked");
        Response response;

        if (isLiked) {
          // If liked, send an unlike request
          response = await dio.delete(
            url,
            options: await _getOptionsWithAuthHeader(),
          );
        } else {
          // If not liked, send a like request
          response = await dio.post(
            url,
            options: await _getOptionsWithAuthHeader(),
          );
        }

        print('Like/Unlike Post Response:');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.data}');

        // Check the response and handle accordingly
        if (response.statusCode == 200) {
          return const Right(true);
        } else {
          return Left(
            Failure(
              error: response.data["message"],
              statusCode: response.statusCode.toString(),
            ),
          );
        }
      } else {
        return Left(
          Failure(
            error: "Likes data is null",
            statusCode: "0",
          ),
        );
      }
    } on DioError catch (e) {
      print('Dio Error:');
      print(e.response?.data);
      print(e.message);
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  // createComment
  Future<Either<Failure, bool>> createComment(
      String postId, String comments) async {
    try {
      Response response = await dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.createComment.replaceAll(':id', postId)}',
        data: {
          'comment': comments,
        },
        options: await _getOptionsWithAuthHeader(),
      );

      // Check the response and handle accordingly
      if (response.statusCode == 201) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, List<PostEntity>>> getPostOfFollowingUsers() async {
    try {
      String? token;
      await userSharedPrefs
          .getUserToken()
          .then((value) => value.fold((l) => null, (r) => token = r!));
      var response = await dio.get(ApiEndpoints.getPostOfFollowingUsers,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
      if (response.statusCode == 200) {
        // OR
        // 2nd way
        GetPostDTO getFollowingPostDTO = GetPostDTO.fromJson(response.data);
        print("STAUS CODE 201:::${getFollowingPostDTO.toJson()}");

        return Right(postApiModel.toEntityList(getFollowingPostDTO.posts));
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
        ),
      );
    }
  }

  //getPostByUserIdApi
  Future<Either<Failure, List<PostEntity>>> getPostByUserIdApi(
      String userId) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.getPostByUserIdApi}$userId',
        options: await _getOptionsWithAuthHeader(),
      );

      if (response.statusCode == 200) {
        final GetPostDTO getPostDTO = GetPostDTO.fromJson(response.data);
        final List<PostEntity> posts = getPostDTO.posts.map((postApiModel) {
          return postApiModel.toEntity();
        }).toList();
        return Right(posts);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioError catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  //getPostsByUserCommentsApi
  Future<Either<Failure, List<PostEntity>>> getPostsByUserCommentsApi(
      String userId) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.getPostsByUserCommentsApi}/$userId/comments',
        options: await _getOptionsWithAuthHeader(),
      );

      if (response.statusCode == 200) {
        final GetPostDTO getPostDTO = GetPostDTO.fromJson(response.data);
        final List<PostEntity> posts = getPostDTO.posts.map((postApiModel) {
          return postApiModel.toEntity();
        }).toList();
        return Right(posts);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioError catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  //getCommentByPostID
  Future<Either<Failure, List<PostEntity>>> getCommentByPostID(
      String postId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getCommentByPostID.replaceAll(':id', postId),
        options: await _getOptionsWithAuthHeader(),
      );

      if (response.statusCode == 200) {
        final GetPostDTO getPostDTO = GetPostDTO.fromJson(response.data);
        final List<PostEntity> posts = getPostDTO.posts.map((postApiModel) {
          return postApiModel.toEntity();
        }).toList();
        return Right(posts);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioError catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Options> _getOptionsWithAuthHeader() async {
    final tokenEither = await userSharedPrefs.getUserToken();
    return tokenEither.fold(
      (failure) => Options(),
      (token) => Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
