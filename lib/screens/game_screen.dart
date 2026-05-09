import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../providers/shop_provider.dart';
import '../widgets/basket_widget.dart';
import '../widgets/fruit_widget.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _sizeSet = false;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final emoji = context.read<ShopProvider>().selectedEmoji;
      context.read<GameProvider>().setActiveEmoji(emoji);
    });
  }

  @override
  void dispose() {
    if (!_navigating) context.read<GameProvider>().resetToIdle();
    super.dispose();
  }

  void _goToResult(GameProvider game) {
    if (_navigating) return;
    _navigating = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (!game.coinsAwarded) {
        game.markCoinsAwarded();
        await context.read<ShopProvider>().addCoins(game.earnedCoins);
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            score: game.score,
            coinsEarned: game.earnedCoins,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    if (game.state == GameState.gameOver && !_navigating) {
      _goToResult(game);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            if (!_sizeSet && w > 0 && h > 0) {
              _sizeSet = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                context.read<GameProvider>().setScreenSize(w, h);
              });
            }

            return GestureDetector(
              onPanUpdate: (d) =>
                  context.read<GameProvider>().moveBasket(d.delta.dx),
              onTapDown: (d) =>
                  context.read<GameProvider>().setBasketX(d.localPosition.dx),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
                    child: _HudBar(score: game.score, lives: game.lives),
                  ),
                  for (final fruit in game.fruits)
                    Positioned(
                      left: fruit.x,
                      top: fruit.y,
                      child: FruitWidget(emoji: fruit.emoji),
                    ),
                  Positioned(
                    bottom: 80,
                    left: game.basketX - GameProvider.basketWidth / 2,
                    child: const BasketWidget(),
                  ),
                  if (game.state == GameState.idle)
                    Positioned.fill(
                      child: _StartOverlay(
                        onStart: () => context.read<GameProvider>().startGame(),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HudBar extends StatelessWidget {
  final int score;
  final int lives;
  const _HudBar({required this.score, required this.lives});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Text(i < lives ? '❤️' : '🖤',
                  style: const TextStyle(fontSize: 22)),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('Skor: $score',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32))),
        ),
      ],
    );
  }
}

class _StartOverlay extends StatelessWidget {
  final VoidCallback onStart;
  const _StartOverlay({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🍓', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 16),
            const Text('Başlamak için dokun!',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 8, color: Colors.black54)])),
            const SizedBox(height: 8),
            const Text('Sepeti sürükle veya dokun',
                style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43A047),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
              ),
              child: const Text('Oyunu Başlat',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
