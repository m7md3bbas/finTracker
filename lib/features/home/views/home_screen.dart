import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:finance_track/core/utils/helper/greatings/greating_function.dart';
import 'package:finance_track/core/utils/helper/ui/customcurvecliper.dart';
import 'package:finance_track/features/auth/logic/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: BottomCurveClipper(),
                  child: Container(
                    width: double.infinity,
                    height: 250.h,
                    decoration: BoxDecoration(
                      color: Colors.white.modify(
                        colorCode: AppColors.mainAppColor,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${getGreetingMessage()}, ",
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "\n${context.read<LoginCubit>().user?.userMetadata?.entries.map((e) => e.key == "name" ? e.value : "").join(" ")}",
                                    style: GoogleFonts.inter(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Spacer(),
                          Card(
                            color: Colors.white.modify(
                              colorCode: AppColors.mainCardColor,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
