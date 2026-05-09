import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fruit_item.dart';

/// ShopProvider manages two separate concerns:
///
/// 1. GAME fruit selection (coin-locked, persisted as `selected_fruit`).
///    Used by GamePage / MarketPage. Requires purchase.
///
/// 2. DASHBOARD fruit selection (always unlocked, persisted as `dashboard_fruit`).
///    Used by HomePage sensor widget only.
class ShopProvider extends ChangeNotifier {
  static const _coinsKey = 'coins';
  static const _selectedKey = 'selected_fruit';
  static const _unlockedPfx = 'unlocked_';

  int _coins = 0;

  /// Game-specific selected fruit (must be purchased).
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

  // ── Game selection ─────────────────────────────────────────────────────────
  String get selectedFruitId => _selectedId;
  String get selectedEmoji =>
      fruits.firstWhere((f) => f.id == _selectedId).emoji;
  String get selectedName => fruits.firstWhere((f) => f.id == _selectedId).name;

  Future<void> init() async {
    final p = await SharedPreferences.getInstance();
    _coins = p.getInt(_coinsKey) ?? 0;
    _selectedId = p.getString(_selectedKey) ?? 'strawberry';

    for (final f in fruits) {
      f.isUnlocked =
          f.price == 0 ? true : (p.getBool('$_unlockedPfx${f.id}') ?? false);
    }

    // Ensure selected game fruit is actually unlocked; fall back to strawberry.
    final sel = fruits.firstWhere(
      (f) => f.id == _selectedId,
      orElse: () => fruits.first,
    );
    if (!sel.isUnlocked) _selectedId = 'strawberry';

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

  /// Selects the active game fruit (requires isUnlocked).
  Future<void> selectFruit(String id) async {
    final f = fruits.firstWhere((x) => x.id == id);
    if (!f.isUnlocked) return;
    _selectedId = id;
    final p = await SharedPreferences.getInstance();
    await p.setString(_selectedKey, id);
    notifyListeners();
  }
}
