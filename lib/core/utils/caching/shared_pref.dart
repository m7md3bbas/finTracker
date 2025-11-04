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

  Future<void> saveBudgetNotificationDate(String monthYear) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'budget_notification_date${supabaseClient.auth.currentUser!.id}',
      monthYear,
    );
  }

  Future<String?> getBudgetNotificationDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'budget_notification_date${supabaseClient.auth.currentUser!.id}',
    );
  }

  Future<void> saveNotificationDate(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'notif_$key${supabaseClient.auth.currentUser!.id}',
      value,
    );
  }

  Future<String?> getNotificationDate(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('notif_$key${supabaseClient.auth.currentUser!.id}');
  }

  Future<void> saveThemeMode(String mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'theme_mode${supabaseClient.auth.currentUser!.id}',
      mode,
    );
  }

  Future<String?> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('theme_mode');
  }

  Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
