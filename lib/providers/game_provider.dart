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

  Timer? _timer;
  int _tick = 0;
  final _rng = Random();
  String _emoji = '🍓';

  bool _coinsAwarded = false;
  bool get coinsAwarded => _coinsAwarded;

  /// 1:1 — coins earned equals score.
  int get earnedCoins => _score;

  void setScreenSize(double w, double h) {
    _screenWidth = w;
    _screenHeight = h;
    _basketX = w / 2;
  }

  void setActiveEmoji(String e) {
    _emoji = e;
  }

  void startGame() {
    _timer?.cancel();
    _state = GameState.playing;
    _score = 0;
    _lives = 3;
    _tick = 0;
    _coinsAwarded = false;
    _fruits.clear();
    _timer =
        Timer.periodic(const Duration(milliseconds: tickMs), (_) => _loop());
    notifyListeners();
  }

  void _endGame() {
    _timer?.cancel();
    _state = GameState.gameOver;
    notifyListeners();
  }

  void resetToIdle() {
    _timer?.cancel();
    _state = GameState.idle;
    _coinsAwarded = false;
    _fruits.clear();
    _score = 0;
    _lives = 3;
    notifyListeners();
  }

  void markCoinsAwarded() => _coinsAwarded = true;

  void _loop() {
    if (_state != GameState.playing) return;
    _tick++;
    if (_tick % spawnEvery == 0) _spawn();

    for (final f in _fruits) {
      f.y += f.speed;
    }

    final toRemove = <FallingFruit>[];
    final bLeft = _basketX - basketWidth / 2;
    final bRight = _basketX + basketWidth / 2;
    final bTop = _screenHeight - 80 - basketHeight;

    for (final f in _fruits) {
      final cx = f.x + fruitSize / 2;
      final fb = f.y + fruitSize;
      if (fb >= bTop && fb <= bTop + basketHeight + f.speed + 4) {
        if (cx >= bLeft && cx <= bRight) {
          _score++;
          toRemove.add(f);
          continue;
        }
      }
      if (f.y > _screenHeight) {
        toRemove.add(f);
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

  void _spawn() {
    final x = _rng.nextDouble() * (_screenWidth - fruitSize);
    _fruits.add(FallingFruit(
      id: '${_tick}_${_rng.nextInt(9999)}',
      x: x,
      y: -fruitSize,
      emoji: _emoji,
      speed: minSpeed + _rng.nextDouble() * (maxSpeed - minSpeed),
    ));
  }

  void moveBasket(double dx) {
    _basketX =
        (_basketX + dx).clamp(basketWidth / 2, _screenWidth - basketWidth / 2);
    notifyListeners();
  }

  void setBasketX(double x) {
    _basketX = x.clamp(basketWidth / 2, _screenWidth - basketWidth / 2);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
