import 'package:flutter/material.dart';
import 'package:agrigrow/core/constants/app_colors.dart';
import 'package:agrigrow/features/dashboard/presentation/widgets/motor_health_chart.dart';
import 'package:agrigrow/features/dashboard/presentation/widgets/motor_control_tile.dart';

class MotorDetailsPage extends StatefulWidget {
  final String farmName;
  final String loraId;

  const MotorDetailsPage({super.key, required this.farmName, required this.loraId});

  @override
  State<MotorDetailsPage> createState() => _MotorDetailsPageState();
}

class _MotorDetailsPageState extends State<MotorDetailsPage> {
  final List<String> _scheduledItems = [
    "10:00am to 11:00am (daily)",
  ];

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryGreen,
            colorScheme: const ColorScheme.light(primary: AppColors.primaryGreen),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

      if (picked != null && context.mounted) {
        // Logic to add schedule would go here
        // For demo, just showing we can pick dates. 
        // In a real app we'd need time picker too or a custom widget for the specific schedule logic (days of week etc).
        // The image shows a custom dialog, but standard picker is a good start.
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected: ${picked.start} - ${picked.end}'))
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: const Text('MOTOR DETAILS PAGE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
            )
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             const SizedBox(height: 20),
             
             // 1. Health Chart
             const MotorHealthChart(),
             
             const SizedBox(height: 20),
             
             // 2. Control Tile (Reused)
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16),
               child: MotorControlTile(
                 farmName: widget.farmName,
                 loraId: widget.loraId,
                 schedule: '',
                 type: ControlType.toggle,
               ),
             ),
             
             const SizedBox(height: 20),
             
             // 3. Schedule Button
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16),
               child: Align(
                 alignment: Alignment.centerLeft,
                 child: TextButton.icon(
                   onPressed: () => _selectDateRange(context),
                   icon: const Icon(Icons.add_circle, color: AppColors.primaryGreen),
                   label: const Text('Schedule Motor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkGreen)),
                 ),
               ),
             ),
             
             // 4. Scheduled List 
             ListView.builder(
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               padding: const EdgeInsets.symmetric(horizontal: 16),
               itemCount: _scheduledItems.length,
               itemBuilder: (context, index) {
                   return Container(
                       margin: const EdgeInsets.only(bottom: 10),
                       padding: const EdgeInsets.all(16),
                       decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(15),
                           border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.5)),
                       ),
                       child: Row(
                           children: [
                               // Icon
                               Container(
                                   padding: const EdgeInsets.all(10),
                                   decoration: BoxDecoration(
                                       color: AppColors.lightGreen,
                                       shape: BoxShape.circle,
                                   ),
                                   child: const Icon(Icons.settings_input_component, color: AppColors.darkGreen, size: 24),
                               ),
                               const SizedBox(width: 16),
                               // Details
                               Expanded(
                                   child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                           Text('Farm Name: ${widget.farmName}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                           const SizedBox(height: 4),
                                           Text('LoraID: ${widget.loraId}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                           const SizedBox(height: 4),
                                           Text('Schedule : ${_scheduledItems[index]}', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                                       ],
                                   ),
                               ),
                               // Action
                               TextButton(
                                   onPressed: () {
                                       // Stop/Remove logic
                                   },
                                   child: const Text('Stop Now', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                               ),
                           ],
                       ),
                   );
               },
             ),
             const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
