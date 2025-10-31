import 'package:finance_track/core/utils/network/internet_connection.dart';
import 'package:finance_track/features/analysis/data/analysisi_remote_data.dart';
import 'package:finance_track/features/analysis/logic/analysis_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  AnalysisCubit() : super(AnalysisState(status: AnalysisStatus.initial));

  final AnalysisService _analysisService = AnalysisService();
  final NetworkInfo networkInfo = NetworkInfo();

  Future<void> getUserAnalysis({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    emit(state.copyWith(status: AnalysisStatus.loading));
    try {
      // Check internet connection before making API call
      if (!await networkInfo.isConnected()) {
        throw NoInternetException();
      }
      final analysis = await _analysisService.getUserAnalysis(
        startDate: startDate,
        endDate: endDate,
      );
      emit(state.copyWith(status: AnalysisStatus.success, analysis: analysis));
    } catch (e) {
      emit(
        state.copyWith(status: AnalysisStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> getAvailableTransactionDates() async {
    emit(state.copyWith(status: AnalysisStatus.loading));
    try {
      // Check internet connection before making API call
      if (!await networkInfo.isConnected()) {
        throw NoInternetException();
      }
      final response = await _analysisService.getAvailableDates();
      emit(
        state.copyWith(
          status: AnalysisStatus.success,
          availableDates: response,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AnalysisStatus.failure, message: e.toString()),
      );
    }
  }
}
