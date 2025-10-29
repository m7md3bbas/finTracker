import 'dart:async';

import 'package:finance_track/core/models/transactions_model.dart';
import 'package:finance_track/core/routes/routes_name.dart';
import 'package:finance_track/core/routes/routes_path.dart';
import 'package:finance_track/core/utils/caching/shared_pref.dart';
import 'package:finance_track/features/auth/logic/login/login_cubit.dart';
import 'package:finance_track/features/auth/views/sign_in_screen.dart';
import 'package:finance_track/features/auth/views/sign_up_screen.dart';
import 'package:finance_track/features/home/views/analysis_screen.dart';
import 'package:finance_track/features/home/views/home_screen.dart';
import 'package:finance_track/features/home/views/widgets/add_transaction_screen.dart';
import 'package:finance_track/features/home/views/widgets/edit_transaction_screen.dart';
import 'package:finance_track/features/onboarding/views/new_users_questions.dart';
import 'package:finance_track/features/onboarding/views/onboarding_screen.dart';
import 'package:finance_track/features/settings/views/setting_screen.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
part 'redirect.dart';

class AppRoutes {
  static final routes = GoRouter(
    debugLogDiagnostics: true,
    redirect: (context, state) => getRedirect(context, state),
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
        builder: (context, state) => const SignUp(),
      ),
      GoRoute(
        path: RoutesPath.signInScreen,
        name: RoutesName.signInScreen,
        builder: (context, state) => const SignIn(),
      ),
      GoRoute(
        path: RoutesPath.homeScreen,
        name: RoutesName.homeScreen,
        builder: (context, state) => const Home(),
      ),
      GoRoute(
        path: RoutesPath.addTransactionScreen,
        name: RoutesName.addTransactionScreen,
        builder: (context, state) => const AddTransaction(),
      ),
      GoRoute(
        path: RoutesPath.editTransactionScreen,
        name: RoutesName.editTransactionScreen,
        builder: (context, state) {
          final transaction = state.extra as TransactionModel;
          return EditTransaction(transaction: transaction);
        },
      ),
      GoRoute(
        path: RoutesPath.newUserQuestionsScreen,
        name: RoutesName.newUsersQuestionsScreen,
        builder: (context, state) => const NewUsersQuestions(),
      ),

      GoRoute(
        path: RoutesPath.settingScreen,
        name: RoutesName.settingsScreen,
        builder: (context, state) => const Setting(),
      ),

      GoRoute(
        path: RoutesName.analyticsScreen,
        name: RoutesName.analyticsScreen,
        builder: (context, state) => const Analysis(),
      ),
    ],
  );
}
