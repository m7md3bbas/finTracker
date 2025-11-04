import 'package:finance_track/core/models/notification_model.dart';
import 'package:finance_track/core/supabase/notifications/local.dart';
import 'package:finance_track/features/notifications/data/notification_remote_data.dart';
import 'package:finance_track/features/notifications/logic/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit()
    : super(NotificationState(status: NotificationStatus.initial));

  final NotificationRemoteData notificationRemoteData =
      NotificationRemoteData();

  Future<void> getNotifications() async {
    try {
      emit(state.copyWith(status: NotificationStatus.loading));
      final notifications = await notificationRemoteData.getNotifications();
      emit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: NotificationStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      emit(state.copyWith(status: NotificationStatus.loading));
      await notificationRemoteData.deleteNotification(id);
      final notifications = await notificationRemoteData.getNotifications();
      emit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: NotificationStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    try {
      emit(state.copyWith(status: NotificationStatus.loading));
      await notificationRemoteData.addNotification(notification);
      final notifications = await notificationRemoteData.getNotifications();
      emit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: NotificationStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> markNotificationAsRead(String id) async {
    try {
      emit(state.copyWith(status: NotificationStatus.loading));
      await notificationRemoteData.markNotificationAsRead(id);
      final notifications = await notificationRemoteData.getNotifications();
      emit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: NotificationStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> markNotificationAsUnread(String id) async {
    try {
      emit(state.copyWith(status: NotificationStatus.loading));
      await notificationRemoteData.markNotificationAsUnread(id);
      final notifications = await notificationRemoteData.getNotifications();
      emit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: NotificationStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      emit(state.copyWith(status: NotificationStatus.loading));
      await notificationRemoteData.markAllNotificationsAsRead();
      final notifications = await notificationRemoteData.getNotifications();
      emit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: NotificationStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      emit(state.copyWith(status: NotificationStatus.loading));
      await notificationRemoteData.deleteAllNotifications();
      final notifications = await notificationRemoteData.getNotifications();
      emit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: NotificationStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  void markAllNotificationsAsUnread() async {
    try {
      emit(state.copyWith(status: NotificationStatus.loading));
      await notificationRemoteData.markAllNotificationsAsUnread();
      final notifications = await notificationRemoteData.getNotifications();
      emit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: NotificationStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }
}
