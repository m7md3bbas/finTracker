import 'package:finance_track/core/models/transactions_model.dart';

enum VoiceStatus { initial, loading, success, error }

extension VoiceStatusX on VoiceStatus {
  bool get isInitial => this == VoiceStatus.initial;
  bool get isLoading => this == VoiceStatus.loading;
  bool get isSuccess => this == VoiceStatus.success;
  bool get isError => this == VoiceStatus.error;
}

class VoiceState {
  final VoiceStatus status;
  final TransactionModel? text;
  final String? message;

  VoiceState({required this.status, this.text, this.message});

  VoiceState copyWith({
    VoiceStatus? status,
    TransactionModel? text,
    String? message,
  }) {
    return VoiceState(
      status: status ?? this.status,
      text: text ?? this.text,
      message: message ?? this.message,
    );
  }
}
