import 'package:finance_track/core/models/analysis_model.dart';

enum AnalysisStatus { initial, loading, success, failure }

extension AnalysisStatusX on AnalysisStatus {
  bool get isInitial => this == AnalysisStatus.initial;
  bool get isLoading => this == AnalysisStatus.loading;
  bool get isSuccess => this == AnalysisStatus.success;
  bool get isError => this == AnalysisStatus.failure;
}

class AnalysisState {
  final AnalysisStatus status;
  final AnalysisModel? analysis;
  final List<DateTime>? availableDates;
  final String? message;
  AnalysisState({
    required this.status,
    this.message,
    this.analysis,
    this.availableDates,
  });

  AnalysisState copyWith({
    AnalysisStatus? status,
    AnalysisModel? analysis,
    List<DateTime>? availableDates,
    String? message,
  }) => AnalysisState(
    status: status ?? this.status,
    analysis: analysis ?? this.analysis,
    availableDates: availableDates ?? this.availableDates,
    message: message ?? this.message,
  );

  @override
  String toString() =>
      'AnalysisState(status: $status, message: $message, analysis: $analysis) availableDates: $availableDates';
}
