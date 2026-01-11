import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agrigrow/core/constants/app_colors.dart';
import 'package:agrigrow/features/dashboard/presentation/widgets/farm_weather_card.dart';
import 'package:agrigrow/features/dashboard/presentation/widgets/weekly_forecast_card.dart';
import 'package:agrigrow/features/dashboard/presentation/widgets/yield_chart.dart';
import 'package:agrigrow/features/dashboard/presentation/widgets/motor_control_tile.dart';
import 'package:agrigrow/features/weather/domain/entities/weather_entity.dart';
import 'package:agrigrow/features/dashboard/presentation/pages/motor_details_page.dart';



// Temporary Mock Weather for Details Page if we don't pass it or fetch it
final mockWeather = WeatherEntity(
  cityName: 'Palakkad,Kerala',
  temperature: 24, 
  description: 'cloudy',
  iconCode: '04d',
  humidity: 87,
  windSpeed: 5,
);

class FarmDetailsPage extends StatelessWidget {
  final String farmName;

  const FarmDetailsPage({super.key, required this.farmName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('FARM DETAILS PAGE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white)),
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
            
            // 1. Weather Card (Reused)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FarmWeatherCard(
                // Ideally, pass the real weather or fetch it. Using mock for UI replication.
                weather: mockWeather, 
                farmName: farmName,
                date: DateFormat('MMM d,yyyy h.mm a').format(DateTime.now()),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // 2. Weekly Forecast
            const WeeklyForecastCard(),
            
            const SizedBox(height: 30),
            
            // 3. Yield Chart
            const YieldChart(),
             
            const SizedBox(height: 30),
            
            // 4. Motors
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text('Motors In Farm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            
            Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16),
               child: Column(
                   children: [
                       MotorControlTile(
                           farmName: farmName, 
                           loraId: '25', 
                           schedule: '10:00am to 11:00am (daily)',
                           type: ControlType.button,
                           onTap: () {
                               Navigator.push(context, MaterialPageRoute(builder: (_) => MotorDetailsPage(farmName: farmName, loraId: '25')));
                           },
                       ),
                       MotorControlTile(
                           farmName: farmName, 
                           loraId: '25', 
                           schedule: '', // No schedule shown in 2nd item of image
                           type: ControlType.toggle,
                           onTap: () {
                               Navigator.push(context, MaterialPageRoute(builder: (_) => MotorDetailsPage(farmName: farmName, loraId: '25')));
                           },
                       ),
                   ],
               ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
