import 'package:finance_track/core/routes/routes_name.dart';
import 'package:finance_track/core/routes/routes_path.dart';
import 'package:finance_track/features/home/views/sign_in_screen.dart';
import 'package:finance_track/features/home/views/sign_up_screen.dart';
import 'package:finance_track/features/onboarding/views/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  final routes = GoRouter(
    initialLocation: RoutesPath.onBoradingScreen,
    routes: [
      GoRoute(
        path: RoutesPath.onBoradingScreen,
        name: RoutesName.onboardingScreen,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutesPath.signUpScreen,
        name: RoutesName.signUpScreen,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: RoutesPath.signUpScreen,
        name: RoutesName.signInScreen,
        builder: (context, state) => const SignInScreen(),
      ),
    ],
  );
}
