import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';

class TransactionItemShimmer extends StatelessWidget {
  const TransactionItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.4,
          children: [
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Theme.of(context).cardColor,
              foregroundColor: Colors.blue,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(12.r),
              label: 'Edit',
            ),
          ],
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ListTile(),
        ),
      ),
    );
  }
}
