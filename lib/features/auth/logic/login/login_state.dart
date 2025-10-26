enum AuthStatus { initial, loading, success, error }

extension AuthStatusX on AuthStatus {
  bool get isInitial => this == AuthStatus.initial;
  bool get isLoading => this == AuthStatus.loading;
  bool get isSuccess => this == AuthStatus.success;
  bool get isError => this == AuthStatus.error;
}

class LoginState {
  final AuthStatus status;
  final String? message;
  const LoginState({this.status = AuthStatus.initial, this.message});

  LoginState copyWith({AuthStatus? status, String? message}) => LoginState(
    status: status ?? this.status,
    message: message ?? this.message,
  );

  @override
  String toString() => 'LoginState(status: $status, message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginState &&
        other.status == status &&
        other.message == message;
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode;
}
