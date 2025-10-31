import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/routes/routes_name.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:finance_track/core/utils/customs/custom_buttons/custom_button.dart';
import 'package:finance_track/core/utils/customs/textformfield/custom_textfomfield.dart';
import 'package:finance_track/core/utils/popups/toast.dart';
import 'package:finance_track/features/auth/logic/register/register_cubit.dart';
import 'package:finance_track/features/auth/logic/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: const SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _fnameController;
  late final TextEditingController _lnameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  bool obsecureText = true;

  @override
  void initState() {
    super.initState();
    _fnameController = TextEditingController();
    _lnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          ToastNotifier.showSuccess("Registered Successfully");
          context.goNamed(RoutesName.homeScreen);
        }
        if (state.status.isError) {
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
                        Row(
                          spacing: 10.w,
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: _fnameController,
                                hintText: ' First Name',
                              ),
                            ),
                            Expanded(
                              child: CustomTextFormField(
                                controller: _lnameController,
                                hintText: ' Last Name',
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),
                        CustomTextFormField(
                          controller: _emailController,
                          hintText: 'Email',
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 20.h),
                        CustomTextFormField(
                          controller: _passwordController,
                          hintText: 'Password',
                          obscureText: obsecureText,
                          keyboardType: TextInputType.visiblePassword,
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => obsecureText = !obsecureText),
                            icon: obsecureText
                                ? const Icon(Icons.visibility_outlined)
                                : const Icon(Icons.visibility_off_outlined),
                          ),
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
                                  ? context.replaceNamed(
                                      RoutesName.signInScreen,
                                    )
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
      },
    );
  }

  void onPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final fname = _fnameController.text.trim();
    final lname = _lnameController.text.trim();
    if (_formKey.currentState!.validate()) {
      context.read<RegisterCubit>().register(
        email: email,
        password: password,
        name: '$fname $lname',
      );
      autovalidateMode = AutovalidateMode.disabled;
    } else {
      autovalidateMode = AutovalidateMode.always;
    }
  }
}
