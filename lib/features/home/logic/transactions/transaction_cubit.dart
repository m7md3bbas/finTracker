import 'package:finance_track/core/models/transactions_model.dart';
import 'package:finance_track/core/utils/network/internet_connection.dart';
import 'package:finance_track/features/home/data/home_remote_date.dart';
import 'package:finance_track/features/home/logic/transactions/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit()
    : super(TransactionState(status: TransactionStatus.initial));

  final remoteData = HomeRemoteData();
  final NetworkInfo networkInfo = NetworkInfo();

  Future<void> addTransaction(TransactionModel transaction) async {
    emit(state.copyWith(status: TransactionStatus.loading));
    try {
      // Check internet connection before making API call
      if (!await networkInfo.isConnected()) {
        throw NoInternetException();
      }
      await Future.delayed(const Duration(seconds: 2), () async {
        await remoteData.addTransaction(transaction);
      });
      emit(
        state.copyWith(
          status: TransactionStatus.success,
          message: "Transaction added successfully",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: TransactionStatus.error, message: e.toString()),
      );
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    emit(state.copyWith(status: TransactionStatus.loading));
    try {
      if (!await networkInfo.isConnected()) {
        throw NoInternetException();
      }
      await Future.delayed(const Duration(seconds: 2), () async {
        await remoteData.updateTransaction(transaction);
      });
      emit(
        state.copyWith(
          status: TransactionStatus.success,
          message: "Transaction updated successfully",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: TransactionStatus.error, message: e.toString()),
      );
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    emit(state.copyWith(status: TransactionStatus.loading));
    try {
      if (!await networkInfo.isConnected()) {
        throw NoInternetException();
      }
      await Future.delayed(const Duration(seconds: 2), () async {
        await remoteData.deleteTransaction(transactionId);
      });
      emit(
        state.copyWith(
          status: TransactionStatus.success,
          message: "Transaction deleted successfully",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: TransactionStatus.error, message: e.toString()),
      );
    }
  }
}
