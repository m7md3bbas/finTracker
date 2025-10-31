enum OnboardingStatus { initial, loading, success, error }

extension OnboardingStatusX on OnboardingStatus {
  bool get isInitial => this == OnboardingStatus.initial;
  bool get isLoading => this == OnboardingStatus.loading;
  bool get isSuccess => this == OnboardingStatus.success;
  bool get isError => this == OnboardingStatus.error;
}

class OnboardingState {
  final OnboardingStatus status;

  final String? message;

  OnboardingState({required this.status, this.message});

  OnboardingState copyWith({OnboardingStatus? status, String? message}) =>
      OnboardingState(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  @override
  String toString() => 'OnboardingState(status: $status, message: $message)';
}
