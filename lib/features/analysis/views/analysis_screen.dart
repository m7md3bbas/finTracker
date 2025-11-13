import 'package:finance_track/core/extentions/modified_colors.dart';
// import 'package:finance_track/core/models/category_model.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:finance_track/core/utils/helper/category/category_list.dart';
import 'package:finance_track/core/utils/helper/formatedDate/formateddate.dart';
import 'package:finance_track/core/utils/popups/toast.dart';
import 'package:finance_track/features/analysis/logic/analysis_cubit.dart';
import 'package:finance_track/features/analysis/logic/analysis_state.dart';
import 'package:finance_track/features/analysis/views/widgets/shimmer_analysis.dart';
import 'package:finance_track/features/analysis/views/widgets/summary_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum AnalysisType { income, expenses }

class Analysis extends StatelessWidget {
  const Analysis({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalysisCubit()..getAvailableTransactionDates(),
      child: const AnalysisScreen(),
    );
  }
}

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  DateTimeRange? selectedRange;
  AnalysisType selectedType = AnalysisType.expenses;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  bool _hasShownDateSelector = false;

  @override
  void initState() {
    super.initState();
    _loadAnalysis();
  }

  void _loadAnalysis() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    setState(() {
      selectedStartDate = start;
      selectedEndDate = end;
    });
    context.read<AnalysisCubit>().getUserAnalysis(
      startDate: start,
      endDate: end,
    );
  }

  void _autoShowDateSelector() {
    if (!_hasShownDateSelector && mounted) {
      _hasShownDateSelector = true;
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _showAvailableDateSelector();
        }
      });
    }
  }

  Future<void> _showAvailableDateSelector() async {
    final cubit = context.read<AnalysisCubit>();

    if (cubit.state.availableDates == null ||
        cubit.state.availableDates!.isEmpty) {
      await cubit.getAvailableTransactionDates();
    }

    final availableDates = cubit.state.availableDates ?? [];

    if (availableDates.isEmpty) {
      if (mounted) {
        ToastNotifier.showError('No available dates');
      }
      return;
    }

    // Find indices for currently selected dates
    int startIndex = 0;
    int endIndex = availableDates.length - 1;

    if (selectedStartDate != null) {
      final startDateIndex = availableDates.indexWhere(
        (date) =>
            date.year == selectedStartDate!.year &&
            date.month == selectedStartDate!.month &&
            date.day == selectedStartDate!.day,
      );
      if (startDateIndex != -1) {
        startIndex = startDateIndex;
      }
    }

    if (selectedEndDate != null) {
      final endDateIndex = availableDates.indexWhere(
        (date) =>
            date.year == selectedEndDate!.year &&
            date.month == selectedEndDate!.month &&
            date.day == selectedEndDate!.day,
      );
      if (endDateIndex != -1 && endDateIndex >= startIndex) {
        endIndex = endDateIndex;
      }
    }

    await showCupertinoModalPopup(
      barrierColor: Colors.black54,
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ListTile(
                    title: Text(
                      "Select Date Range",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Your available dates.",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Start Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: StatefulBuilder(
                                  builder: (context, setPickState) {
                                    return CupertinoPicker(
                                      backgroundColor: Colors.white,
                                      itemExtent: 28,
                                      magnification: 1.1,
                                      diameterRatio: 1.1,
                                      scrollController:
                                          FixedExtentScrollController(
                                            initialItem: startIndex,
                                          ),
                                      onSelectedItemChanged: (index) {
                                        setPickState(() {
                                          startIndex = index;
                                          if (endIndex < startIndex)
                                            endIndex = startIndex;
                                        });
                                      },
                                      children: availableDates
                                          .map(
                                            (date) => Center(
                                              child: Text(
                                                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "End Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: StatefulBuilder(
                                  builder: (context, setPickState) {
                                    return CupertinoPicker(
                                      backgroundColor: Colors.white,
                                      itemExtent: 28,
                                      magnification: 1.1,
                                      diameterRatio: 1.1,
                                      scrollController:
                                          FixedExtentScrollController(
                                            initialItem: endIndex,
                                          ),
                                      onSelectedItemChanged: (index) {
                                        setPickState(() {
                                          if (index >= startIndex)
                                            endIndex = index;
                                        });
                                      },
                                      children: availableDates
                                          .map(
                                            (date) => Center(
                                              child: Text(
                                                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      borderRadius: BorderRadius.circular(8),
                      child: const Text(
                        "Apply",
                        style: TextStyle(fontSize: 14),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          selectedStartDate = availableDates[startIndex];
                          selectedEndDate = availableDates[endIndex];
                        });
                        cubit.getUserAnalysis(
                          startDate: availableDates[startIndex],
                          endDate: availableDates[endIndex],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.white.modify(colorCode: AppColors.mainAppColor),
        title: Text(
          'Analysis',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showAvailableDateSelector,
            icon: const Icon(Icons.date_range, color: Colors.white),
          ),
        ],
      ),
      body: BlocListener<AnalysisCubit, AnalysisState>(
        listener: (context, state) {
          if (state.availableDates != null &&
              state.availableDates!.isNotEmpty &&
              !_hasShownDateSelector) {
            _autoShowDateSelector();
          }
        },
        child: BlocBuilder<AnalysisCubit, AnalysisState>(
          builder: (context, state) {
            if (state.status.isLoading) {
              return ShimmerAnalysis();
            }
            if (state.status.isError) {
              return Center(
                child: Text(
                  state.message ?? "Failed to load analysis.",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state.analysis?.totalIncome == 0 &&
                state.analysis?.totalExpenses == 0 &&
                state.analysis?.totalSavings == 0) {
              return const Center(child: Text("No data available."));
            }

            final analysis = state.analysis;
            final totalIncome = analysis?.totalIncome ?? 0;
            final totalExpenses = analysis?.totalExpenses ?? 0;
            final totalSavings = analysis?.totalSavings ?? 0;
            final incomeData = analysis?.incomeCategoryBreakdown ?? [];
            final expenseData = analysis?.expenseCategoryBreakdown ?? [];
            bool onlyIncome = hasOnlyIncome(totalIncome, totalExpenses);
            bool onlyExpenses = hasOnlyExpenses(totalIncome, totalExpenses);

            AnalysisType typeToShow = selectedType;
            if (onlyIncome) {
              typeToShow = AnalysisType.income;
            } else if (onlyExpenses) {
              typeToShow = AnalysisType.expenses;
            }

            final pieData = typeToShow == AnalysisType.expenses
                ? expenseData
                : incomeData;
            final totalAmount = typeToShow == AnalysisType.expenses
                ? totalExpenses
                : totalIncome;

            return state.analysis == null
                ? const Center(child: Text("No data available."))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (selectedStartDate != null &&
                            selectedEndDate != null)
                          GestureDetector(
                            onTap: _showAvailableDateSelector,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.modify(
                                      colorCode: AppColors.mainAppColor,
                                    ),
                                    Colors.white
                                        .modify(
                                          colorCode: AppColors.mainAppColor,
                                        )
                                        .withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white
                                        .modify(
                                          colorCode: AppColors.mainAppColor,
                                        )
                                        .withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Selected Date Range',
                                          style: GoogleFonts.inter(
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                formatDate(selectedStartDate!),
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                              child: Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                                size: 16.sp,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                formatDate(selectedEndDate!),
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.edit,
                                    color: Colors.white.withOpacity(0.9),
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (selectedStartDate != null &&
                            selectedEndDate != null)
                          const SizedBox(height: 18),
                        // ------------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SummaryCard(title: 'Income', amount: totalIncome),
                            SummaryCard(
                              title: 'Expenses',
                              amount: totalExpenses,
                            ),
                            SummaryCard(title: 'Savings', amount: totalSavings),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (!(onlyIncome || onlyExpenses))
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.modify(
                                    colorCode: AppColors.mainAppColor,
                                  ),
                                ),
                              ),
                              child: ToggleButtons(
                                borderRadius: BorderRadius.circular(8),
                                fillColor: Colors.white.modify(
                                  colorCode: AppColors.mainAppColor,
                                ),
                                selectedColor: Colors.white,
                                color: Colors.black87,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                isSelected: [
                                  selectedType == AnalysisType.income,
                                  selectedType == AnalysisType.expenses,
                                ],
                                onPressed: (index) {
                                  setState(() {
                                    selectedType = index == 0
                                        ? AnalysisType.income
                                        : AnalysisType.expenses;
                                  });
                                },
                                constraints: BoxConstraints(
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.37,
                                  minHeight: 50,
                                ),
                                borderWidth: 0,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Text('Income'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Text('Expenses'),
                                  ),
                                ], // no internal border
                              ),
                            ),
                          ),
                        if (!(onlyIncome || onlyExpenses))
                          const SizedBox(height: 20),
                        if (onlyIncome || onlyExpenses)
                          const SizedBox(height: 20),
                        Text(
                          typeToShow == AnalysisType.expenses
                              ? 'Expenses'
                              : 'Income',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: Colors.white.modify(
                              colorCode: AppColors.mainAppColor,
                            ),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // const SizedBox(height: 10),
                        // MonthlyBars(data: pieData),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 220,
                          child: PieChart(
                            PieChartData(
                              sections: List.generate(pieData.length, (index) {
                                final item = pieData[index];
                                final color =
                                    niceColors[index % niceColors.length];
                                final amount = item.amount.toDouble();
                                final percentage = totalAmount > 0
                                    ? (amount / totalAmount) * 100
                                    : 0.0;

                                return PieChartSectionData(
                                  color: color,
                                  value: percentage,
                                  title: '${percentage.toStringAsFixed(1)}%',
                                  titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  radius: 60,
                                );
                              }),
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Category',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.modify(
                              colorCode: AppColors.mainAppColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: List.generate(pieData.length, (index) {
                            final item = pieData[index];
                            final color = niceColors[index % niceColors.length];
                            final percentage = totalAmount > 0
                                ? (item.amount.toDouble() / totalAmount) * 100
                                : 0.0;

                            String? categoryType =
                                typeToShow == AnalysisType.expenses
                                ? "Expense"
                                : "Income";
                            String? icon = getCategoryIcon(
                              item.category,
                              type: categoryType,
                            );

                            Widget avatarChild = icon != null && icon.isNotEmpty
                                ? Text(
                                    icon,
                                    style: const TextStyle(fontSize: 18),
                                  )
                                : Text(
                                    item.category.isNotEmpty
                                        ? item.category[0]
                                        : "?",
                                    style: const TextStyle(fontSize: 18),
                                  );
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 26,
                                      backgroundColor: color.withOpacity(0.18),
                                      child: CircleAvatar(
                                        backgroundColor: color,
                                        child: avatarChild,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${item.category} (${item.transactions})',
                                            style: GoogleFonts.inter(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${percentage.toStringAsFixed(1)}% of ${typeToShow == AnalysisType.expenses ? 'expenses' : 'income'}",
                                            style: GoogleFonts.inter(
                                              color: Colors.grey[600],
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "\$${item.amount.toStringAsFixed(2)}",
                                      style: GoogleFonts.inter(
                                        color: color,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
