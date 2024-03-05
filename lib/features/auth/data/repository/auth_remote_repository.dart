import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:bigtalk/features/auth/domain/entity/auth_entity.dart';
import 'package:bigtalk/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteRepositoryProvider = Provider<IAuthRepository>(
  (ref) => AuthRemoteRepository(
    ref.read(authRemoteDataSourceProvider),
  ),
);

class AuthRemoteRepository implements IAuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  AuthRemoteRepository(this._authRemoteDataSource);

  @override
  Future<Either<Failure, bool>> loginUser(String email, String password) async {
    return await _authRemoteDataSource.loginUser(email, password);
  }

  @override
  Future<Either<Failure, bool>> registerUser(AuthEntity user) async {
    return await _authRemoteDataSource.registerUser(user);
  }

  @override
  Future<Either<Failure, List<AuthEntity>>> searchUserByName(String name) {
    return _authRemoteDataSource.searchUserByName(name);
  }

  @override
  Future<Either<Failure, bool>> followUser(String userId) {
    return _authRemoteDataSource.followUser(userId);
  }

  @override
  Future<Either<Failure, bool>> unfollowUser(String userId) {
    return _authRemoteDataSource.unfollowUser(userId);
  }

  @override
  Future<Either<Failure, AuthEntity>> getUsersById(String userId) {
    return _authRemoteDataSource.getUsersById(userId);
  }
}
