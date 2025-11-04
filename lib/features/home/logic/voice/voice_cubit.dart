import 'package:bloc/bloc.dart';
import 'package:finance_track/core/utils/helper/gemini_service/gemini_service.dart';
import 'package:finance_track/features/home/logic/voice/voice_state.dart';

class VoiceCubit extends Cubit<VoiceState> {
  VoiceCubit() : super(VoiceState(status: VoiceStatus.initial));
  final GeminiService geminiService = GeminiService();
  Future<void> getVoiceResult(String text) async {
    emit(state.copyWith(status: VoiceStatus.loading));
    try {
      final result = await geminiService.generateText(text);
      emit(state.copyWith(status: VoiceStatus.success, text: result!));
    } catch (e) {
      emit(state.copyWith(status: VoiceStatus.error, message: e.toString()));
    }
  }
}
