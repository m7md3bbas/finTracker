import 'package:finance_track/features/onboarding/data/onboarding_remote_data.dart';
import 'package:finance_track/features/onboarding/logic/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState(status: OnboardingStatus.initial));

  final remoteData = OnboardingRemoteData();

  void saveSpeakingLangAndStarterMonthly({
    required String lang,
    required String month,
  }) async {
    emit(state.copyWith(status: OnboardingStatus.loading));
    try {
      await remoteData.saveSpeakingLangAndStarterMonthly(
        lang: lang,
        month: month,
      );
      emit(
        state.copyWith(
          status: OnboardingStatus.success,
          message: "Data saved successfully",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: OnboardingStatus.error, message: e.toString()),
      );
    }
  }
}
