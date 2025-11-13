import 'package:finance_track/core/utils/network/internet_connection.dart';
import 'package:finance_track/features/auth/data/register/sign_up_remote_data.dart';
import 'package:finance_track/features/auth/logic/register/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState(status: RegisterStatus.initial));
  final SignUpRemoteData remoteData = SignUpRemoteData();
  final NetworkInfo networkInfo = NetworkInfo();

  void register({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      // Check internet connection before making API call
      if (!await networkInfo.isConnected()) {
        throw NoInternetException();
      }
      await Future.delayed(const Duration(seconds: 2), () async {
        await remoteData.signUp(email: email, password: password, name: name);
      });
      emit(state.copyWith(status: RegisterStatus.success));
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(status: RegisterStatus.error, message: e.toString()),
        );
      }
    }
  }
}
