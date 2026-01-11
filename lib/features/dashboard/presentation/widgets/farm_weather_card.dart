import 'package:flutter/material.dart';
import 'package:agrigrow/core/constants/app_colors.dart';
import 'package:agrigrow/core/constants/api_constants.dart';
import 'package:agrigrow/features/weather/domain/entities/weather_entity.dart';
// import 'package:intl/intl.dart'; // Unused


class FarmWeatherCard extends StatelessWidget {
  final WeatherEntity? weather;
  final String farmName;
  final String date;

  const FarmWeatherCard({
    super.key,
    required this.weather,
    required this.farmName,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white, // White card as per design
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weather Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              if (weather != null)
                Image.network(
                  '${ApiConstants.weatherIconUrl}/${weather!.iconCode}@2x.png',
                  width: 60,
                  height: 60,
                  errorBuilder: (ctx, _, stackTrace) => const Icon(Icons.cloud, size: 60, color: Colors.grey),
                )
              else
                 const Icon(Icons.cloud_off, size: 60, color: Colors.grey),
              
              const SizedBox(width: 10),
              
              // Date & Desc & Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      weather?.description ?? 'Loading...',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(
                          weather?.cityName != null && weather!.cityName.isNotEmpty ? weather!.cityName : farmName, // Fallback location
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Temperature
              Text(
                weather != null ? '${weather!.temperature.toStringAsFixed(0)}°' : '--',
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black45),
              ),
            ],
          ),
          
          const Divider(height: 30),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(Icons.water_drop, '${weather?.humidity ?? '--'}%', 'humidity', Colors.blue),
              _buildStatItem(Icons.science, '7.7', 'Fertility', Colors.brown), // Static from design
              _buildStatItem(Icons.water, '10kPa', 'Soil Wet', Colors.lightBlue), // Static from design
            ],
          ),
          
          const Divider(height: 30),
          
          // Yield & Water
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               _buildLabelValue('Yield Prediction :', 'good', badgeColor: const Color(0xFFD4E157)),
               _buildLabelValue('Water Needed :', '300L', isBoldValue: true),
             ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color iconColor) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildLabelValue(String label, String value, {Color? badgeColor, bool isBoldValue = false}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(width: 5),
        if (badgeColor != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          )
        else
          Text(value, style: TextStyle(fontSize: 14, fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
