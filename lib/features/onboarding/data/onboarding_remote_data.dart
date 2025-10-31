import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingRemoteData {
  final supabaseClient = Supabase.instance.client;

  Future<void> saveSpeakingLangAndStarterMonthly({
    required String lang,
    required String month,
  }) async {
    try {
      await supabaseClient.auth.updateUser(
        UserAttributes(data: {'lang': lang, 'starter_month': month}),
      );
    } catch (e) {
      throw e.toString();
    }
  }
}
