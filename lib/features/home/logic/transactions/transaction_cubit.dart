import 'package:finance_track/core/models/transactions_model.dart';
import 'package:finance_track/features/home/data/home_remote_date.dart';
import 'package:finance_track/features/home/logic/transactions/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit()
    : super(TransactionState(status: Transactionstatus.initial));

  final remoteData = HomeRemoteData();

  Future<void> addTransaction(TransactionModel transaction) async {
    emit(state.copyWith(status: Transactionstatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 2), () async {
        await remoteData.addTransaction(transaction);
      });
      emit(
        state.copyWith(
          status: Transactionstatus.success,
          message: "Transaction added successfully",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: Transactionstatus.error, message: e.toString()),
      );
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    emit(state.copyWith(status: Transactionstatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 2), () async {
        await remoteData.updateTransaction(transaction);
      });
      emit(
        state.copyWith(
          status: Transactionstatus.success,
          message: "Transaction updated successfully",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: Transactionstatus.error, message: e.toString()),
      );
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    emit(state.copyWith(status: Transactionstatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 2), () async {
        await remoteData.deleteTransaction(transactionId);
      });
      emit(
        state.copyWith(
          status: Transactionstatus.success,
          message: "Transaction deleted successfully",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: Transactionstatus.error, message: e.toString()),
      );
    }
  }
}
