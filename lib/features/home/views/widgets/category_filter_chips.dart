import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/models/category_model.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:finance_track/core/utils/helper/category/category_list.dart';
import 'package:finance_track/core/models/transactions_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryFilterChips extends StatelessWidget {
  final List<TransactionModel> transactions;
  final CategoryModel? selectedCategory;
  final ValueChanged<CategoryModel?> onSelectionChanged;

  const CategoryFilterChips({
    super.key,
    required this.transactions,
    required this.selectedCategory,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, int> categoryCount = {};
    for (var t in transactions) {
      if (t.categoryName != null) {
        categoryCount[t.categoryName!] =
            (categoryCount[t.categoryName!] ?? 0) + 1;
      }
    }

    final uniqueCategories = categoryCount.keys.toList();
    uniqueCategories.sort(
      (a, b) => categoryCount[b]!.compareTo(categoryCount[a]!),
    );

    if (uniqueCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: uniqueCategories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final categoryName = uniqueCategories[index];
          final count = categoryCount[categoryName] ?? 0;
          final isSelected = categoryName == (selectedCategory?.name ?? '');
          final category = categories.firstWhere(
            (c) => c.name == categoryName,
            orElse: () => categories.first,
          );

          return GestureDetector(
            onTap: () {
              if (selectedCategory?.name == categoryName) {
                onSelectionChanged(null);
              } else {
                onSelectionChanged(category);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.modify(colorCode: AppColors.mainCardColor)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category.icon.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '$categoryName ($count)',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
