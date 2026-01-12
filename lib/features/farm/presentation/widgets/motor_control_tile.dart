import 'package:flutter/material.dart';
import 'package:agrigrow/core/constants/app_colors.dart';

enum ControlType { button, toggle }

enum MotorState { off, activating, on }

class MotorControlTile extends StatefulWidget {
  final String farmName;
  final String loraId;
  final String schedule;
  final ControlType type;
  final VoidCallback? onTap;

  const MotorControlTile({
    super.key,
    required this.farmName,
    required this.loraId,
    required this.schedule,
    this.type = ControlType.button,
    this.onTap,
  });

  @override
  State<MotorControlTile> createState() => _MotorControlTileState();
}

class _MotorControlTileState extends State<MotorControlTile> {
  MotorState _motorState = MotorState.off;

  void _toggleSwitch() {
    if (_motorState == MotorState.off) {
      setState(() {
        _motorState = MotorState.activating;
      });

      // Automatically move to On
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _motorState = MotorState.on;
          });
        }
      });
    } else if (_motorState == MotorState.on) {
      setState(() {
        _motorState = MotorState.off;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color trackColor;
    Color thumbColor;
    Alignment thumbAlign;

    switch (_motorState) {
      case MotorState.off:
        trackColor = Colors.grey.shade400;
        thumbColor = Colors.white;
        thumbAlign = Alignment.centerLeft;
        break;
      case MotorState.activating:
        trackColor = Colors.yellow.shade600;
        thumbColor = Colors.white;
        thumbAlign = Alignment.center;
        break;
      case MotorState.on:
        trackColor = AppColors.primaryGreen;
        thumbColor = Colors.white;
        thumbAlign = Alignment.centerRight;
        break;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
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
                    'Farm Name: ${widget.farmName}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'LoraID :${widget.loraId}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (widget.schedule.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Schedule : ${widget.schedule}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),

            // Toggle Switch
            if (widget.type == ControlType.toggle)
              GestureDetector(
                onTap: _toggleSwitch,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 60,
                  height: 30,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: trackColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    alignment: thumbAlign,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: thumbColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),

            // Button fallback
            if (widget.type == ControlType.button)
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
      ),
    );
  }
}
