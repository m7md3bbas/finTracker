import 'package:finance_track/core/routes/routes_name.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.modify(colorCode: AppColors.mainAppColor),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 210.w,
              height: 210.h,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 2),
                curve: Curves.fastOutSlowIn,
                builder: (context, value, _) => CircularProgressIndicator(
                  value: value,
                  strokeWidth: 4.w,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
                onEnd: () =>
                    mounted ? context.goNamed(RoutesName.signInScreen) : null,
              ),
            ),
            CircleAvatar(
              radius: 100.r,
              backgroundColor: Colors.white.modify(
                colorCode: AppColors.mainCardColor,
              ),
              child: Text(
                textAlign: TextAlign.center,
                "Finance Tricker App",
                style: GoogleFonts.inter(
                  fontSize: 30.h,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
