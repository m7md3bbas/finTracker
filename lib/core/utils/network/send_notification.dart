import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> sendNotification({
  required String token,
  required String title,
  required String body,
}) async {
  try {
    final dio = Dio();
    final url = dotenv.env['SUPABASE_NOTIFICATION_URL']!;
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

    final response = await dio.post(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $supabaseAnonKey',
          'Content-Type': 'application/json',
        },
      ),
      data: {'token': token, 'title': title, 'body': body},
    );

    print("Notification sent successfully: ${response.data}");
  } on DioException catch (e) {
    print('Dio Error: ${e.response?.data ?? e.message}');
  } catch (e) {
    print('Unexpected Error: $e');
  }
}
