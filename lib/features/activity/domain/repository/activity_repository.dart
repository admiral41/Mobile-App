import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/features/activity/data/repository/activity_remote_repo_impl.dart';
import 'package:bigtalk/features/activity/domain/entity/activity_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityRepositoryProvider = Provider<IActivityRepository>((ref) {
  return ref.watch(activityRemoteRepositoryProvider);
});

abstract class IActivityRepository {
  Future<Either<Failure, List<ActivityEntity>>> getActivity(String tab);
}
