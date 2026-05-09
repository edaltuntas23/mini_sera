import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/falling_fruit.dart';

enum GameState { idle, playing, gameOver }

class GameProvider extends ChangeNotifier {
  static const double fruitSize = 48.0;
  static const double basketWidth = 110.0;
  static const double basketHeight = 22.0;
  static const int tickMs = 16;
  static const int spawnEvery = 80;
  static const double minSpeed = 3.0;
  static const double maxSpeed = 7.0;

  GameState _state = GameState.idle;
  GameState get state => _state;

  final List<FallingFruit> _fruits = [];
  List<FallingFruit> get fruits => List.unmodifiable(_fruits);

  int _score = 0;
  int get score => _score;

  int _lives = 3;
  int get lives => _lives;

  double _basketX = 0;
  double get basketX => _basketX;

  double _screenWidth = 0;
  double _screenHeight = 0;

  Timer? _gameTimer;
  int _tickCount = 0;
  final _rng = Random();

  String _activeEmoji = '🍓';

  /// Tracks whether coins have already been awarded for this session.
  /// Prevents double-granting on navigate back or widget rebuild.
  bool _coinsAwarded = false;
  bool get coinsAwarded => _coinsAwarded;

  int get earnedCoins => _score;

  // ── Setup ────────────────────────────────────────────────────────────────

  void setScreenSize(double width, double height) {
    _screenWidth = width;
    _screenHeight = height;
    _basketX = width / 2;
  }

  void setActiveEmoji(String emoji) {
    _activeEmoji = emoji;
  }

  // ── Lifecycle ────────────────────────────────────────────────────────────

  void startGame() {
    _gameTimer?.cancel();
    _state = GameState.playing;
    _score = 0;
    _lives = 3;
    _tickCount = 0;
    _coinsAwarded = false; // ← Reset award flag for new session
    _fruits.clear();
    _gameTimer = Timer.periodic(
      const Duration(milliseconds: tickMs),
      (_) => _tick(),
    );
    notifyListeners();
  }

  void _endGame() {
    _gameTimer?.cancel();
    _state = GameState.gameOver;
    notifyListeners();
  }

  /// Call when leaving GameScreen without going to ResultScreen
  /// (e.g. user presses the system back button mid-game).
  void resetToIdle() {
    _gameTimer?.cancel();
    _state = GameState.idle;
    _coinsAwarded = false;
    _fruits.clear();
    _score = 0;
    _lives = 3;
    notifyListeners();
  }

  /// Called by ResultScreen exactly once to mark coins as awarded.
  void markCoinsAwarded() {
    _coinsAwarded = true;
  }

  // ── Game loop ─────────────────────────────────────────────────────────────

  void _tick() {
    if (_state != GameState.playing) return;
    _tickCount++;

    if (_tickCount % spawnEvery == 0) {
      _spawnFruit();
    }

    for (final fruit in _fruits) {
      fruit.y += fruit.speed;
    }

    final toRemove = <FallingFruit>[];
    final basketLeft = _basketX - basketWidth / 2;
    final basketRight = _basketX + basketWidth / 2;
    final basketTop = _screenHeight - 80 - basketHeight;

    for (final fruit in _fruits) {
      final fruitCentreX = fruit.x + fruitSize / 2;
      final fruitBottom = fruit.y + fruitSize;

      final inRange = fruitCentreX >= basketLeft && fruitCentreX <= basketRight;
      final atLevel = fruitBottom >= basketTop &&
          fruitBottom <= basketTop + basketHeight + fruit.speed + 4;

      if (atLevel && inRange) {
        _score++;
        toRemove.add(fruit);
        continue;
      }

      if (fruit.y > _screenHeight) {
        toRemove.add(fruit);
        _lives--;
        if (_lives <= 0) {
          _fruits.removeWhere(toRemove.contains);
          _endGame();
          return;
        }
      }
    }

    _fruits.removeWhere(toRemove.contains);
    notifyListeners();
  }

  void _spawnFruit() {
    final x = _rng.nextDouble() * (_screenWidth - fruitSize);
    final speed = minSpeed + _rng.nextDouble() * (maxSpeed - minSpeed);
    _fruits.add(FallingFruit(
      id: '${_tickCount}_${_rng.nextInt(9999)}',
      x: x,
      y: -fruitSize,
      emoji: _activeEmoji,
      speed: speed,
    ));
  }

  // ── Input ─────────────────────────────────────────────────────────────────

  void moveBasket(double dx) {
    _basketX = (_basketX + dx).clamp(
      basketWidth / 2,
      _screenWidth - basketWidth / 2,
    );
    notifyListeners();
  }

  void setBasketX(double x) {
    _basketX = x.clamp(basketWidth / 2, _screenWidth - basketWidth / 2);
    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
