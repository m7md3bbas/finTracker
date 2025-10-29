import 'package:supabase_flutter/supabase_flutter.dart';

class SignInRemoteData {
  final SupabaseClient supabaseClient = Supabase.instance.client;
  get user => supabaseClient.auth.currentUser;
  Future<String?> get userImage async {
    final response = await supabaseClient
        .from('users')
        .select('profile_photo')
        .eq('id', user.id)
        .single();

    return response['profile_photo'] as String?;
  }

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

  Future<void> signOut() async => await supabaseClient.auth.signOut();
}
