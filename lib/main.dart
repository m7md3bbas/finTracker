import 'package:finance_track/app.dart';
import 'package:finance_track/core/supabase/supabase_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SupabaseInit.init();
  runApp(const FinTracker());
}
