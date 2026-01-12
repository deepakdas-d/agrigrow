import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:agrigrow/core/constants/app_colors.dart';

class MotorHealthChart extends StatelessWidget {
  const MotorHealthChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) => 
                       FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
                  getDrawingVerticalLine: (value) => 
                       FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}', style: const TextStyle(fontSize: 10, color: Colors.grey));
                    }),
                  ),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withValues(alpha: 0.2))),
                minX: 0,
                maxX: 7,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  // Temperature (Blue)
                  LineChartBarData(
                    spots: const [FlSpot(0, 40), FlSpot(1, 30), FlSpot(2, 60), FlSpot(3, 20), FlSpot(4, 80), FlSpot(5, 30), FlSpot(6, 60), FlSpot(7, 40)],
                    isCurved: true,
                    color: Colors.blue.withValues(alpha: 0.5),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                  ),
                  // Volt (Green)
                  LineChartBarData(
                    spots: const [FlSpot(0, 60), FlSpot(1, 80), FlSpot(2, 20), FlSpot(3, 50), FlSpot(4, 30), FlSpot(5, 40), FlSpot(6, 20), FlSpot(7, 80)],
                    isCurved: true,
                    color: AppColors.primaryGreen.withValues(alpha: 0.5),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                  ),
                   // Amp (Orange)
                  LineChartBarData(
                    spots: const [FlSpot(0, 70), FlSpot(1, 85), FlSpot(2, 40), FlSpot(3, 60), FlSpot(4, 25), FlSpot(5, 90), FlSpot(6, 40), FlSpot(7, 20)],
                    isCurved: true,
                    color: Colors.orange.withValues(alpha: 0.5),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               _buildLegendItem('Temp', Colors.blue),
               _buildLegendItem('Volt', AppColors.primaryGreen),
               _buildLegendItem('Amp', Colors.orange),
            ],
          )
        ],
      ),
    );
  }
  
  Widget _buildLegendItem(String label, Color color) {
      return Row(
          children: [
              Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
          ],
      );
  }
}
