import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../providers/shop_provider.dart';
import '../widgets/basket_widget.dart';
import '../widgets/fruit_widget.dart';
import '../widgets/fruit_bg.dart';
import 'game_menu_page.dart';
import 'result_screen.dart';

/// Game Page — full-screen fruit catcher.
///
/// Navigation:
///   Back / exit confirmed  →  GameMenuPage (via pushAndRemoveUntil)
///   Game Over              →  ResultScreen (pushReplacement)
class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _sizeSet = false;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Use the GAME-specific selected emoji (coin-locked)
      context
          .read<GameProvider>()
          .setActiveEmoji(context.read<ShopProvider>().selectedEmoji);
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
        // 1:1 — earnedCoins == score
        await context.read<ShopProvider>().addCoins(game.earnedCoins);
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ResultScreen(score: game.score, coinsEarned: game.earnedCoins),
        ),
      );
    });
  }

  Future<void> _confirmExit(BuildContext context) async {
    final game = context.read<GameProvider>();

    if (game.state != GameState.playing) {
      game.resetToIdle();
      if (mounted) _goToMenu();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A3328),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Oyundan Çık?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Mevcut ilerleme kaydedilmeyecek. Çıkmak istiyor musun?',
          style: TextStyle(color: Color(0xFF95D5B2)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Devam Et',
                style: TextStyle(color: Color(0xFF52B788))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Çık'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      game.resetToIdle();
      _goToMenu();
    }
  }

  /// Navigate to GameMenuPage, clearing this page from the stack.
  void _goToMenu() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const GameMenuPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    if (game.state == GameState.gameOver && !_navigating) _goToResult(game);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF4EC),
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
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
              child: Stack(children: [
                const FruitBg(),

                // ── HUD ────────────────────────────────────────────────────
                Positioned(
                  top: 8,
                  left: 8,
                  right: 8,
                  child: _Hud(
                    score: game.score,
                    lives: game.lives,
                    onBack: () => _confirmExit(context),
                  ),
                ),

                // ── Falling fruits ─────────────────────────────────────────
                for (final fruit in game.fruits)
                  Positioned(
                    left: fruit.x,
                    top: fruit.y,
                    child: FruitWidget(emoji: fruit.emoji),
                  ),

                // ── Basket ─────────────────────────────────────────────────
                Positioned(
                  bottom: 80,
                  left: game.basketX - GameProvider.basketWidth / 2,
                  child: const BasketWidget(),
                ),

                // ── Idle overlay ───────────────────────────────────────────
                if (game.state == GameState.idle)
                  Positioned.fill(
                    child: _IdleOverlay(
                      onStart: () => context.read<GameProvider>().startGame(),
                    ),
                  ),
              ]),
            );
          }),
        ),
      ),
    );
  }
}

class _Hud extends StatelessWidget {
  final int score, lives;
  final VoidCallback onBack;
  const _Hud({required this.score, required this.lives, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GestureDetector(
        onTap: onBack,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
        ),
      ),
      const SizedBox(width: 10),
      Row(
          children: List.generate(
        3,
        (i) => Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Text(i < lives ? '❤️' : '🖤',
              style: const TextStyle(fontSize: 20)),
        ),
      )),
      const Spacer(),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text('Skor: $score',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    ]);
  }
}

class _IdleOverlay extends StatelessWidget {
  final VoidCallback onStart;
  const _IdleOverlay({required this.onStart});

  @override
  Widget build(BuildContext context) {
    // Show the GAME-selected emoji (coin-locked selection)
    final shop = context.watch<ShopProvider>();
    return Container(
      color: Colors.black38,
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(shop.selectedEmoji, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          const Text('Başlamak için dokun!',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black54)])),
          const SizedBox(height: 8),
          Text('Sepeti sürükle, ${shop.selectedEmoji} topla!',
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF43A047),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
            ),
            child: const Text('Oyunu Başlat',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ]),
      ),
    );
  }
}
