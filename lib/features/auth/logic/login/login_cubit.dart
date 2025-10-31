import 'package:finance_track/core/utils/network/internet_connection.dart';
import 'package:finance_track/features/auth/data/login/sign_in_remote_data.dart';
import 'package:finance_track/features/auth/logic/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState(status: LoginStatus.initial));
  final SignInRemoteData remoteData = SignInRemoteData();
  final NetworkInfo networkInfo = NetworkInfo();

  void signIn({required String email, required String password}) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      // Check internet connection before making API call
      if (!await networkInfo.isConnected()) {
        throw NoInternetException();
      }
      await Future.delayed(const Duration(seconds: 2), () async {
        await remoteData.signIn(email: email, password: password);
      });
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error, message: e.toString()));
    }
  }
}
