import 'dart:math';

class FallingFruit {
  double x;
  double y;
  final double speed;
  final double size;
  final String emoji;
  bool caught;
  bool missed;

  FallingFruit({
    required this.x,
    required this.y,
    required this.speed,
    this.size = 40.0,
    required this.emoji,
    this.caught = false,
    this.missed = false,
  });

  static FallingFruit spawn({
    required String emoji,
    required double screenWidth,
    required double baseSpeed,
    required Random random,
  }) {
    return FallingFruit(
      x: random.nextDouble() * (screenWidth - 40),
      y: -50,
      speed: baseSpeed + random.nextDouble() * 2,
      emoji: emoji,
    );
  }
}
