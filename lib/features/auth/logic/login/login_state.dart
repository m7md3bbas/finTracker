enum LoginStatus {
  initial,
  loading,
  success,
  error,
  googleLoading,
  googleSuccess,
  googleError,
}

extension LoginStatusX on LoginStatus {
  bool get isInitial => this == LoginStatus.initial;
  bool get isLoading => this == LoginStatus.loading;
  bool get isSuccess => this == LoginStatus.success;
  bool get isError => this == LoginStatus.error;
  bool get isGoogleLoading => this == LoginStatus.googleLoading;
  bool get isGoogleSuccess => this == LoginStatus.googleSuccess;
  bool get isGoogleError => this == LoginStatus.googleError;
}

class LoginState {
  final LoginStatus status;
  final String? message;
  const LoginState({this.status = LoginStatus.initial, this.message});

  LoginState copyWith({LoginStatus? status, String? message}) => LoginState(
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
