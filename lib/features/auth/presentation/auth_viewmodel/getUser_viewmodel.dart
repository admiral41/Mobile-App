import 'package:bigtalk/core/shared_prefs/user_shared_prefs.dart';
import 'package:bigtalk/features/auth/domain/use_case/login_usecase.dart';
import 'package:bigtalk/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserViewModelProvider =
    StateNotifierProvider<getUserViewModel, AuthState>(
  (ref) => getUserViewModel(
    ref.read(loginUseCaseProvider),
    ref.read(userSharedPrefsProvider),
  ),
);

class getUserViewModel extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final UserSharedPrefs _userSharedPrefs;

  getUserViewModel(
    this._loginUseCase,
    this._userSharedPrefs,
  ) : super(AuthState.initial()) {
    getUsersById(null);
  }

  Future<void> getUsersById(String? userId) async {
    state = state.copyWith(isLoading: true);
    var results = await _userSharedPrefs.getUserId();
    results.fold((l) => null, (r) {
      userId = r;
    });
    final result = await _loginUseCase.getUserById(userId!);
    state = state.copyWith(isLoading: false);
    result.fold(
      (failure) {
        print('objectssssss : ${failure.error}');
        state = state.copyWith(
          isLoading: false,
          error: failure.error,
        );
      },
      (user) {
        print('badoooo : $user');
        state = state.copyWith(
          isLoading: false,
          error: null,
          user: user,
        );
      },
    );
  }
}
