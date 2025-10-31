import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/routes/routes_name.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:finance_track/core/utils/customs/custom_buttons/custom_button.dart';
import 'package:finance_track/core/utils/customs/textformfield/custom_textfomfield.dart';
import 'package:finance_track/core/utils/popups/toast.dart';
import 'package:finance_track/core/utils/validation/app_regx.dart';
import 'package:finance_track/features/auth/logic/login/login_cubit.dart';
import 'package:finance_track/features/auth/logic/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          context.goNamed(RoutesName.homeScreen);
        } else if (state.status.isError) {
          ToastNotifier.showError(state.message.toString());
        }
      },
      builder: (context, state) {
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
                          'Sign In',
                          style: GoogleFonts.inter(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.modify(
                              colorCode: AppColors.mainAppColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        CustomTextFormField(
                          controller: _emailController,
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (vlaue) {
                            if (AppRegex.isEmailValid(vlaue!)) {
                              return null;
                            } else {
                              return 'Enter valid email';
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
                        CustomTextFormField(
                          controller: _passwordController,
                          hintText: 'Password',
                          obscureText: obscureText,
                          keyboardType: TextInputType.visiblePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white.modify(
                                colorCode: AppColors.mainAppColor,
                              ),
                            ),
                          ),
                          validator: (vlaue) {
                            if (AppRegex.isPasswordValid(vlaue!)) {
                              return null;
                            } else {
                              return 'Enter valid password';
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              value: false,
                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.white.modify(
                                      colorCode: AppColors.mainAppColor,
                                    );
                                  }
                                  return Colors.transparent;
                                },
                              ),
                              onChanged: (bool? value) {},
                            ),
                            Text(
                              'Remember me',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.modify(
                                  colorCode: AppColors.mainAppColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Align(
                          alignment: Alignment.center,
                          child: state.status.isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white.modify(
                                    colorCode: AppColors.mainAppColor,
                                  ),
                                )
                              : CustomButton(
                                  text: 'Sign In',
                                  onPressed: onPressed,
                                ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
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
                                  ? context.goNamed(RoutesName.signUpScreen)
                                  : null,
                              child: Text(
                                ' Sign Up',
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
      },
    );
  }

  void onPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().signIn(email: email, password: password);
      autovalidateMode = AutovalidateMode.disabled;
    } else {
      autovalidateMode = AutovalidateMode.always;
    }
  }
}
