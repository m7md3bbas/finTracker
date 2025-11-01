part of 'app_routes.dart';

FutureOr<String?> getRedirect(BuildContext context, GoRouterState state) async {
  final isAuthenticated = context.read<UserCubit>().user;
  final login = state.matchedLocation == RoutesPath.signInScreen;
  final signUp = state.matchedLocation == RoutesPath.signUpScreen;
  final newUsersQuestions =
      state.matchedLocation == RoutesPath.newUserQuestionsScreen;

  if (isAuthenticated == null && !login && !signUp) {
    return RoutesPath.onBoradingScreen;
  }

  if (isAuthenticated != null) {
    final lang = context.read<UserCubit>().user?.userMetadata?['lang'];
    if (lang == null && !newUsersQuestions) {
      return RoutesPath.newUserQuestionsScreen;
    }
    if (login || signUp) {
      return RoutesPath.homeScreen;
    }
  }

  return null;
}
