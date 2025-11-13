import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MonthSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelect;
  final ScrollController? controller;
  const MonthSelector({
    super.key,
    required this.selectedDate,
    required this.onSelect,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: 36,
        itemBuilder: (context, index) {
          final now = DateTime.now();
          final startMonth = now.month - 18;
          final date = DateTime(now.year, startMonth + index, 1);
          final isSelected =
              date.month == selectedDate.month &&
              date.year == selectedDate.year;

          return GestureDetector(
            onTap: () => onSelect(date),
            child: Container(
              width: 120.w,
              margin: EdgeInsets.symmetric(horizontal: 6.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.modify(colorCode: AppColors.mainCardColor)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  DateFormat('MMM\nyyyy').format(date),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
