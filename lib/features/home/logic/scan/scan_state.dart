import 'package:equatable/equatable.dart';
import 'package:finance_track/core/models/transactions_model.dart';

enum ScanStatus { initial, loading, success, error }

extension ScanStatusX on ScanStatus {
  bool get isInitial => this == ScanStatus.initial;
  bool get isLoading => this == ScanStatus.loading;
  bool get isSuccess => this == ScanStatus.success;
  bool get isError => this == ScanStatus.error;
}

class ScanState extends Equatable {
  final ScanStatus status;
  final TransactionModel? text;
  final String? message;

  const ScanState({this.status = ScanStatus.initial, this.text, this.message});

  ScanState copyWith({
    ScanStatus? status,
    TransactionModel? text,
    String? message,
  }) {
    return ScanState(
      status: status ?? this.status,
      text: text ?? this.text,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, text, message];
}
