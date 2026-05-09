import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// ── HOW TO CONNECT REAL SENSORS ────────────────────────────────────────────
/// 1. Remove the _simulate() call inside startPolling().
/// 2. Replace with your HTTP fetch / MQTT sub / BLE read.
/// 3. Call updateReadings(temp, hum, water) with parsed values.
///
/// HTTP example:
///   final res = await http.get(Uri.parse('http://192.168.x.x/sensors'));
///   final j   = jsonDecode(res.body);
///   updateReadings(j['temp'].toDouble(), j['humidity'].toDouble(), j['water'].toDouble());
/// ────────────────────────────────────────────────────────────────────────────

enum SensorStatus { normal, warning, danger }

class SensorProvider extends ChangeNotifier {
  double temperature = 22.0; // °C
  double humidity = 65.0; // %
  double waterLevel = 450.0; // ml

  String currentPlant = 'Strawberry';
  String currentPlantEmoji = '🍓';

  Timer? _timer;
  final _rng = Random();

  // ── Thresholds ────────────────────────────────────────────────────────────
  SensorStatus get tempStatus {
    if (temperature < 10 || temperature > 35) return SensorStatus.danger;
    if (temperature < 15 || temperature > 28) return SensorStatus.warning;
    return SensorStatus.normal;
  }

  SensorStatus get humidityStatus {
    if (humidity < 30 || humidity > 95) return SensorStatus.danger;
    if (humidity < 50 || humidity > 80) return SensorStatus.warning;
    return SensorStatus.normal;
  }

  SensorStatus get waterStatus {
    if (waterLevel < 100) return SensorStatus.danger;
    if (waterLevel < 250) return SensorStatus.warning;
    return SensorStatus.normal;
  }

  // ── Polling ───────────────────────────────────────────────────────────────
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
