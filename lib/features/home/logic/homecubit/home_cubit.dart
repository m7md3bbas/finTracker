import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_track/core/models/transactions_model.dart';
import 'package:finance_track/core/models/getmonthlysummary_model.dart';
import 'package:finance_track/features/home/data/home_remote_date.dart';
import 'package:finance_track/features/home/logic/homecubit/home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  final HomeRemoteData remoteData = HomeRemoteData();

  Future<void> getHomeData({
    required String userId,
    required DateTime selectedMonth,
  }) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
      final endOfMonth = DateTime(
        selectedMonth.year,
        selectedMonth.month + 1,
        0,
      );

      final results = await Future.wait([
        remoteData.getTransactions(
          userId: userId,
          startDate: startOfMonth,
          endDate: endOfMonth,
        ),
        remoteData.getMonthlySummary(
          userId: userId,
          startDate: startOfMonth,
          endDate: endOfMonth,
        ),
      ]);

      final transactions = results[0] as List<TransactionModel>;
      final summary = results[1] as MonthlySummary;
      emit(
        state.copyWith(
          status: HomeStatus.success,
          transactions: transactions,
          summary: summary,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error, message: e.toString()));
    }
  }
}
