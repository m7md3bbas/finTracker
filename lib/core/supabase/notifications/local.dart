import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  LocalNotifications._();
  static final LocalNotifications _instance = LocalNotifications._();
  factory LocalNotifications() => _instance;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  //initialization settings for android
  final initializationSettingsAndroid = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  //android channel settings for android
  final _androidChannle = AndroidNotificationChannel(
    dotenv.env['ANDROID_CHANNEL_ID'] ?? 'high_importance_channel',
    dotenv.env['ANDROID_CHANNEL_NAME'] ?? 'High Importance Notifications',
    importance: Importance.max,
    description:
        dotenv.env['NOTIFICATION_CHANNEL_DESCRIPTION'] ??
        'This channel is used for important notifications.',
    playSound: true,
  );

  bool _isFlutterLocalNotificationsPlugin = false;
  int _id = 0;

  //initialization local notifications
  Future<void> init() async {
    //check if the plugin is already initialized
    if (_isFlutterLocalNotificationsPlugin) return;
    //get full instance
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    //initialize the settings for android
    final initializeSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    //initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializeSettings,
      onDidReceiveNotificationResponse: (details) => {
        print('onDidReceiveNotificationResponse'),
      },
    );

    //create android channel if it does not exist
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannle);

    _isFlutterLocalNotificationsPlugin = true;
  }

  //show notification
  Future<void> showNotification({
    String? payload,
    String? title,
    String? body,
  }) async {
    //
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          _androidChannle.id,
          _androidChannle.name,
          channelDescription: _androidChannle.description,
          importance: Importance.max,
          priority: Priority.high,
        );

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await _flutterLocalNotificationsPlugin.show(
      _id++,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
