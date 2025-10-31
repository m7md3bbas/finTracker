import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finance_track/core/models/analysis_model.dart';

class MonthlyBars extends StatelessWidget {
  final List<CategoryBreakdown> data;

  const MonthlyBars({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxAmount = data
        .map((e) => e.amount)
        .fold<double>(0, (p, n) => n > p ? n : p);
    double interval;
    if (maxAmount <= 0) {
      interval = 1;
    } else if (maxAmount <= 100) {
      interval = 25;
    } else if (maxAmount <= 500) {
      interval = 100;
    } else if (maxAmount <= 1000) {
      interval = 200;
    } else if (maxAmount <= 5000) {
      interval = 1000;
    } else {
      interval = (maxAmount / 5).ceilToDouble();
    }

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Colors.black26, width: 1),
              bottom: BorderSide(color: Colors.black26, width: 1),
              right: BorderSide(color: Colors.transparent, width: 0),
              top: BorderSide(color: Colors.transparent, width: 0),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: interval,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.black12, strokeWidth: 1),
          ),
          barTouchData: const BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                interval: interval,
                getTitlesWidget: (value, meta) {
                  if (value < 0) return const SizedBox.shrink();
                  return Text(
                    value == 0 ? '0' : value.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }
                  final label = data[index].category;
                  final short = label.length > 6
                      ? '${label.substring(0, 6)}…'
                      : label;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(short, style: const TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(data.length, (i) {
            final color =
                Colors.primaries[i % Colors.primaries.length].shade400;
            final amount = data[i].amount.toDouble();
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: amount,
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [color.withOpacity(0.95), color.withOpacity(0.65)],
                  ),
                  width: 14,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: amount * 1.1,
                    color: color.withOpacity(0.15),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
