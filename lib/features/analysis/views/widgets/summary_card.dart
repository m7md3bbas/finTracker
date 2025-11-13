import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;

  const SummaryCard({super.key, required this.title, required this.amount});

  Color _getTextColor(String title) {
    if (title.toLowerCase().contains('income')) {
      return Colors.green;
    } else if (title.toLowerCase().contains('expense')) {
      return Colors.red;
    } else if (title.toLowerCase().contains('saving')) {
      return Colors.blue;
    } else {
      return Colors.black87;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = _getTextColor(title);

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "\$${amount.toStringAsFixed(2)}",
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
