import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String? id;
  final String userId;
  final String title;
  final double amount;
  final String type;
  final DateTime date;
  final String? note;
  final String? categoryName;

  final DateTime? createdAt;

  const TransactionModel({
    this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
    this.categoryName,
    this.createdAt,
  });

  TransactionModel copyWith({
    String? id,
    String? userId,
    String? title,
    double? amount,
    String? type,
    DateTime? date,
    String? note,
    String? categoryName,
    String? categoryType,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      note: note ?? this.note,
      categoryName: categoryName ?? this.categoryName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type']?.toString() ?? 'income',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      note: json['note']?.toString() ?? 'no note',
      categoryName: json['category_name']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'title': title,
      'amount': amount,
      'type': type,
      'category_name': categoryName,
      'date': date.toIso8601String(),
      'note': note,
      'created_at': createdAt?.toIso8601String(),
    };

    return data;
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    amount,
    type,
    date,
    note,
    categoryName,
    createdAt,
  ];
}
