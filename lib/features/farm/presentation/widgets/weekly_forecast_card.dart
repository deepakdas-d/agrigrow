import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyForecastCard extends StatelessWidget {
  const WeeklyForecastCard({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEE').format(DateTime.now()).toUpperCase();

    final data = [
      {'day': 'MON', 'chance': '30%', 'temp': '19°', 'icon': Icons.cloud},
      {'day': 'TUE', 'chance': '20%', 'temp': '24°', 'icon': Icons.wb_sunny},
      {'day': 'WED', 'chance': '30%', 'temp': '19°', 'icon': Icons.cloud},
      {
        'day': 'THU',
        'chance': '50%',
        'temp': '19°',
        'icon': Icons.thunderstorm,
      },
      {'day': 'FRI', 'chance': '10%', 'temp': '22°', 'icon': Icons.wb_sunny},
      {'day': 'SAT', 'chance': '40%', 'temp': '18°', 'icon': Icons.cloud},
      {'day': 'SUN', 'chance': '25%', 'temp': '21°', 'icon': Icons.wb_sunny},
    ];

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
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5), // Light background
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(
                height: 160, // Fixed height for pills
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final isToday = item['day'] == today;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: _forecastPill(
                        day: item['day']! as String,
                        chance: item['chance']! as String,
                        temp: item['temp']! as String,
                        icon: item['icon'] as IconData,
                        isToday: isToday,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _forecastPill({
    required String day,
    required String chance,
    required String temp,
    required IconData icon,
    required bool isToday,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 65,
      height: isToday ? 160 : 145,
      decoration: BoxDecoration(
        color: isToday ? const Color(0xFF2EC4C9) : const Color(0xFF8ECBF5),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isToday ? 0.25 : 0.12),
            blurRadius: isToday ? 12 : 6,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 6),
          Text(
            chance,
            style: const TextStyle(fontSize: 11, color: Colors.white70),
          ),
          const SizedBox(height: 10),
          Text(
            temp,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
