import 'package:bigtalk/config/constants/api_endpoints.dart';
import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/core/network/http_service.dart';
import 'package:bigtalk/core/shared_prefs/user_shared_prefs.dart';
import 'package:bigtalk/features/auth/data/model/auth_api_model.dart';
import 'package:bigtalk/features/auth/domain/entity/auth_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider = Provider(
  (ref) => AuthRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
    authApiModel: ref.read(authApiModelProvider),
  ),
);

class AuthRemoteDataSource {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;
  final AuthApiModel authApiModel;

  AuthRemoteDataSource({
    required this.userSharedPrefs,
    required this.dio,
    required this.authApiModel,
  });

  Future<Either<Failure, bool>> registerUser(AuthEntity user) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.register,
        data: {
          'name': user.name,
          'username': user.username,
          'email': user.email,
          'password': user.password,
        },
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

  Future<Either<Failure, bool>> loginUser(
    String email,
    String password,
  ) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.login,
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        String token = response.data["token"];
        await userSharedPrefs.setUserToken(token);
        await userSharedPrefs.setUserId(response.data["userId"]);
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

  Future<Either<Failure, List<AuthEntity>>> searchUserByName(
      String name) async {
    try {
      final response = await dio.post(ApiEndpoints.search,
          data: {
            'name': name,
          },
          options: await _getOptionsWithAuthHeader());

      if (response.statusCode == 200) {
        final List<AuthEntity> users = (response.data['users'] as List)
            .map((json) => AuthEntity.fromJson(json))
            .toList();
        return Right(users);
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

  Future<Either<Failure, bool>> followUser(String userId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.followAndUnfollow.replaceAll(':id', userId),
        options: await _getOptionsWithAuthHeader(),
      );

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
    } on DioError catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> unfollowUser(String userId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.followAndUnfollow.replaceAll(':id', userId),
        options: await _getOptionsWithAuthHeader(),
      );

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
    } on DioError catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  //getUsersById
  Future<Either<Failure, AuthEntity>> getUsersById(String userId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getUserById.replaceAll(':id', userId),
        options: await _getOptionsWithAuthHeader(),
      );
      print('GetUserBYId Response: ${response.data}');

      if (response.statusCode == 200) {
        final user = AuthApiModel.fromJson(response.data['user']).toEntity();
        return Right(user);
      } else {
        // Handle non-200 status codes
        return Left(
          Failure(
            error: 'Failed to get user data',
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioError catch (e) {
      // Handle Dio errors
      return Left(
        Failure(
          error: 'Dio error: ${e.message}',
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    } catch (e) {
      // Handle other unexpected errors
      return Left(
        Failure(
          error: 'Unexpected error: $e',
          statusCode: '0',
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
