import 'package:finance_track/core/routes/app_routes.dart';
import 'package:finance_track/core/utils/helper/dismissKeyboard/dismiss_keyboard.dart';
import 'package:finance_track/features/auth/logic/user/user_cubit.dart';
import 'package:finance_track/features/settings/logic/theme/theme_cubit.dart';
import 'package:finance_track/features/settings/logic/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinTracker extends StatelessWidget {
  const FinTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit()..loadUserData()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        child: DismissKeyboard(
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                themeMode: themeState.themeMode,
                routerConfig: AppRoutes.routes,
              );
            },
          ),
        ),
      ),
    );
  }
}
