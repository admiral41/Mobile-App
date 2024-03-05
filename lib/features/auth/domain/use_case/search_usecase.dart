import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/features/auth/domain/entity/auth_entity.dart';
import 'package:bigtalk/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchUserByNameUseCaseProvider = Provider<SearchUserByNameUseCase>(
  (ref) => SearchUserByNameUseCase(ref.read(authRepositoryProvider)),
);

class SearchUserByNameUseCase {
  final IAuthRepository _authRepository;

  SearchUserByNameUseCase(this._authRepository);

  Future<Either<Failure, List<AuthEntity>>> searchUserByName(String name) {
    return _authRepository.searchUserByName(name);
  }
}
