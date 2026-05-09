import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fruit_item.dart';

class ShopProvider extends ChangeNotifier {
  static const _coinsKey = 'coins';
  static const _selectedKey = 'selected_fruit';
  static const _unlockedPfx = 'unlocked_';

  int _coins = 0;
  String _selectedId = 'strawberry';

  final List<FruitItem> fruits = [
    FruitItem(
        id: 'strawberry',
        name: 'Strawberry',
        emoji: '🍓',
        price: 0,
        isUnlocked: true),
    FruitItem(id: 'tomato', name: 'Tomato', emoji: '🍅', price: 30),
    FruitItem(id: 'pepper', name: 'Bell Pepper', emoji: '🫑', price: 50),
    FruitItem(id: 'eggplant', name: 'Eggplant', emoji: '🍆', price: 80),
    FruitItem(id: 'corn', name: 'Corn', emoji: '🌽', price: 100),
    FruitItem(id: 'cherry', name: 'Cherry', emoji: '🍒', price: 120),
    FruitItem(id: 'watermelon', name: 'Watermelon', emoji: '🍉', price: 150),
    FruitItem(id: 'avocado', name: 'Avocado', emoji: '🥑', price: 200),
  ];

  int get coins => _coins;
  String get selectedFruitId => _selectedId;
  String get selectedEmoji =>
      fruits.firstWhere((f) => f.id == _selectedId).emoji;

  Future<void> init() async {
    final p = await SharedPreferences.getInstance();
    _coins = p.getInt(_coinsKey) ?? 0;
    _selectedId = p.getString(_selectedKey) ?? 'strawberry';
    for (final f in fruits) {
      f.isUnlocked =
          f.price == 0 ? true : (p.getBool('$_unlockedPfx${f.id}') ?? false);
    }
    notifyListeners();
  }

  Future<void> addCoins(int n) async {
    _coins += n;
    final p = await SharedPreferences.getInstance();
    await p.setInt(_coinsKey, _coins);
    notifyListeners();
  }

  Future<bool> purchaseFruit(String id) async {
    final f = fruits.firstWhere((x) => x.id == id);
    if (f.isUnlocked || _coins < f.price) return false;
    _coins -= f.price;
    f.isUnlocked = true;
    final p = await SharedPreferences.getInstance();
    await p.setInt(_coinsKey, _coins);
    await p.setBool('$_unlockedPfx$id', true);
    notifyListeners();
    return true;
  }

  Future<void> selectFruit(String id) async {
    final f = fruits.firstWhere((x) => x.id == id);
    if (!f.isUnlocked) return;
    _selectedId = id;
    final p = await SharedPreferences.getInstance();
    await p.setString(_selectedKey, id);
    notifyListeners();
  }
}
