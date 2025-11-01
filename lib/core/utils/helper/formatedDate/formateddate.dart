import 'package:flutter/material.dart';

String formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

bool hasOnlyIncome(double totalIncome, double totalExpenses) {
  return totalIncome > 0 && totalExpenses == 0;
}

bool hasOnlyExpenses(double totalIncome, double totalExpenses) {
  return totalExpenses > 0 && totalIncome == 0;
}

final List<Color> niceColors = [
  const Color(0xFF4DD0E1), // teal/Aqua
  const Color(0xFFBA68C8), // purple
  const Color(0xFFFF8A65), // deep orange
  const Color(0xFF4DB6AC), // turquoise
  const Color(0xFFFFB74D), // amber
  const Color(0xFF81C784), // green
  const Color(0xFFFF8A65), // coral
  const Color(0xFFA1887F), // brown/grey
  const Color(0xFFAED581), // light green
  const Color(0xFF90CAF9), // light blue
  const Color(0xFFFFD54F), // yellow
  const Color(0xFFE57373), // red
];
