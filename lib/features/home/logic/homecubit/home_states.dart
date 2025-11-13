import 'package:finance_track/core/models/transactions_model.dart';
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

  // 👇 Pagination fields

  const HomeState({
    this.status = HomeStatus.initial,
    this.message,
    this.transactions = const [],
    this.summary = const MonthlySummary(
      totalIncome: 0,
      totalExpense: 0,
      totalBalance: 0,
      monthlyBudget: 0,
      remainingBudget: 0,
    ),
  });

  HomeState copyWith({
    HomeStatus? status,
    String? message,
    List<TransactionModel>? transactions,
    MonthlySummary? summary,
    int? currentPage,
    bool? hasMore,
    int? limit,
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
      'HomeState(status: $status, message: $message, transactions: ${transactions.length},)';
}
