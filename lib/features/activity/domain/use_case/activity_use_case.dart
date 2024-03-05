import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/features/activity/domain/entity/activity_entity.dart';
import 'package:bigtalk/features/activity/domain/repository/activity_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityUseCaseProvider = Provider<ActivityUseCase>(
  (ref) => ActivityUseCase(
    activityRepository: ref.watch(activityRepositoryProvider),
  ),
);

class ActivityUseCase {
  final IActivityRepository activityRepository;

  ActivityUseCase({required this.activityRepository});

  Future<Either<Failure, List<ActivityEntity>>> getActivity(String tab) {
    return activityRepository.getActivity(tab);
  }
}
