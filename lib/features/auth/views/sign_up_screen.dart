import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/routes/routes_name.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:finance_track/core/utils/customs/custom_buttons/custom_button.dart';
import 'package:finance_track/core/utils/customs/textformfield/custom_textfomfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                autovalidateMode: autovalidateMode,
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign Up',
                      style: GoogleFonts.inter(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.modify(
                          colorCode: AppColors.mainAppColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextfomfield(
                      controller: _nameController,
                      hintText: 'Name',
                    ),

                    SizedBox(height: 20.h),
                    CustomTextfomfield(
                      controller: _emailController,
                      hintText: 'Email',
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20.h),
                    CustomTextfomfield(
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: Icon(Icons.remove_red_eye),
                    ),
                    SizedBox(height: 20.h),
                    Align(
                      alignment: Alignment.center,
                      child: CustomButton(
                        text: 'Sign Up',
                        onPressed: onPressed,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.modify(
                              colorCode: AppColors.mainAppColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => mounted
                              ? context.replaceNamed(RoutesName.signInScreen)
                              : null,
                          child: Text(
                            ' Sign In',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.modify(
                                colorCode: AppColors.mainAppColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onPressed() {
    if (_formKey.currentState!.validate()) {
      autovalidateMode = AutovalidateMode.disabled;
    } else {
      autovalidateMode = AutovalidateMode.always;
    }
  }
}
