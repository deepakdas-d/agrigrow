import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:agrigrow/core/constants/app_colors.dart';

class YieldChart extends StatelessWidget {
  const YieldChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Yield Chart',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) => 
                     FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1),
                getDrawingVerticalLine: (value) => 
                     FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (value, meta) {
                    return Text('${value.toInt()}', style: const TextStyle(fontSize: 10, color: Colors.grey));
                  }),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false), // Hide bottom titles for simplicity as per image
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 7,
              minY: 0,
              maxY: 60,
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 30),
                    FlSpot(1, 15),
                    FlSpot(2, 40),
                    FlSpot(3, 15),
                    FlSpot(4, 25),
                    FlSpot(5, 55),
                    FlSpot(6, 18),
                    FlSpot(7, 50),
                  ],
                  isCurved: false,
                  color: AppColors.primaryGreen,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.primaryGreen,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                      );
                  }),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
