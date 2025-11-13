import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInRemoteData {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<void> signIn({required String email, required String password}) async {
    try {
      await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      print(e.message);
      throw e.message;
    } catch (_) {
      throw 'Failed to sign in';
    }
  }

  Future<void> loginWithGoogle() async {
    GoogleSignInAccount? googleUser;

    final webClientId = dotenv.env['GoogleClintID']!;
    if (webClientId.isEmpty) throw 'GoogleClintID is empty';

    const iosClientId = 'my-ios.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw 'Google Sign In was cancelled';
    }
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    try {
      await supabaseClient.auth
          .signInWithIdToken(
            provider: OAuthProvider.google,
            idToken: idToken,
            accessToken: accessToken,
          )
          .then((value) async {
            await supabaseClient.auth.updateUser(
              UserAttributes(
                data: {'profile_photo': googleUser?.photoUrl ?? ''},
              ),
            );
          });
    } on AuthException catch (e) {
      throw "Failed to sign in with Google: ${e.message}";
    }
  }

  Future<void> signOut() async => await supabaseClient.auth.signOut();
}
