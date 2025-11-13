import 'package:finance_track/core/supabase/notifications/local.dart';
import 'package:finance_track/core/utils/caching/save_user_token.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FcmService {
  FcmService._();
  static final FcmService _instance = FcmService._();
  static FcmService get instance => _instance;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  LocalNotifications? _localNotifications;

  Future<void> initFCM({required LocalNotifications localNotifications}) async {
    _localNotifications = localNotifications;

    _requestNotificationPermission();

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOnMessageOpenApp);

    final initialMessage = await firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleOnMessageOpenApp(initialMessage);
    }

    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    await registerUserFcmToken();
  }

  Future<void> registerUserFcmToken() async {
    try {
      final token = await firebaseMessaging.getToken();
      if (token != null) {
        await SaveUserToken.saveToken(token);
      }

      firebaseMessaging.onTokenRefresh.listen((newToken) async {
        await SaveUserToken.saveToken(newToken);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _handleOnMessageOpenApp(RemoteMessage message) {
    final notificationData = message.notification;
    if (notificationData != null) {
      _localNotifications?.showNotification(
        title: notificationData.title,
        body: notificationData.body,
      );
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notificationData = message.notification;
    if (notificationData != null) {
      _localNotifications?.showNotification(
        title: notificationData.title,
        body: notificationData.body,
      );
    }
  }

  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    final notificationData = message.notification;
    if (notificationData != null) {
      LocalNotifications().showNotification(
        title: notificationData.title,
        body: notificationData.body,
      );
    }
  }

  void _requestNotificationPermission() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
