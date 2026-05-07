import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _kCoins = 'coins';
  static const _kHighScore = 'high_score';

  Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kCoins) ?? 0;
  }

  Future<void> setCoins(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kCoins, value);
  }

  Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kHighScore) ?? 0;
  }

  Future<void> updateHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getHighScore();
    if (score > current) {
      await prefs.setInt(_kHighScore, score);
    }
  }
}
