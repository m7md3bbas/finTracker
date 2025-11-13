import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpRemoteData {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
    } on AuthException catch (e) {
      throw e.message;
    } catch (_) {
      throw 'Failed to sign up';
    }
  }
}
