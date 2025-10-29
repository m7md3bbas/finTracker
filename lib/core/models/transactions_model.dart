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
      categoryType: categoryType ?? this.categoryType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString() ?? '', // required field
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

    // Only include user_id if it's valid
    if (userId.isNotEmpty) data['user_id'] = userId;

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
    categoryType,
    createdAt,
  ];
}
