import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentTransactionsHeader extends StatelessWidget {
  final VoidCallback? onSeeAll;
  const RecentTransactionsHeader({super.key, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        "Recent Transactions",
        style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600),
      ),
      trailing: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
        ),
        onPressed: onSeeAll,
        child: Text(
          "See All",
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
