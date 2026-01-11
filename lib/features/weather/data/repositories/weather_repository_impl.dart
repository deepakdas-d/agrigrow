import 'package:dio/dio.dart';
import 'package:agrigrow/core/constants/api_constants.dart';
import 'package:agrigrow/features/weather/data/models/weather_model.dart';
import 'package:agrigrow/features/weather/domain/entities/weather_entity.dart';
import 'package:agrigrow/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final Dio _dio;

  WeatherRepositoryImpl(this._dio);

  @override
  Future<WeatherEntity> getWeatherByLocation(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.weatherBaseUrl}/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': ApiConstants.weatherApiKey,
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      throw Exception('Failed to load weather: $e');
    }
  }
}
