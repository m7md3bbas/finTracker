import 'dart:ui';
import 'package:finance_track/app.dart';
import 'package:finance_track/core/supabase/notifications/fcm.dart';
import 'package:finance_track/core/supabase/notifications/local.dart';
import 'package:finance_track/core/supabase/supabase_init.dart';
import 'package:finance_track/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SupabaseInit.init();
  final localNotifications = LocalNotifications();
  localNotifications.init();

  FlutterError.onError = (errorDetails) async {
    await FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  await FcmService.instance.initFCM(localNotifications: localNotifications);

  runApp(FinTracker());
}
