import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class SaveUserToken {
  static Future<void> saveToken(String token) async {
    log('token: $token');
    final supabase = Supabase.instance.client;

    try {
      await supabase.auth.updateUser(
        UserAttributes(data: {'fcm_token': token}),
      );
    } on AuthApiException catch (e) {
      if (e.message.contains('token is expired')) {
        await supabase.auth.refreshSession();
        await supabase.auth.updateUser(
          UserAttributes(data: {'fcm_token': token}),
        );
      } else {}
    }
  }
}
