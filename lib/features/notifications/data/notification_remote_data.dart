import 'package:finance_track/core/models/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRemoteData {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<NotificationModel>> getNotifications() async {
    final response = await supabase
        .from('notifications')
        .select()
        .eq('user_id', supabase.auth.currentUser?.id ?? '')
        .order('created_at', ascending: false)
        .limit(100);
    return response.map((e) => NotificationModel.fromJson(e)).toList();
  }

  Future<void> addNotification(NotificationModel notification) async =>
      await supabase.from('notifications').insert(notification.toJson());

  Future<void> deleteNotification(String id) async =>
      await supabase.from('notifications').delete().eq('id', id);
  Future<void> markNotificationAsRead(String id) async {
    await supabase.from('notifications').update({'is_read': true}).eq('id', id);
  }

  Future<void> markNotificationAsUnread(String id) async {
    await supabase
        .from('notifications')
        .update({'is_read': false})
        .eq('id', id);
  }

  Future<void> markAllNotificationsAsRead() async {
    await supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', supabase.auth.currentUser!.id);
  }

  Future<void> markAllNotificationsAsUnread() async {
    await supabase
        .from('notifications')
        .update({'is_read': false})
        .eq('user_id', supabase.auth.currentUser!.id);
  }

  Future<void> deleteAllNotifications() async {
    await supabase
        .from('notifications')
        .delete()
        .eq('user_id', supabase.auth.currentUser!.id);
  }
}
