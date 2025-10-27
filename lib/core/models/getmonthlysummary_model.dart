import 'package:equatable/equatable.dart';

class MonthlySummary extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double totalBalance;

  const MonthlySummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.totalBalance,
  });

  factory MonthlySummary.fromMap(Map<String, dynamic> map) {
    return MonthlySummary(
      totalIncome: (map['total_income'] ?? 0).toDouble(),
      totalExpense: (map['total_expense'] ?? 0).toDouble(),
      totalBalance: (map['total_balance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_income': totalIncome,
      'total_expense': totalExpense,
      'total_balance': totalBalance,
    };
  }

  @override
  List<Object?> get props => [totalIncome, totalExpense, totalBalance];
}
