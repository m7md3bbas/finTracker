import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:finance_track/core/extentions/modified_colors.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white.modify(
                  colorCode: AppColors.mainAppColor,
                ),
              ),
              title: Container(height: 12.h, width: 120.w, color: Colors.white),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Container(
                  height: 10.h,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.more_vert, color: Colors.grey.shade300),
            ),
          ),
        );
      },
    );
  }
}
