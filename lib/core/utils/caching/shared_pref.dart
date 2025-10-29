import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SharedPref {
  SupabaseClient supabaseClient = Supabase.instance.client;
  Future<void> saveSpeakLang(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang${supabaseClient.auth.currentUser!.id}', lang);
  }

  Future<String?> getSpeakLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lang${supabaseClient.auth.currentUser!.id}');
  }

  Future<void> saveStarterMonth(String month) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'starter_month${supabaseClient.auth.currentUser!.id}',
      month,
    );
  }

  Future<String?> getStarterMonth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'starter_month${supabaseClient.auth.currentUser!.id}',
    );
  }

  Future<void> saveProfilePicture(String imgurl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'image_url${supabaseClient.auth.currentUser!.id}',
      imgurl,
    );
  }

  Future<String?> getProfilePicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('image_url${supabaseClient.auth.currentUser!.id}');
  }

  Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
