import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/features/activity/data/data_source/activity_remote_data_source.dart';
import 'package:bigtalk/features/activity/domain/entity/activity_entity.dart';
import 'package:bigtalk/features/activity/domain/repository/activity_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityRemoteRepositoryProvider = Provider<IActivityRepository>((ref) {
  return ActivityRemoteRepositoryImpl(
    activityRemoteDataSource: ref.read(activityRemoteDataSourceProvider),
  );
});

class ActivityRemoteRepositoryImpl implements IActivityRepository {
  final ActivityRemoteDataSource activityRemoteDataSource;

  ActivityRemoteRepositoryImpl({required this.activityRemoteDataSource});
  @override
  Future<Either<Failure, List<ActivityEntity>>> getActivity(String tab) {
    return activityRemoteDataSource.getActivity(tab);
  }
}
