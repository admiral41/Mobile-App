import '../../features/auth/presentation/view/forgot_password_view.dart';
import '../../features/auth/presentation/view/login_view.dart';
import '../../features/auth/presentation/view/signup_view.dart';
import '../../features/post/presentation/view/home_view.dart';
import '../../features/splash/presentation/view/splash_view.dart';

class AppRoute {
  AppRoute._();
  static const String splashRoute = '/splash';
  static const String loginScreenRoute = '/login';
  static const String singupScreenRoute = '/signup';
  static const String forgotPasswordScreenRoute = '/forgot-password';
  static const String homeScreenRoute = '/home';

  static getApplicationRoute() {
    return {
      splashRoute: (context) => const SplashView(),
      loginScreenRoute: (context) => const LoginPage(),
      singupScreenRoute: (context) => const SignupPage(),
      forgotPasswordScreenRoute: (context) => const ForgotPasswordPage(),
      homeScreenRoute: (context) => const HomeScreen(),
    };
  }
}
