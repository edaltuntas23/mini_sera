import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/falling_fruit.dart';
import '../models/fruit_item.dart';
import '../services/storage_service.dart';

enum GameState { idle, playing, paused, gameOver }

/// Central state manager for the Mini Greenhouse game.
/// Owns the game loop, scoring, economy, and shop state.
class GameProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final Random _random = Random();

  // ── Economy ────────────────────────────────────────────────────────────────
  int coins = 0;
  int highScore = 0;
  List<String> unlockedFruitIds = ['strawberry'];
  String activeFruitId = 'strawberry';

  FruitItem get activeFruit => FruitCatalog.getById(activeFruitId);

  // ── Game State ─────────────────────────────────────────────────────────────
  GameState gameState = GameState.idle;
  int score = 0;
  int lives = 3; // missing a fruit costs a life
  List<FallingFruit> fallingFruits = [];

  // ── Game Loop Config ───────────────────────────────────────────────────────
  static const _tickMs = 16; // ~60 fps
  static const _spawnIntervalMs = 1200; // how often a new fruit spawns
  static const _coinsPerPoint = 2; // points → coins conversion at game end

  Timer? _ticker;
  Timer? _spawnTimer;
  int _elapsedMs = 0;

  // ── Basket ─────────────────────────────────────────────────────────────────
  double basketX = 0.5; // 0.0 → 1.0 relative position
  static const double basketWidth = 100.0; // logical pixels
  static const double basketHeight = 30.0;

  // Screen dimensions set by the game widget on build
  double screenWidth = 375;
  double screenHeight = 812;

  // ── Base speed that increases as the game progresses ──────────────────────
  double get _baseSpeed {
    // Starts at 3.5 px/frame, increases by 0.5 every 10 seconds
    final seconds = _elapsedMs ~/ 1000;
    return 3.5 + (seconds ~/ 10) * 0.5;
  }

  // ── Init ───────────────────────────────────────────────────────────────────

  Future<void> init() async {
    coins = await _storage.getCoins();
    highScore = await _storage.getHighScore();
    unlockedFruitIds = await _storage.getUnlockedFruits();
    activeFruitId = await _storage.getActiveFruitId();
    notifyListeners();
  }

  // ── Game Loop Control ──────────────────────────────────────────────────────

  void startGame() {
    score = 0;
    lives = 3;
    fallingFruits = [];
    _elapsedMs = 0;
    gameState = GameState.playing;
    notifyListeners();

    // Main tick: moves fruits and checks collisions
    _ticker = Timer.periodic(
      const Duration(milliseconds: _tickMs),
      _tick,
    );

    // Spawn timer: adds new fruits periodically
    _spawnTimer = Timer.periodic(
      const Duration(milliseconds: _spawnIntervalMs),
      (_) => _spawnFruit(),
    );

    // Spawn the first fruit immediately
    _spawnFruit();
  }

  void pauseGame() {
    if (gameState != GameState.playing) return;
    _ticker?.cancel();
    _spawnTimer?.cancel();
    gameState = GameState.paused;
    notifyListeners();
  }

  void resumeGame() {
    if (gameState != GameState.paused) return;
    gameState = GameState.playing;
    _ticker = Timer.periodic(
      const Duration(milliseconds: _tickMs),
      _tick,
    );
    _spawnTimer = Timer.periodic(
      const Duration(milliseconds: _spawnIntervalMs),
      (_) => _spawnFruit(),
    );
    notifyListeners();
  }

  void _endGame() {
    _ticker?.cancel();
    _spawnTimer?.cancel();
    gameState = GameState.gameOver;

    // Convert score to coins and persist
    final earned = score * _coinsPerPoint;
    coins += earned;
    _storage.setCoins(coins);
    _storage.updateHighScore(score).then((_) async {
      highScore = await _storage.getHighScore();
      notifyListeners();
    });

    notifyListeners();
  }

  // ── Tick: movement + collision ─────────────────────────────────────────────

  void _tick(Timer t) {
    if (gameState != GameState.playing) return;
    _elapsedMs += _tickMs;

    final double basketLeft = basketX * screenWidth - basketWidth / 2;
    final double basketRight = basketLeft + basketWidth;
    // Basket is at the bottom of the game area
    final double basketTop = screenHeight - 130;
    final double basketBottom = basketTop + basketHeight;

    bool dirty = false;

    for (final fruit in fallingFruits) {
      if (fruit.caught || fruit.missed) continue;

      fruit.y += fruit.speed;
      dirty = true;

      // Catch detection: fruit centre hits basket rect
      final double fruitCenterX = fruit.x;
      final double fruitCenterY = fruit.y + fruit.size / 2;

      if (fruitCenterX >= basketLeft &&
          fruitCenterX <= basketRight &&
          fruitCenterY >= basketTop &&
          fruitCenterY <= basketBottom) {
        fruit.caught = true;
        score += activeFruit.pointValue;
        dirty = true;
        continue;
      }

      // Miss detection: fruit went off screen bottom
      if (fruit.y > screenHeight) {
        fruit.missed = true;
        lives--;
        dirty = true;
        if (lives <= 0) {
          _endGame();
          return;
        }
      }
    }

    // Remove fully processed fruits to keep the list small
    fallingFruits.removeWhere((f) => f.caught || f.missed);

    if (dirty) notifyListeners();
  }

  // ── Spawn ──────────────────────────────────────────────────────────────────

  void _spawnFruit() {
    if (gameState != GameState.playing) return;
    fallingFruits.add(
      FallingFruit.spawn(
        emoji: activeFruit.emoji,
        screenWidth: screenWidth,
        baseSpeed: _baseSpeed,
        random: _random,
      ),
    );
    notifyListeners();
  }

  // ── Basket Control ─────────────────────────────────────────────────────────

  /// Called by the game widget when the user drags/taps to move the basket.
  void moveBasket(double globalX) {
    basketX = (globalX / screenWidth).clamp(0.0, 1.0);
    notifyListeners();
  }

  // ── Shop ───────────────────────────────────────────────────────────────────

  /// Returns true if purchase succeeded.
  Future<bool> purchaseFruit(FruitItem fruit) async {
    if (unlockedFruitIds.contains(fruit.id)) return false; // already owned
    final success = await _storage.spendCoins(fruit.price);
    if (!success) return false;
    coins -= fruit.price;
    unlockedFruitIds.add(fruit.id);
    await _storage.unlockFruit(fruit.id);
    notifyListeners();
    return true;
  }

  Future<void> selectFruit(String fruitId) async {
    if (!unlockedFruitIds.contains(fruitId)) return;
    activeFruitId = fruitId;
    await _storage.setActiveFruitId(fruitId);
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _spawnTimer?.cancel();
    super.dispose();
  }
}