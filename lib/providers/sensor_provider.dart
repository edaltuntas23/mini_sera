import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum SensorStatus { normal, warning, danger }

// Per-fruit ideal ranges for the dashboard
class FruitIdealRange {
  final String fruitId;
  final double tempMin, tempMax;
  final double humidMin, humidMax;
  final double waterMin, waterMax;
  final String tempLabel, humidLabel, waterLabel;

  const FruitIdealRange({
    required this.fruitId,
    required this.tempMin,
    required this.tempMax,
    required this.humidMin,
    required this.humidMax,
    required this.waterMin,
    required this.waterMax,
    required this.tempLabel,
    required this.humidLabel,
    required this.waterLabel,
  });
}

const Map<String, FruitIdealRange> kFruitRanges = {
  'strawberry': FruitIdealRange(
    fruitId: 'strawberry',
    tempMin: 15,
    tempMax: 25,
    humidMin: 60,
    humidMax: 80,
    waterMin: 300,
    waterMax: 600,
    tempLabel: 'İdeal: 15–25°C',
    humidLabel: 'İdeal: %60–80',
    waterLabel: 'İdeal: 300–600 ml',
  ),
  'tomato': FruitIdealRange(
    fruitId: 'tomato',
    tempMin: 18,
    tempMax: 27,
    humidMin: 50,
    humidMax: 70,
    waterMin: 350,
    waterMax: 700,
    tempLabel: 'İdeal: 18–27°C',
    humidLabel: 'İdeal: %50–70',
    waterLabel: 'İdeal: 350–700 ml',
  ),
  'pepper': FruitIdealRange(
    fruitId: 'pepper',
    tempMin: 20,
    tempMax: 30,
    humidMin: 50,
    humidMax: 75,
    waterMin: 250,
    waterMax: 550,
    tempLabel: 'İdeal: 20–30°C',
    humidLabel: 'İdeal: %50–75',
    waterLabel: 'İdeal: 250–550 ml',
  ),
  'eggplant': FruitIdealRange(
    fruitId: 'eggplant',
    tempMin: 22,
    tempMax: 30,
    humidMin: 60,
    humidMax: 70,
    waterMin: 300,
    waterMax: 600,
    tempLabel: 'İdeal: 22–30°C',
    humidLabel: 'İdeal: %60–70',
    waterLabel: 'İdeal: 300–600 ml',
  ),
  'corn': FruitIdealRange(
    fruitId: 'corn',
    tempMin: 18,
    tempMax: 32,
    humidMin: 50,
    humidMax: 80,
    waterMin: 400,
    waterMax: 800,
    tempLabel: 'İdeal: 18–32°C',
    humidLabel: 'İdeal: %50–80',
    waterLabel: 'İdeal: 400–800 ml',
  ),
  'cherry': FruitIdealRange(
    fruitId: 'cherry',
    tempMin: 10,
    tempMax: 20,
    humidMin: 50,
    humidMax: 70,
    waterMin: 150,
    waterMax: 400,
    tempLabel: 'İdeal: 10–20°C',
    humidLabel: 'İdeal: %50–70',
    waterLabel: 'İdeal: 150–400 ml',
  ),
  'watermelon': FruitIdealRange(
    fruitId: 'watermelon',
    tempMin: 22,
    tempMax: 35,
    humidMin: 50,
    humidMax: 65,
    waterMin: 400,
    waterMax: 800,
    tempLabel: 'İdeal: 22–35°C',
    humidLabel: 'İdeal: %50–65',
    waterLabel: 'İdeal: 400–800 ml',
  ),
  'avocado': FruitIdealRange(
    fruitId: 'avocado',
    tempMin: 18,
    tempMax: 26,
    humidMin: 50,
    humidMax: 70,
    waterMin: 300,
    waterMax: 700,
    tempLabel: 'İdeal: 18–26°C',
    humidLabel: 'İdeal: %50–70',
    waterLabel: 'İdeal: 300–700 ml',
  ),
};

class SensorProvider extends ChangeNotifier {
  double temperature = 22.0;
  double humidity = 65.0;
  double waterLevel = 450.0;

  String currentPlant = 'Strawberry';
  String currentPlantEmoji = '🍓';

  /// The fruit ID currently selected on the HOME dashboard (unlocked for all).
  String _dashboardFruitId = 'strawberry';
  String get dashboardFruitId => _dashboardFruitId;

  FruitIdealRange get currentRange =>
      kFruitRanges[_dashboardFruitId] ?? kFruitRanges['strawberry']!;

  void setDashboardFruit(String id, String name, String emoji) {
    _dashboardFruitId = id;
    currentPlant = name;
    currentPlantEmoji = emoji;
    notifyListeners();
  }

  Timer? _timer;
  final _rng = Random();

  // ── Status uses the currently selected fruit's ideal range ───────────────
  SensorStatus get tempStatus {
    final r = currentRange;
    if (temperature < r.tempMin - 5 || temperature > r.tempMax + 5) {
      return SensorStatus.danger;
    }
    if (temperature < r.tempMin || temperature > r.tempMax) {
      return SensorStatus.warning;
    }
    return SensorStatus.normal;
  }

  SensorStatus get humidityStatus {
    final r = currentRange;
    if (humidity < r.humidMin - 20 || humidity > r.humidMax + 15) {
      return SensorStatus.danger;
    }
    if (humidity < r.humidMin || humidity > r.humidMax) {
      return SensorStatus.warning;
    }
    return SensorStatus.normal;
  }

  SensorStatus get waterStatus {
    final r = currentRange;
    if (waterLevel < r.waterMin * 0.4) return SensorStatus.danger;
    if (waterLevel < r.waterMin) return SensorStatus.warning;
    return SensorStatus.normal;
  }

  void startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _simulate());
  }

  void _simulate() {
    temperature =
        (temperature + (_rng.nextDouble() - 0.5) * 0.8).clamp(10.0, 40.0);
    humidity = (humidity + (_rng.nextDouble() - 0.5) * 1.5).clamp(20.0, 99.0);
    waterLevel = (waterLevel - _rng.nextDouble() * 2).clamp(0.0, 1000.0);
    notifyListeners();
  }

  void updateReadings(double temp, double hum, double water) {
    temperature = temp;
    humidity = hum;
    waterLevel = water;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
