import 'package:supabase_flutter/supabase_flutter.dart';

enum UserStatus { initial, loading, success, error }

extension UserStatusX on UserStatus {
  bool get isInitial => this == UserStatus.initial;
  bool get isLoading => this == UserStatus.loading;
  bool get isSuccess => this == UserStatus.success;
  bool get isError => this == UserStatus.error;
}

class UserState {
  final UserStatus status;
  final User? user;
  final String? message;
  UserState({required this.status, this.user, this.message});

  UserState copyWith({UserStatus? status, User? user, String? message}) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  String toString() =>
      'UserState(status: $status, user: $user, message: $message)';
}
