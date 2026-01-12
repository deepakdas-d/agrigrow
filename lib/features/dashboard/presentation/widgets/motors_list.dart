import 'package:flutter/material.dart';
import 'package:agrigrow/core/constants/app_colors.dart';

class MotorItem {
  final String farmName;
  final String loraId;
  final String schedule;
  final bool isRunning;

  MotorItem({
    required this.farmName,
    required this.loraId,
    required this.schedule,
    this.isRunning = true,
  });
}

class MotorsList extends StatelessWidget {
  final List<MotorItem> motors;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const MotorsList({
    super.key,
    required this.motors,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'MOTORS IN SCHEDULE',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: shrinkWrap,
          physics: physics ?? const NeverScrollableScrollPhysics(),
          itemCount: motors.length,
          itemBuilder: (context, index) {
            final motor = motors[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Motor Icon Circle
                  Container(
                    width: 63,
                    height: 63,
                    decoration: const BoxDecoration(
                      color: AppColors.lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/water-pump.png',
                        width: 45, // smaller
                        height: 45,
                        fit: BoxFit.contain,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Farm Name: ${motor.farmName}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'LoraID :${motor.loraId}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Schedule : ${motor.schedule}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stop Button
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Stop Now',
                      style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
