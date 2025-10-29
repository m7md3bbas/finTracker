import 'dart:io';

import 'package:finance_track/core/utils/caching/shared_pref.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingRemoteData {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<String?> getImage() async {
    try {
      final response = await supabaseClient
          .from('users')
          .select('profile_photo')
          .eq('id', supabaseClient.auth.currentUser!.id)
          .single();

      return response['profile_photo'];
    } catch (e) {
      return null;
    }
  }

  Future<void> uploadImage({required File img}) async {
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
    final userId = supabaseClient.auth.currentUser!.id;
    final filePath = '$userId/$fileName';

    try {
      await supabaseClient.storage
          .from('profile_images')
          .upload(
            filePath,
            img,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );
    } catch (e) {
      throw "Failed to upload image to storage";
    }

    try {
      final imageUrl = supabaseClient.storage
          .from('profile_images')
          .getPublicUrl(filePath);

      print(imageUrl);

      await supabaseClient.auth
          .updateUser(UserAttributes(data: {'profile_photo': imageUrl}))
          .then((value) {
            SharedPref().saveProfilePicture(imageUrl);
          });
    } catch (e) {
      throw "Failed to upload image to database";
    }
  }
}
