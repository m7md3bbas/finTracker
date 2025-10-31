import 'package:finance_track/core/models/budget_model.dart';
import 'package:finance_track/core/utils/customs/textformfield/custom_textfomfield.dart';
import 'package:finance_track/features/auth/logic/user/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';

class BalanceCard extends StatefulWidget {
  final double totalBalance;
  final double income;
  final double expenses;
  final double remainingBudget;
  final double monthlyBudget;
  final DateTime selectedDate;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.income,
    required this.expenses,
    required this.remainingBudget,
    required this.monthlyBudget,
    required this.selectedDate,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  void _showBudgetDialog() {
    final controller = TextEditingController(
      text: widget.monthlyBudget.toStringAsFixed(0) == '0'
          ? ''
          : widget.monthlyBudget.toStringAsFixed(2),
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        String currency = "\$";
        try {
          final lang = context.read<UserCubit>().user.userMetadata['lang'];
          currency = lang != null && lang.length >= 5
              ? lang.toString().substring(3, 5)
              : "\$";
        } catch (_) {}

        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
              content: SizedBox(
                width: 260.w,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.monthlyBudget == 0
                            ? 'Set Budget'
                            : 'Update Budget',
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'How much do you want to spend?',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 18.h),
                      CustomTextFormField(
                        prefix: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(currency),
                        ),
                        controller: controller,
                        obscureText: false,
                        radius: 12.r,
                        labelText: 'Amount',
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        maxLines: 1,
                        minLines: 1,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a value';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.tryParse(value)! <= 0) {
                            return 'Value must be positive';
                          }
                          return null;
                        },
                        hintText: 'Enter amount',
                      ),
                      SizedBox(height: 22.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 22,
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.modify(
                                colorCode: AppColors.mainAppColor,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 22,
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                final parsedAmount = double.parse(
                                  controller.text,
                                );
                                if (widget.monthlyBudget == 0) {
                                  context.read<UserCubit>().addBudget(
                                    budget: BudgetModel(
                                      month: widget.selectedDate.month,
                                      year: widget.selectedDate.year,
                                      userId: context.read<UserCubit>().user.id,
                                      amount: parsedAmount,
                                    ),
                                  );
                                } else {
                                  context.read<UserCubit>().updateBudget(
                                    budget: BudgetModel(
                                      month: widget.selectedDate.month,
                                      year: widget.selectedDate.year,
                                      userId: context.read<UserCubit>().user.id,
                                      amount: parsedAmount,
                                    ),
                                  );
                                }
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              'Save',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double budgetUsed = widget.monthlyBudget > 0
        ? ((widget.monthlyBudget - widget.remainingBudget) /
                  widget.monthlyBudget)
              .clamp(0.0, 1.0)
        : 0.0;

    final isBudgetSet = widget.monthlyBudget > 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.modify(colorCode: AppColors.mainCardColor),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Balance row + button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${widget.totalBalance.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  color: widget.totalBalance >= 0
                      ? Colors.greenAccent
                      : Colors.red,
                  fontSize: 22.sp,

                  fontWeight: FontWeight.w400,
                ),
              ),

              InkWell(
                onTap: _showBudgetDialog,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.modify(
                      colorCode: AppColors.mainAppColor,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    isBudgetSet ? 'Update Budget' : 'Set Budget',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.wallet,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Budget: \$${widget.monthlyBudget.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.coins,
                        color: widget.remainingBudget > 0
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        size: 14,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Left: \$${widget.remainingBudget.toStringAsFixed(2)}   (${(budgetUsed * 100).clamp(0, 999).toStringAsFixed(0)}%)',
                        style: GoogleFonts.inter(
                          color: widget.remainingBudget > 0
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: LinearProgressIndicator(
                  value: budgetUsed,
                  minHeight: 6.h,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    budgetUsed < 0.75
                        ? Colors.greenAccent
                        : (budgetUsed < 1.0
                              ? Colors.orangeAccent
                              : Colors.redAccent),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.arrow_downward,
                    color: Colors.greenAccent,
                    size: 18,
                  ),
                  SizedBox(width: 6.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Income',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        '\$${widget.income.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              VerticalDivider(
                thickness: 1.1,
                color: Colors.white.withOpacity(0.12),
                width: 30.w,
                indent: 2.h,
                endIndent: 2.h,
              ),
              // Expenses Column
              Row(
                children: [
                  const Icon(Icons.arrow_upward, color: Colors.red, size: 18),
                  SizedBox(width: 6.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expenses',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        '\$${widget.expenses.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
