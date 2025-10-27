class CategoryModel {
  final String? id;
  final String? userId;
  final String name;
  final String? type;
  final String? icon;
  final String? color;
  final DateTime? createdAt;

  const CategoryModel({
    this.id,
    this.userId,
    required this.name,
    this.type,
    this.icon,
    this.color,
    this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'name': name,
    'type': type,
    'icon': icon,
    'color': color,
    'created_at': createdAt?.toIso8601String(),
  };
}
