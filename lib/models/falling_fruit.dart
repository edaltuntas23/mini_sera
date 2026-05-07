/// Represents a single falling fruit object on the game canvas.
class FallingFruit {
  /// Unique identifier for this fruit instance.
  final String id;

  /// Horizontal position from the left edge (0.0 to screenWidth - fruitSize).
  double x;

  /// Vertical position from the top edge (starts negative, moves downward).
  double y;

  /// The emoji symbol rendered as the fruit visual.
  final String emoji;

  /// How fast this fruit falls per game tick (pixels per tick).
  final double speed;

  FallingFruit({
    required this.id,
    required this.x,
    required this.y,
    required this.emoji,
    required this.speed,
  });
}
