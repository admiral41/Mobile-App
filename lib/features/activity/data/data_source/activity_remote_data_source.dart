import 'package:bigtalk/config/constants/api_endpoints.dart';
import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/core/network/http_service.dart';
import 'package:bigtalk/core/shared_prefs/user_shared_prefs.dart';
import 'package:bigtalk/features/activity/data/model/activity_api_model.dart';
import 'package:bigtalk/features/activity/domain/entity/activity_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityRemoteDataSourceProvider = Provider(
  (ref) => ActivityRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
    activityApiModel: ref.read(activityApiModelProvider),
  ),
);

class ActivityRemoteDataSource {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;
  final ActivityApiModel activityApiModel;

  ActivityRemoteDataSource({
    required this.dio,
    required this.userSharedPrefs,
    required this.activityApiModel,
  });

  Future<Either<Failure, List<ActivityEntity>>> getActivity(String tab) async {
    final options = await _getOptionsWithAuthHeader();
    final url = _getActivityUrl(tab);

    try {
      final response = await dio.get(
        url,
        options: options,
      );

      if (response.statusCode == 200) {
        final List<ActivityEntity> activityList = response.data['activities']
            .map<ActivityEntity>((activity) =>
                ActivityEntity.fromJson(activity as Map<String, dynamic>))
            .toList();
        return Right(activityList);
      } else {
        return Left(Failure(message: 'Failed to get activity', error: ''));
      }
    } catch (e) {
      return Left(Failure(message: 'Failed to get activity: $e', error: ''));
    }
  }

  String _getActivityUrl(String tab) {
    switch (tab) {
      case 'All':
        return ApiEndpoints.getActivityAll;
      case 'Replies':
        return ApiEndpoints.getActivityReplies;
      case 'Likes':
        return ApiEndpoints.getActivityLikes;
      case 'Follows':
        return ApiEndpoints.getActivityFollowing;
      default:
        return ApiEndpoints.getActivityAll;
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
