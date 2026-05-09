import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../providers/shop_provider.dart';
import '../widgets/fruit_bg.dart';
import 'home_page.dart';
import 'game_page.dart';
import 'game_menu_page.dart';
import 'market_page.dart';

class ResultScreen extends StatelessWidget {
  final int score, coinsEarned;
  const ResultScreen(
      {super.key, required this.score, required this.coinsEarned});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();

    return PopScope(
      // System back → Game Menu (not a blank page)
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goToMenu(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF4EC),
        body: Stack(children: [
          const FruitBg(),

          // ── Back to home icon top-left ────────────────────────────────────
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: GestureDetector(
                  onTap: () => _goToHome(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color:
                              const Color(0xFF52B788).withValues(alpha: 0.4)),
                    ),
                    child: const Icon(Icons.home_rounded,
                        color: Color(0xFF2D6A4F), size: 22),
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // Game Over header
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B4332),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text('OYUN BİTTİ',
                            style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF95D5B2),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3)),
                      ),

                      const SizedBox(height: 20),

                      // Score
                      Text('$score',
                          style: const TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1B4332),
                              height: 1)),
                      const Text('İSABET',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D6A4F),
                              letterSpacing: 4)),

                      const SizedBox(height: 8),

                      // 1:1 hint
                      Text('= +$coinsEarned 🪙',
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF52796F),
                              fontWeight: FontWeight.w600)),

                      const SizedBox(height: 20),

                      // Coins earned + total
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                              color: const Color(0xFF52B788)
                                  .withValues(alpha: 0.4)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2D6A4F)
                                  .withValues(alpha: 0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(children: [
                                const Text('🪙',
                                    style: TextStyle(fontSize: 26)),
                                const SizedBox(height: 4),
                                Text('+$coinsEarned',
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF2D6A4F))),
                                const Text('Kazandın',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF52796F))),
                              ]),
                              Container(
                                  width: 1,
                                  height: 50,
                                  color: const Color(0xFF52B788)
                                      .withValues(alpha: 0.3)),
                              Column(children: [
                                const Text('💰',
                                    style: TextStyle(fontSize: 26)),
                                const SizedBox(height: 4),
                                Text('${shop.coins}',
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1B4332))),
                                const Text('Toplam',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF52796F))),
                              ]),
                            ]),
                      ),

                      const SizedBox(height: 28),

                      // Play Again
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<GameProvider>().resetToIdle();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const GamePage()));
                          },
                          icon: const Icon(Icons.replay_rounded, size: 22),
                          label: const Text('Tekrar Oyna',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D6A4F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            elevation: 4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(children: [
                        // Market
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                context.read<GameProvider>().resetToIdle();
                                // Market → back goes to GameMenuPage
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const MarketPage()),
                                  (route) => false,
                                );
                              },
                              icon: const Text('🛒',
                                  style: TextStyle(fontSize: 18)),
                              label: const Text('Market',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF2D6A4F),
                                side: const BorderSide(
                                    color: Color(0xFF2D6A4F), width: 2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Game Menu
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed: () => _goToMenu(context),
                              icon: const Icon(Icons.sports_esports_rounded,
                                  size: 18),
                              label: const Text('Menü',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1B4332),
                                side: const BorderSide(
                                    color: Color(0xFF1B4332), width: 2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _goToMenu(BuildContext context) {
    context.read<GameProvider>().resetToIdle();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const GameMenuPage()),
      (route) => false,
    );
  }

  void _goToHome(BuildContext context) {
    context.read<GameProvider>().resetToIdle();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }
}
