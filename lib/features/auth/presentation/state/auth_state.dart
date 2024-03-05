import 'package:bigtalk/features/auth/domain/entity/auth_entity.dart';

class AuthState {
  final bool isLoading;
  final bool isError;
  final String? error;
  final String? imageName;
  final bool? showMessage;
  final List<AuthEntity>? users;
  final AuthEntity? user; // New field to hold fetched user details

  AuthState({
    required this.isError,
    required this.isLoading,
    this.error,
    this.imageName,
    this.showMessage,
    this.users,
    this.user,
  });

  factory AuthState.initial() {
    return AuthState(
      isError: false,
      isLoading: false,
      error: null,
      imageName: null,
      showMessage: false,
      users: [],
      user: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    String? error,
    String? imageName,
    bool? showMessage,
    List<AuthEntity>? users,
    AuthEntity? user, // New parameter for updating user details
    bool? isError,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      imageName: imageName ?? this.imageName,
      showMessage: showMessage ?? this.showMessage,
      users: users ?? this.users,
      user: user ?? this.user,
      isError: isError ?? this.isError,
    );
  }

  @override
  String toString() => 'AuthState(isLoading: $isLoading, error: $error)';
}
