class BudgetModel {
  final String? id;
  final String userId;
  final int month;
  final int year;
  final double amount;
  final DateTime? createdAt;

  BudgetModel({
    this.id,
    required this.userId,
    required this.month,
    required this.year,
    required this.amount,
    this.createdAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'],
      userId: json['user_id'],
      month: json['month'],
      year: json['year'],
      amount: (json['amount'] as num).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'month': month, 'year': year, 'amount': amount};
  }
}
