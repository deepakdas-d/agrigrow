import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:agrigrow/core/constants/app_colors.dart';

class MotorHealthChart extends StatefulWidget {
  const MotorHealthChart({super.key});

  @override
  State<MotorHealthChart> createState() => _MotorHealthChartState();
}

class _MotorHealthChartState extends State<MotorHealthChart> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();

    // Trigger animation after first frame
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _animate = true);
      }
    });
  }

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
              _chartData(),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeInOutCubic,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _legend('Temp', Colors.blue),
              _legend('Volt', AppColors.primaryGreen),
              _legend('Amp', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  LineChartData _chartData() {
    return LineChartData(
      minX: 0,
      maxX: 7,
      minY: 0,
      maxY: 100,
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
        getDrawingVerticalLine: (_) =>
            FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, _) => Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ),
        bottomTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      lineBarsData: _animate ? _realData() : _emptyData(),
    );
  }

  List<LineChartBarData> _emptyData() => [
    _bar([], Colors.blue),
    _bar([], AppColors.primaryGreen),
    _bar([], Colors.orange),
  ];

  List<LineChartBarData> _realData() => [
    _bar(const [
      FlSpot(0, 40),
      FlSpot(1, 30),
      FlSpot(2, 60),
      FlSpot(3, 20),
      FlSpot(4, 80),
      FlSpot(5, 30),
      FlSpot(6, 60),
      FlSpot(7, 40),
    ], Colors.blue),
    _bar(const [
      FlSpot(0, 60),
      FlSpot(1, 80),
      FlSpot(2, 20),
      FlSpot(3, 50),
      FlSpot(4, 30),
      FlSpot(5, 40),
      FlSpot(6, 20),
      FlSpot(7, 80),
    ], AppColors.primaryGreen),
    _bar(const [
      FlSpot(0, 70),
      FlSpot(1, 85),
      FlSpot(2, 40),
      FlSpot(3, 60),
      FlSpot(4, 25),
      FlSpot(5, 90),
      FlSpot(6, 40),
      FlSpot(7, 20),
    ], Colors.orange),
  ];

  LineChartBarData _bar(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color.withValues(alpha: 0.6),
      barWidth: 3,
      dotData: const FlDotData(show: true),
      isStrokeCapRound: true,
    );
  }

  Widget _legend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
