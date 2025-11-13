import 'package:finance_track/core/models/budget_model.dart';
import 'package:finance_track/core/utils/network/internet_connection.dart';
import 'package:finance_track/features/auth/data/user_remote_date.dart';
import 'package:finance_track/features/auth/logic/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState(status: UserStatus.initial));
  final remoteData = UserRemoteDate();
  final NetworkInfo networkInfo = NetworkInfo();

  get user => remoteData.user;

  Future<void> signOut() async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      await remoteData.signOut();
      emit(state.copyWith(status: UserStatus.success));
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(status: UserStatus.error, message: e.toString()));
      }
    }
  }

  void loadUserData() async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final user = remoteData.user;
      emit(state.copyWith(status: UserStatus.success, user: user));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.error, message: e.toString()));
    }
  }

  void addBudget({required BudgetModel budget}) async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      if (!await networkInfo.isConnected()) {
        throw NoInternetException();
      }
      await remoteData.addBudget(budget);
      emit(state.copyWith(status: UserStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.error, message: e.toString()));
    }
  }

  void updateBudget({required BudgetModel budget}) async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      // Check internet connection before making API call
      if (!await networkInfo.isConnected()) {
        throw NoInternetException();
      }
      await remoteData.updateBudget(budget);
      emit(state.copyWith(status: UserStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.error, message: e.toString()));
    }
  }

  void deleteBudget({required String budgetId}) async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      // Check internet connection before making API call
      if (!await networkInfo.isConnected()) {
        throw NoInternetException();
      }
      await remoteData.deleteBudget(budgetId);
      emit(state.copyWith(status: UserStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.error, message: e.toString()));
    }
  }
}
