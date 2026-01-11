import 'package:flutter/material.dart';
// import 'package:agrigrow/core/constants/app_colors.dart'; // Unused


class WeeklyForecastCard extends StatelessWidget {
  const WeeklyForecastCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Weekly Forecast',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5), // Light background container
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildForecastItem('MON', '30%', '19°', Icons.cloud, Colors.blue),
              _buildForecastItem('TUE', '20%', '24°', Icons.wb_sunny, Colors.orange), // Sunny
              _buildForecastItem('WED', '30%', '19°', Icons.cloud, Colors.blue),
              _buildForecastItem('THU', '50%', '19°', Icons.thunderstorm, Colors.blueGrey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForecastItem(String day, String chance, String temp, IconData icon, Color iconColor) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade100.withValues(alpha: 0.5), // Light blue pill
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(day, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 8),
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 4),
          Text(chance, style: const TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 8),
          Text(temp, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}
