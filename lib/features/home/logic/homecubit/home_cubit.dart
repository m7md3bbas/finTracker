import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_track/core/models/transactions_model.dart';
import 'package:finance_track/core/models/getmonthlysummary_model.dart';
import 'package:finance_track/core/utils/network/internet_connection.dart';
import 'package:finance_track/core/supabase/notifications/notification_manager.dart';
import 'package:finance_track/features/home/data/home_remote_date.dart';
import 'package:finance_track/features/home/logic/homecubit/home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  final HomeRemoteData remoteData = HomeRemoteData();
  final NetworkInfo networkInfo = NetworkInfo();
  final NotificationManager _notificationManager = NotificationManager.instance;

  Future<void> getHomeData({required DateTime selectedMonth}) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      if (!await networkInfo.isConnected()) {
        throw NoInternetException();
      }
      final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
      final endOfMonth = DateTime(
        selectedMonth.year,
        selectedMonth.month + 1,
        0,
      );

      final results = await Future.wait([
        remoteData.getTransactions(
          startDate: startOfMonth,
          endDate: endOfMonth,
        ),
        remoteData.getMonthlySummary(
          startDate: startOfMonth,
          endDate: endOfMonth,
        ),
      ]);

      final transactions = results[0] as List<TransactionModel>;
      final summary = results[1] as MonthlySummary;

      await _checkNotifications(summary, selectedMonth, transactions);

      emit(
        state.copyWith(
          status: HomeStatus.success,
          transactions: transactions,
          summary: summary,
        ),
      );
    } catch (e) {
      if (isClosed) {
        emit(state.copyWith(status: HomeStatus.error, message: e.toString()));
      }
    }
  }

  Future<void> _checkNotifications(
    MonthlySummary summary,
    DateTime selectedMonth,
    List<TransactionModel> transactions,
  ) async {
    await _notificationManager.checkBudgetOverrun(summary, selectedMonth);

    await _notificationManager.checkBudgetWarning(summary, selectedMonth);

    final todayExpenses = _notificationManager.calculateTodayExpenses(
      transactions,
    );
    await _notificationManager.sendDailySummary(todayExpenses, selectedMonth);
  }
}
