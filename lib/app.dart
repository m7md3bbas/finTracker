import 'package:finance_track/core/routes/app_routes.dart';
import 'package:finance_track/core/utils/helper/dismissKeyboard/dismiss_keyboard.dart';
import 'package:finance_track/features/auth/logic/user/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinTracker extends StatelessWidget {
  const FinTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit()..loadUserData(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        child: DismissKeyboard(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRoutes.routes,
          ),
        ),
      ),
    );
  }
}
