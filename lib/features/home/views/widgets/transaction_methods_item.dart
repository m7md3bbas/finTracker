import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionMethodsItem extends StatelessWidget {
  const TransactionMethodsItem({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        tileColor: Colors.white,
        leading: Icon(
          icon,
          color: Colors.white.modify(colorCode: AppColors.mainAppColor),
        ),
        title: Text(
          text,
          style: GoogleFonts.inter(
            color: Colors.white.modify(colorCode: AppColors.mainAppColor),
            fontSize: 10.sp,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
