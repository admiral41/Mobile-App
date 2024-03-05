import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/features/auth/data/repository/auth_remote_repository.dart';
import 'package:bigtalk/features/auth/domain/entity/auth_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<IAuthRepository>(
  (ref) => ref.read(authRemoteRepositoryProvider),
);

abstract class IAuthRepository {
  Future<Either<Failure, bool>> registerUser(AuthEntity user);
  Future<Either<Failure, bool>> loginUser(String email, String password);
  Future<Either<Failure, List<AuthEntity>>> searchUserByName(String name);
  Future<Either<Failure, bool>> followUser(String userId);
  Future<Either<Failure, bool>> unfollowUser(String userId);
  Future<Either<Failure, AuthEntity>> getUsersById(String userId);
}
