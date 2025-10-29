part of 'app_routes.dart';

FutureOr<String?> getRedirect(BuildContext context, GoRouterState state) async {
  final isAuthenticated = context.read<LoginCubit>().user;
  final login = state.matchedLocation == RoutesPath.signInScreen;
  final signUp = state.matchedLocation == RoutesPath.signUpScreen;
  final newUsersQuestions =
      state.matchedLocation == RoutesPath.newUserQuestionsScreen;

  if (isAuthenticated == null && !login && !signUp) {
    return RoutesPath.onBoradingScreen;
  }

  if (isAuthenticated != null) {
    final startedMonth = await SharedPref().getStarterMonth();
    if (startedMonth == null && !newUsersQuestions) {
      return RoutesPath.newUserQuestionsScreen;
    }
    if (login || signUp) {
      return RoutesPath.homeScreen;
    }
  }

  return null;
}
