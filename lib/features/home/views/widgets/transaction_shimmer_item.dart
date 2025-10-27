import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class TransactionItemShimmer extends StatelessWidget {
  const TransactionItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          title: Container(height: 14.h, width: 120.w, color: Colors.white),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Container(height: 12.h, width: 80.w, color: Colors.white),
          ),
          trailing: Container(height: 16.h, width: 60.w, color: Colors.white),
        ),
      ),
    );
  }
}
