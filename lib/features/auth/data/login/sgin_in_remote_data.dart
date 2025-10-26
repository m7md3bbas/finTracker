import 'package:supabase_flutter/supabase_flutter.dart';

class SginInRemoteData {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<void> signIn({required String email, required String password}) async {
    try {
      await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw e.message;
    } catch (_) {
      throw 'Failed to sign in';
    }
  }
}
