import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/routes/routes_name.dart';
import 'package:finance_track/core/utils/caching/shared_pref.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:finance_track/core/utils/customs/custom_buttons/custom_button.dart';
import 'package:finance_track/core/utils/popups/toast.dart';
import 'package:finance_track/features/onboarding/logic/onboarding_cubit.dart';
import 'package:finance_track/features/onboarding/logic/onboarding_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NewUsersQuestions extends StatelessWidget {
  const NewUsersQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: const NewUsersQuestionsScreen(),
    );
  }
}

class NewUsersQuestionsScreen extends StatefulWidget {
  const NewUsersQuestionsScreen({super.key});

  @override
  State<NewUsersQuestionsScreen> createState() =>
      _NewUsersQuestionsScreenState();
}

class _NewUsersQuestionsScreenState extends State<NewUsersQuestionsScreen> {
  Map<String, dynamic>? _selectedCountryLang;
  DateTime? _selectedDate;

  final List<Map<String, dynamic>> countries = [
    {'country': 'Egypt', 'code': 'ar_EG', 'icon': '🇪🇬'},
    {'country': 'United States', 'code': 'en_US', 'icon': '🇺🇸'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final lang = await SharedPref().getSpeakLang();
      final country = await SharedPref().getStarterMonth();
      if (lang != null) {
        setState(() {
          _selectedCountryLang?['code'] = lang;
        });
      }
      if (country != null) {
        setState(() {
          _selectedDate = DateTime.parse(country);
        });
      }
    });
  }

  void _pickDate() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => SizedBox(
        height: 300.h,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Select your start month",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
                color: Colors.white.modify(colorCode: AppColors.mainAppColor),
              ),
            ),
            Expanded(
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: Colors.white.modify(
                        colorCode: AppColors.mainAppColor,
                      ),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  backgroundColor: Colors.transparent,
                  initialDateTime: DateTime.now(),
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: DateTime(DateTime.now().year, 1, 1),
                  maximumDate: DateTime(2100, 12, 31),
                  onDateTimeChanged: (newDate) {
                    setState(() => _selectedDate = newDate);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        final double sheetHeight = (countries.length * 65.h).clamp(
          150.h,
          400.h,
        );

        return SizedBox(
          height: sheetHeight,
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Select your Speaking Language",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: Colors.white.modify(colorCode: AppColors.mainAppColor),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return ListTile(
                      leading: Text(
                        country['icon'],
                        style: TextStyle(fontSize: 24.sp),
                      ),
                      title: Text(
                        country['country'],
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      onTap: () {
                        setState(() => _selectedCountryLang = country);
                        Navigator.pop(context);
                      },

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10.w,
                        children: [
                          Text(country['code']),
                          Text(
                            _selectedCountryLang?['code'] == country['code']
                                ? '✔️'
                                : '',
                            style: TextStyle(fontSize: 20.sp),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Text(
                "Let’s get to know you 👋",
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.modify(colorCode: AppColors.mainAppColor),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Before we start, tell us a bit about yourself.",
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 40.h),
              Text(
                "🌍speaking language",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.modify(colorCode: AppColors.mainAppColor),
                ),
              ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: _showCountryPicker,
                child: _buildInputBox(
                  text: _selectedCountryLang == null
                      ? "Choose your speaking language"
                      : "${_selectedCountryLang!['icon']}  ${_selectedCountryLang!['country']}",
                  icon: Icons.flag_circle_outlined,
                ),
              ),

              SizedBox(height: 25.h),

              // Text(
              //   "📅 When do you want to start tracking?",
              //   style: TextStyle(
              //     fontSize: 16.sp,
              //     fontWeight: FontWeight.w600,
              //     color: Colors.white.modify(colorCode: AppColors.mainAppColor),
              //   ),
              // ),
              // SizedBox(height: 8.h),
              // InkWell(
              //   onTap: _pickDate,
              //   child: _buildInputBox(
              //     text: _selectedDate == null
              //         ? "Select month & year"
              //         : DateFormat('MMMM yyyy').format(_selectedDate!),
              //     icon: Icons.calendar_today_outlined,
              //   ),
              // ),
              const Spacer(),

              BlocConsumer<OnboardingCubit, OnboardingState>(
                listenWhen: (previous, current) =>
                    previous.status != current.status,
                listener: (context, state) {
                  if (state.status == OnboardingStatus.success) {
                    ToastNotifier.showSuccess(state.message ?? '');
                    Future.wait([
                      SharedPref().saveSpeakLang(
                        _selectedCountryLang?['code']!,
                      ),
                      // SharedPref().saveStarterMonth(
                      //   DateFormat('yyyy-MM').format(_selectedDate!),
                      // ),
                    ]);
                    context.goNamed(RoutesName.homeScreen);
                  }
                  if (state.status == OnboardingStatus.error) {
                    ToastNotifier.showError(
                      state.message ??
                          'Something went wrong. Please try again later.',
                    );
                  }
                },
                builder: (context, state) =>
                    state.status == OnboardingStatus.loading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white.modify(
                            colorCode: AppColors.mainAppColor,
                          ),
                        ),
                      )
                    : CustomButton(
                        text: 'Continue',
                        color: Colors.white.modify(
                          colorCode: AppColors.mainAppColor,
                        ),
                        onPressed: () async {
                          if (_selectedCountryLang == null) {
                            ToastNotifier.showError(
                              'Choose your speaking language',
                            );
                            return;
                          }
                          context
                              .read<OnboardingCubit>()
                              .saveSpeakingLangAndStarterMonthly(
                                lang: _selectedCountryLang?['code']!,
                                // month: DateFormat(
                                //   'yyyy-MM',
                                // ).format(_selectedDate!),
                              );
                        },
                      ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBox({required String text, required IconData icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.white.modify(colorCode: AppColors.mainAppColor),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white.modify(colorCode: AppColors.mainAppColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white.modify(colorCode: AppColors.mainAppColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
