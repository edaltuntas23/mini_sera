import 'package:flutter/material.dart';
import '../providers/game_provider.dart';

class FruitWidget extends StatelessWidget {
  final String emoji;
  const FruitWidget({super.key, required this.emoji});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: GameProvider.fruitSize,
      height: GameProvider.fruitSize,
      child: FittedBox(child: Text(emoji)),
    );
  }
}
