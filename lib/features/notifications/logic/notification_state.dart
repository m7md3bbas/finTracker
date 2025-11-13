import 'package:finance_track/core/models/notification_model.dart';

enum NotificationStatus { initial, loading, success, error }

extension NotificationStatusX on NotificationStatus {
  bool get isInitial => this == NotificationStatus.initial;
  bool get isLoading => this == NotificationStatus.loading;
  bool get isSuccess => this == NotificationStatus.success;
  bool get isError => this == NotificationStatus.error;
}

class NotificationState {
  final NotificationStatus status;
  final List<NotificationModel>? notifications;
  final String? errorMessage;

  NotificationState({
    required this.status,
    this.notifications,
    this.errorMessage,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationModel>? notifications,
    String? errorMessage,
  }) => NotificationState(
    status: status ?? this.status,
    notifications: notifications ?? this.notifications,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  String toString() =>
      'NotificationState(status: $status, notifications: $notifications, errorMessage: $errorMessage)';
}
