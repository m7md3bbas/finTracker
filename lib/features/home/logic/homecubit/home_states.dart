import 'package:finance_track/core/models/transactions_model.dart';
import 'package:finance_track/core/models/category_model.dart';
import 'package:finance_track/core/models/getmonthlysummary_model.dart';

enum HomeStatus { initial, loading, success, error }

extension HomeStatusX on HomeStatus {
  bool get isInitial => this == HomeStatus.initial;
  bool get isLoading => this == HomeStatus.loading;
  bool get isSuccess => this == HomeStatus.success;
  bool get isError => this == HomeStatus.error;
}

class HomeState {
  final HomeStatus status;
  final String? message;
  final List<TransactionModel> transactions;
  final MonthlySummary summary;

  const HomeState({
    this.status = HomeStatus.initial,
    this.message,
    this.transactions = const [],
    this.summary = const MonthlySummary(
      totalIncome: 0,
      totalExpense: 0,
      totalBalance: 0,
    ),
  });

  HomeState copyWith({
    HomeStatus? status,
    String? message,
    List<TransactionModel>? transactions,
    MonthlySummary? summary,
  }) {
    return HomeState(
      status: status ?? this.status,
      message: message ?? this.message,
      transactions: transactions ?? this.transactions,
      summary: summary ?? this.summary,
    );
  }

  @override
  String toString() =>
      'HomeState(status: $status, message: $message, transactions: ${transactions.length}, summary: $summary)';
}
