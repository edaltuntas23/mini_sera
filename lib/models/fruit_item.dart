class FruitItem {
  final String id, name, emoji;
  final int price;
  bool isUnlocked;
  FruitItem(
      {required this.id,
      required this.name,
      required this.emoji,
      required this.price,
      this.isUnlocked = false});
}
