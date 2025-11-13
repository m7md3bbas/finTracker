import 'dart:convert';

class NotificationModel {
  final String? id;
  final String userId;
  final String title;
  final String message;
  final String? type;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? scheduledFor;
  final Map<String, dynamic>? metaData;

  NotificationModel({
    this.id,
    required this.userId,
    required this.title,
    required this.message,
    this.type,
    this.isRead = false,
    required this.createdAt,
    this.scheduledFor,
    this.metaData,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      scheduledFor: json['scheduled_for'] != null
          ? DateTime.tryParse(json['scheduled_for'])
          : null,
      metaData: json['meta_data'] != null
          ? Map<String, dynamic>.from(json['meta_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'message': message,
      'type': type,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'scheduled_for': scheduledFor?.toIso8601String(),
      'meta_data': metaData,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    DateTime? scheduledFor,
    Map<String, dynamic>? metaData,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      metaData: metaData ?? this.metaData,
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
