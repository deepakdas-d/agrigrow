import 'package:flutter/material.dart';
import 'package:agrigrow/features/weather/domain/entities/weather_entity.dart';
import 'package:agrigrow/features/weather/domain/repositories/weather_repository.dart';
import 'package:agrigrow/core/utils/location_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _weatherRepository;
  final LocationService _locationService;

  WeatherEntity? _weather;
  WeatherEntity? get weather => _weather;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  WeatherProvider(this._weatherRepository, this._locationService);

  Future<void> fetchWeather() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      // Position cannot be null if no exception was thrown with the new LocationService
      _weather = await _weatherRepository.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
