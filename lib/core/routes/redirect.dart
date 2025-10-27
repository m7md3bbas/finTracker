part of 'app_routes.dart';

FutureOr<String?> getRedirect(BuildContext context, GoRouterState state) async {
  final isAuthanticated = context.read<LoginCubit>().user;
  final login = state.matchedLocation == RoutesPath.signInScreen;
  final signUp = state.matchedLocation == RoutesPath.signUpScreen;
  final onboarding = state.matchedLocation == RoutesPath.onBoradingScreen;

  if (isAuthanticated == null && !login && !signUp) {
    return RoutesPath.signInScreen;
  }

  if (isAuthanticated != null && (login || signUp)) {
    return RoutesPath.homeScreen;
  }

  return null;
}
