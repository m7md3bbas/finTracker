import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.color,
    required this.onPressed,
    required this.text,
  });
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            color ?? Colors.white.modify(colorCode: AppColors.mainAppColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        minimumSize: Size(180.w, 50.h),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp),
      ),
    );
  }
}
