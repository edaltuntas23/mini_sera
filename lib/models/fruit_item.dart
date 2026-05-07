/// Represents a purchasable/unlockable fruit item in the shop.
class FruitItem {
  final String id;
  final String name;
  final String emoji;
  final int price; // 0 = free/default
  final int pointValue; // how many points catching this gives

  const FruitItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
    this.pointValue = 1,
  });
}

/// All available fruits in the game.
class FruitCatalog {
  static const List<FruitItem> all = [
    FruitItem(
      id: 'strawberry',
      name: 'Strawberry',
      emoji: '🍓',
      price: 0,
      pointValue: 1,
    ),
    FruitItem(
      id: 'tomato',
      name: 'Tomato',
      emoji: '🍅',
      price: 50,
      pointValue: 2,
    ),
    FruitItem(
      id: 'eggplant',
      name: 'Eggplant',
      emoji: '🍆',
      price: 80,
      pointValue: 2,
    ),
    FruitItem(
      id: 'bell_pepper',
      name: 'Bell Pepper',
      emoji: '🫑',
      price: 120,
      pointValue: 3,
    ),
    FruitItem(
      id: 'carrot',
      name: 'Carrot',
      emoji: '🥕',
      price: 150,
      pointValue: 3,
    ),
    FruitItem(
      id: 'corn',
      name: 'Corn',
      emoji: '🌽',
      price: 200,
      pointValue: 5,
    ),
  ];

  static FruitItem getById(String id) {
    return all.firstWhere(
      (f) => f.id == id,
      orElse: () => all.first,
    );
  }
}