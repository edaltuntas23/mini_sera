import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/fruit_item.dart';

class ShopProvider extends ChangeNotifier {
  static const String _coinsKey = 'coins';
  static const String _selectedKey = 'selected_fruit';
  static const String _unlockedPrefix = 'unlocked_';

  int _coins = 0;
  String _selectedFruitId = 'strawberry';

  final List<FruitItem> fruits = [
    FruitItem(
      id: 'strawberry',
      name: 'Strawberry',
      emoji: '🍓',
      price: 0,
      isUnlocked: true,
    ),
    FruitItem(id: 'tomato', name: 'Tomato', emoji: '🍅', price: 30),
    FruitItem(id: 'pepper', name: 'Bell Pepper', emoji: '🫑', price: 50),
    FruitItem(id: 'eggplant', name: 'Eggplant', emoji: '🍆', price: 80),
    FruitItem(id: 'corn', name: 'Corn', emoji: '🌽', price: 100),
    FruitItem(id: 'cherry', name: 'Cherry', emoji: '🍒', price: 120),
    FruitItem(id: 'watermelon', name: 'Watermelon', emoji: '🍉', price: 150),
    FruitItem(id: 'avocado', name: 'Avocado', emoji: '🥑', price: 200),
  ];

  int get coins => _coins;
  String get selectedFruitId => _selectedFruitId;
  String get selectedEmoji =>
      fruits.firstWhere((f) => f.id == _selectedFruitId).emoji;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _coins = prefs.getInt(_coinsKey) ?? 0;
    _selectedFruitId = prefs.getString(_selectedKey) ?? 'strawberry';
    for (final fruit in fruits) {
      if (fruit.price == 0) {
        fruit.isUnlocked = true;
      } else {
        fruit.isUnlocked =
            prefs.getBool('$_unlockedPrefix${fruit.id}') ?? false;
      }
    }
    notifyListeners();
  }

  Future<void> addCoins(int amount) async {
    _coins += amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_coinsKey, _coins);
    notifyListeners();
  }

  Future<bool> purchaseFruit(String fruitId) async {
    final fruit = fruits.firstWhere((f) => f.id == fruitId);
    if (fruit.isUnlocked) return false;
    if (_coins < fruit.price) return false;

    _coins -= fruit.price;
    fruit.isUnlocked = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_coinsKey, _coins);
    await prefs.setBool('$_unlockedPrefix$fruitId', true);
    notifyListeners();
    return true;
  }

  Future<void> selectFruit(String fruitId) async {
    final fruit = fruits.firstWhere((f) => f.id == fruitId);
    if (!fruit.isUnlocked) return;
    _selectedFruitId = fruitId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedKey, fruitId);
    notifyListeners();
  }
}
