import 'package:agrigrow/features/weather/domain/entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<WeatherEntity> getWeatherByLocation(double lat, double lon);
}
