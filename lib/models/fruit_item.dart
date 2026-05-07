/// A purchasable/selectable fruit in the shop.
class FruitItem {
  final String id;
  final String name;
  final String emoji;
  final int price;
  bool isUnlocked;

  FruitItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
    this.isUnlocked = false,
  });
}
