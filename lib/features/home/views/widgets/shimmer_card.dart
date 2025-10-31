import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';

class BalanceCardShimmer extends StatelessWidget {
  const BalanceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor = Colors.white.modify(colorCode: AppColors.mainCardColor);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: 14.h, width: 100.w, color: Colors.white),
                Container(
                  height: 24.w,
                  width: 24.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Balance
            Container(height: 32.h, width: 160.w, color: Colors.white),
            SizedBox(height: 20.h),

            // Budget progress bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: 14.h, width: 80.w, color: Colors.white),
                Container(height: 14.h, width: 80.w, color: Colors.white),
              ],
            ),
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: Container(
                height: 6.h,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),

            // Income & Expenses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(height: 20.w, width: 20.w, color: Colors.white),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12.h,
                          width: 50.w,
                          color: Colors.white,
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          height: 16.h,
                          width: 70.w,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(height: 20.w, width: 20.w, color: Colors.white),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12.h,
                          width: 50.w,
                          color: Colors.white,
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          height: 16.h,
                          width: 70.w,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
