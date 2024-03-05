import 'package:bigtalk/config/routes/routes.dart';
import 'package:bigtalk/core/common/snackbar/my_snackbar.dart';
import 'package:bigtalk/core/shared_prefs/user_shared_prefs.dart';
import 'package:bigtalk/features/auth/domain/entity/auth_entity.dart';
import 'package:bigtalk/features/auth/domain/use_case/follow_usecase.dart';
import 'package:bigtalk/features/auth/domain/use_case/login_usecase.dart';
import 'package:bigtalk/features/auth/domain/use_case/register_usecase.dart';
import 'package:bigtalk/features/auth/domain/use_case/search_usecase.dart';
import 'package:bigtalk/features/auth/presentation/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(
    ref.read(registerUseCaseProvider),
    ref.read(loginUseCaseProvider),
    ref.read(searchUserByNameUseCaseProvider),
    ref.read(followUserUseCaseProvider),
    ref.read(
      userSharedPrefsProvider,
    ),
  ),
);

class AuthViewModel extends StateNotifier<AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final SearchUserByNameUseCase _searchUserByNameUseCase;
  final FollowUserUseCase _followUserUseCase;
  final UserSharedPrefs _userSharedPrefs;

  AuthViewModel(
    this._registerUseCase,
    this._loginUseCase,
    this._searchUserByNameUseCase,
    this._followUserUseCase,
    this._userSharedPrefs,
  ) : super(AuthState.initial());

  Future<void> registerUser(AuthEntity entity) async {
    state = state.copyWith(isLoading: true);
    final result = await _registerUseCase.registerUser(entity);
    state = state.copyWith(isLoading: false);
    result.fold(
      (failure) => state = state.copyWith(error: failure.error),
      (success) => state = state.copyWith(isLoading: false, showMessage: true),
    );
    resetMessage();
  }

  // Login
  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    state = state.copyWith(isLoading: true);
    final result = await _loginUseCase.loginUser(email, password);
    state = state.copyWith(isLoading: false);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
          showMessage: true,
        );
      },
      (success) {
        state = state.copyWith(
          isLoading: false,
          showMessage: true,
          error: null,
        );
        Navigator.popAndPushNamed(context, AppRoute.homeScreenRoute);
      },
    );
  }

  Future<void> searchUserByName(BuildContext context, String name) async {
    state = state.copyWith(isLoading: true);
    var data = await _searchUserByNameUseCase.searchUserByName(name);
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
        showSnackBar(
          message: failure.error,
          context: context,
          color: Colors.red,
        );
      },
      (users) {
        state = state.copyWith(
          isLoading: false,
          error: null,
          users: users,
        );
      },
    );
  }

  Future<void> followUser(BuildContext context, String userId) async {
    state = state.copyWith(isLoading: true);
    var data = await _followUserUseCase.followUser(userId);
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
      },
    );
  }

  Future<void> unfollowUser(BuildContext context, String userId) async {
    state = state.copyWith(isLoading: true);
    var data = await _followUserUseCase.unfollowUser(userId);
    data.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
      },
      (success) {
        state = state.copyWith(isLoading: false, error: null);
      },
    );
  }

  void reset() {
    state = state.copyWith(
      isLoading: false,
      error: null,
      imageName: null,
      showMessage: false,
    );
  }

  void resetMessage() {
    state = state.copyWith(
      showMessage: false,
      imageName: null,
      error: null,
      isLoading: false,
    );
  }

  void clearSearchResults() {
    state = state.copyWith(users: [], isLoading: false, error: null);
  }
}
