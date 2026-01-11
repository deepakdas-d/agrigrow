import 'package:flutter/material.dart';
import 'package:agrigrow/core/constants/app_colors.dart';

enum ControlType { button, toggle }

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
  bool _isSwitchedOn = true;

  @override
  Widget build(BuildContext context) {
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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.settings_input_component, color: AppColors.darkGreen, size: 30),
          ),
          const SizedBox(width: 16),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Farm Name: ${widget.farmName}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('LoraID :${widget.loraId}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                if (widget.schedule.isNotEmpty) ...[
                     const SizedBox(height: 4),
                     Text('Schedule : ${widget.schedule}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ]
              ],
            ),
          ),
          
          // Control
          if (widget.type == ControlType.button)
             TextButton(
                onPressed: () {},
                child: const Text('Stop Now', style: TextStyle(color: Colors.red, decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
             )
          else
             Switch(
                 value: _isSwitchedOn,
                 activeThumbColor: AppColors.white,
                 activeTrackColor: AppColors.primaryGreen,
                 onChanged: (value) {
                     setState(() {
                         _isSwitchedOn = value;
                     });
                 },
             ),
        ],
      ),
      ),
    );
  }
}
