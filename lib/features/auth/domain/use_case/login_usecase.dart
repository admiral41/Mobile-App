import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/features/auth/domain/entity/auth_entity.dart';
import 'package:bigtalk/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginUseCaseProvider = Provider.autoDispose<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);

class LoginUseCase {
  final IAuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Either<Failure, bool>> loginUser(
    String email,
    String password,
  ) async {
    return await _authRepository.loginUser(email, password);
  }

  Future<Either<Failure, AuthEntity>> getUserById(String userId) async {
    return await _authRepository.getUsersById(userId);
  }
}
