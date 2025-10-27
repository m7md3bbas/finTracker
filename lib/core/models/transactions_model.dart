import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String? id;
  final String userId;
  final String title;
  final double amount;
  final String type; // 'income' or 'expense'
  final DateTime date;
  final String? note;
  final String? categoryName; // for joined query
  final String? categoryType; // for joined query
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
    this.categoryType,
    this.createdAt,
  });
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString(), // <-- allow null
      userId: json['user_id']?.toString() ?? '', // required field fallback
      title: json['title']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type']?.toString() ?? 'income',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      note: json['note']?.toString(),
      categoryName: json['category_name']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'category_name': categoryName,
    'title': title,
    'amount': amount,
    'type': type,
    'date': date.toIso8601String(),
    'note': note,
    'created_at': createdAt?.toIso8601String(),
  };

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
    categoryType,
    createdAt,
  ];
}
