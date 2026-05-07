import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/falling_fruit.dart';
import '../services/storage_service.dart';
import '../services/storage_service.dart';

enum GameState { idle, playing, paused, gameOver }

class GameProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final Random _random = Random();

  int coins = 0;
  int highScore = 0;
  int score = 0;
  int lives = 3;
  GameState gameState = GameState.idle;
  List<FallingFruit> fallingFruits = [];

  double screenWidth = 375;
  double screenHeight = 812;
  double basketX = 0.5;
  int _elapsedMs = 0;
  Timer? _ticker;

  // Örnek meyve (FruitItem modelinle uyumlu olmalı)
  dynamic activeFruit = (emoji: '🍓', name: 'Strawberry', pointValue: 10);

  void init() async {
    coins = await _storage.getCoins();
    highScore = await _storage.getHighScore();
    notifyListeners();
  }

  void startGame() {
    score = 0;
    lives = 3;
    fallingFruits = [];
    _elapsedMs = 0;
    gameState = GameState.playing;
    _startTimers();
    notifyListeners();
  }

  void _startTimers() {
    _ticker = Timer.periodic(const Duration(milliseconds: 16), _tick);
  }

  void _tick(Timer t) {
    if (gameState != GameState.playing) return;
    _elapsedMs += 16;

    bool dirty = false;
    for (final fruit in fallingFruits) {
      if (fruit.caught || fruit.missed) continue;
      fruit.y += 4.0; // Sabit hız

      // Sepet kontrolü (basitleştirilmiş)
      if (fruit.y > screenHeight - 150 &&
          (fruit.x / screenWidth - basketX).abs() < 0.1) {
        fruit.caught = true;
        score += 10;
        dirty = true;
      } else if (fruit.y > screenHeight) {
        fruit.missed = true;
        lives--;
        dirty = true;
      }
    }

    if (lives <= 0) {
      gameState = GameState.gameOver;
      _ticker?.cancel();
      _storage.updateHighScore(score);
    }

    // Yeni meyve ekleme mantığı
    if (_elapsedMs % 1000 == 0) {
      fallingFruits.add(
        FallingFruit.spawn(
          emoji: '🍓',
          screenWidth: screenWidth,
          baseSpeed: 2.0,
          random: _random,
        ),
      );
      dirty = true;
    }

    if (dirty) notifyListeners();
  }

  void moveBasket(double x) {
    basketX = (x / screenWidth).clamp(0.0, 1.0);
    notifyListeners();
  }
}
