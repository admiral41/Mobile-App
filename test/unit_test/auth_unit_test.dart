import 'package:bigtalk/features/auth/domain/use_case/login_usecase.dart';
import 'package:bigtalk/features/auth/domain/use_case/register_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'auth_unit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LoginUseCase>(),
  MockSpec<RegisterUseCase>(),
  MockSpec<BuildContext>(),
])
void main() {
  late LoginUseCase loginUseCase;
  late RegisterUseCase registerUseCase;
  late ProviderContainer container;
  late BuildContext context;
  setUpAll(() {
    loginUseCase = MockLogin();
    registerUseCase = MockRegisterUseCase();
    context = MockBuildContext();
    container = ProviderContainer(
      overrides: [
        authViewModelProvider.overrideWith(
          (ref) => AuthViewModel(registerUseCase, loginUseCase),
        ),
      ],
    );
  });
}
