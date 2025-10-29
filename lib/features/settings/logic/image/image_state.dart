enum ImageStatus { initial, loading, success, error }

extension ImageStatusX on ImageStatus {
  bool get isInitial => this == ImageStatus.initial;
  bool get isLoading => this == ImageStatus.loading;
  bool get isSuccess => this == ImageStatus.success;
  bool get isError => this == ImageStatus.error;
}

class ImageState {
  final ImageStatus status;
  final String? message;
  final String? imageUrl;

  ImageState({required this.status, this.imageUrl, this.message});

  ImageState copyWith({
    ImageStatus? status,
    String? imageUrl,
    String? message,
  }) {
    return ImageState(
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      message: message ?? this.message,
    );
  }

  @override
  String toString() =>
      'ImageState(status: $status, imageUrl: $imageUrl, message: $message)';
}
