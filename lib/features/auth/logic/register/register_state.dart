enum RegisterStatus { initial, loading, success, error }

extension RegisterStatusX on RegisterStatus {
  bool get isInitial => this == RegisterStatus.initial;
  bool get isLoading => this == RegisterStatus.loading;
  bool get isSuccess => this == RegisterStatus.success;
  bool get isError => this == RegisterStatus.error;
}

class RegisterState {
  final RegisterStatus status;
  final String? message;
  const RegisterState({this.status = RegisterStatus.initial, this.message});

  RegisterState copyWith({RegisterStatus? status, String? message}) =>
      RegisterState(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  @override
  String toString() => 'RegisterState(status: $status, message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegisterState &&
        other.status == status &&
        other.message == message;
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode;
}
