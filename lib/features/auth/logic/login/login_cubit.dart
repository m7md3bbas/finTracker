import 'package:finance_track/features/auth/data/login/sgin_in_remote_data.dart';
import 'package:finance_track/features/auth/logic/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState(status: AuthStatus.initial));
  final SginInRemoteData remoteData = SginInRemoteData();
  void signIn({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 2), () async {
        await remoteData.signIn(email: email, password: password);
      });
      emit(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, message: e.toString()));
    }
  }
}
