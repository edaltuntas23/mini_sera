import 'package:shared_preferences/shared_preferences.dart';

/// Handles all persistent storage for the game using SharedPreferences.
class StorageService {
  static const _keyCoins = 'mini_greenhouse_coins';
  static const _keyUnlocked = 'mini_greenhouse_unlocked';
  static const _keyActiveFruit = 'mini_greenhouse_active_fruit';
  static const _keyHighScore = 'mini_greenhouse_high_score';

  // ── Coins ──────────────────────────────────────────────────────────────────

  Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCoins) ?? 0;
  }

  Future<void> setCoins(int coins) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCoins, coins);
  }

  Future<void> addCoins(int amount) async {
    final current = await getCoins();
    await setCoins(current + amount);
  }

  Future<bool> spendCoins(int amount) async {
    final current = await getCoins();
    if (current < amount) return false;
    await setCoins(current - amount);
    return true;
  }

  // ── Unlocked Fruits ────────────────────────────────────────────────────────

  Future<List<String>> getUnlockedFruits() async {
    final prefs = await SharedPreferences.getInstance();
    // 'strawberry' is always unlocked by default
    return prefs.getStringList(_keyUnlocked) ?? ['strawberry'];
  }

  Future<void> unlockFruit(String fruitId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getUnlockedFruits();
    if (!current.contains(fruitId)) {
      current.add(fruitId);
      await prefs.setStringList(_keyUnlocked, current);
    }
  }

  // ── Active Fruit ───────────────────────────────────────────────────────────

  Future<String> getActiveFruitId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyActiveFruit) ?? 'strawberry';
  }

  Future<void> setActiveFruitId(String fruitId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyActiveFruit, fruitId);
  }

  // ── High Score ─────────────────────────────────────────────────────────────

  Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyHighScore) ?? 0;
  }

  Future<void> updateHighScore(int score) async {
    final current = await getHighScore();
    if (score > current) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyHighScore, score);
    }
  }
}