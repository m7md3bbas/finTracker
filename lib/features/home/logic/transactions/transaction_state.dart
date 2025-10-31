import 'package:finance_track/core/models/transactions_model.dart';
import 'package:flutter/foundation.dart';

enum TransactionStatus { initial, loading, success, error }

extension TransactionStatusX on TransactionStatus {
  bool get isInitial => this == TransactionStatus.initial;
  bool get isLoading => this == TransactionStatus.loading;
  bool get isSuccess => this == TransactionStatus.success;
  bool get isError => this == TransactionStatus.error;
}

class TransactionState {
  final TransactionStatus status;
  final List<TransactionModel> transactions;
  final String? message;
  TransactionState({
    this.status = TransactionStatus.initial,
    this.message,
    this.transactions = const [],
  });

  TransactionState copyWith({
    TransactionStatus? status,
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
