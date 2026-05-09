import 'package:flutter/material.dart';
import '../providers/game_provider.dart';

class BasketWidget extends StatelessWidget {
  const BasketWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: GameProvider.basketWidth,
      height: GameProvider.basketHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Colors.brown.shade600, Colors.brown.shade900],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: const Center(
        child: Text('🧺', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
