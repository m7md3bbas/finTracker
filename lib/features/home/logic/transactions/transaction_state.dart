import 'package:finance_track/core/models/transactions_model.dart';
import 'package:flutter/foundation.dart';

enum Transactionstatus { initial, loading, success, error }

extension TransactionstatusX on Transactionstatus {
  bool get isInitial => this == Transactionstatus.initial;
  bool get isLoading => this == Transactionstatus.loading;
  bool get isSuccess => this == Transactionstatus.success;
  bool get isError => this == Transactionstatus.error;
}

class TransactionState {
  final Transactionstatus status;
  final List<TransactionModel> transactions;
  final String? message;
  TransactionState({
    this.status = Transactionstatus.initial,
    this.message,
    this.transactions = const [],
  });

  TransactionState copyWith({
    Transactionstatus? status,
    String? message,
    List<TransactionModel>? transactions,
  }) {
    return TransactionState(
      status: status ?? this.status,
      message: message ?? this.message,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  String toString() =>
      'TransactionState(status: $status, message: $message, transactions: ${transactions.length})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionState &&
        other.status == status &&
        other.message == message &&
        listEquals(other.transactions, transactions);
  }

  @override
  int get hashCode =>
      status.hashCode ^ message.hashCode ^ transactions.hashCode;
}
