class CategoryBreakdown {
  final String category;
  final double amount;

  CategoryBreakdown({required this.category, required this.amount});

  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdown(
      category: json['category'] ?? "Other",
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class AnalysisModel {
  final double? totalIncome;
  final double? totalExpenses;
  final double? totalSavings;
  final double? totalBudget;
  final List<CategoryBreakdown>? incomeCategoryBreakdown;
  final List<CategoryBreakdown>? expenseCategoryBreakdown;

  AnalysisModel({
    this.totalIncome,
    this.totalExpenses,
    this.totalSavings,
    this.totalBudget,
    this.incomeCategoryBreakdown,
    this.expenseCategoryBreakdown,
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      totalIncome: (json['total_income'] as num?)?.toDouble(),
      totalExpenses: (json['total_expenses'] as num?)?.toDouble(),
      totalSavings: (json['total_savings'] as num?)?.toDouble(),
      totalBudget: (json['total_budget'] as num?)?.toDouble(),
      incomeCategoryBreakdown: (json['income_breakdown'] as List<dynamic>?)
          ?.map((e) => CategoryBreakdown.fromJson(e))
          .toList(),
      expenseCategoryBreakdown: (json['expense_breakdown'] as List<dynamic>?)
          ?.map((e) => CategoryBreakdown.fromJson(e))
          .toList(),
    );
  }
}
