import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final followUserUseCaseProvider = Provider<FollowUserUseCase>(
  (ref) => FollowUserUseCase(ref.read(authRepositoryProvider)),
);

class FollowUserUseCase {
  final IAuthRepository _authRepository;

  FollowUserUseCase(this._authRepository);

  Future<Either<Failure, bool>> followUser(String userId) {
    return _authRepository.followUser(userId);
  }

  Future<Either<Failure, bool>> unfollowUser(String userId) {
    return _authRepository.unfollowUser(userId);
  }
}
