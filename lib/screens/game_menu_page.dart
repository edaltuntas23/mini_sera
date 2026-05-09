import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shop_provider.dart';
import '../widgets/fruit_bg.dart';
import 'game_page.dart';
import 'market_page.dart';
import 'home_page.dart';

/// Game Main Menu.
/// Navigation:
///   Back button → HomePage (pushAndRemoveUntil — clears stack, no white screen)
///   Start Game  → GamePage
///   Market      → MarketPage (back from Market → GameMenuPage)
class GameMenuPage extends StatelessWidget {
  const GameMenuPage({super.key});

  /// Navigate cleanly back to HomePage, clearing everything above it.
  static void goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();

    return PopScope(
      // Intercept system back → go home cleanly
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) goHome(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF4EC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF2D6A4F)),
            onPressed: () => goHome(context),
            tooltip: 'Ana Sayfaya Dön',
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(children: [
                const Text('🪙', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 4),
                Text('${shop.coins}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D6A4F))),
              ]),
            ),
          ],
        ),
        body: Stack(children: [
          const FruitBg(),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo / hero
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                              colors: [Color(0xFF52B788), Color(0xFF1B4332)]),
                          border: Border.all(
                              color: const Color(0xFF52B788), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF52B788)
                                  .withValues(alpha: 0.35),
                              blurRadius: 32,
                              spreadRadius: 6,
                            )
                          ],
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(shop.selectedEmoji,
                                  style: const TextStyle(fontSize: 52)),
                              const SizedBox(height: 2),
                              const Text('OYUN',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2)),
                            ]),
                      ),

                      const SizedBox(height: 28),

                      const Text('Mini Greenhouse',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1B4332))),
                      const SizedBox(height: 6),
                      Text('Sepeti hareket ettir, ${shop.selectedEmoji} topla!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF2D6A4F))),

                      const SizedBox(height: 40),

                      // Start Game button
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const GamePage()),
                          ),
                          icon: const Icon(Icons.play_arrow_rounded, size: 26),
                          label: const Text('Oyunu Başlat',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D6A4F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            elevation: 4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Market button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MarketPage()),
                          ),
                          icon:
                              const Text('🛒', style: TextStyle(fontSize: 20)),
                          label: const Text('Market',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w700)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2D6A4F),
                            side: const BorderSide(
                                color: Color(0xFF2D6A4F), width: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Stats row
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: const Color(0xFF52B788)
                                  .withValues(alpha: 0.30)),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatChip(
                                  icon: '🪙',
                                  label: 'Coin',
                                  value: '${shop.coins}'),
                              _StatChip(
                                  icon: '🎮',
                                  label: 'Aktif',
                                  value: shop.selectedEmoji),
                              _StatChip(
                                  icon: '🔓',
                                  label: 'Açık',
                                  value:
                                      '${shop.fruits.where((f) => f.isUnlocked).length}/${shop.fruits.length}'),
                            ]),
                      ),
                    ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String icon, label, value;
  const _StatChip(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(icon, style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 2),
      Text(value,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1B4332))),
      Text(label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF52796F))),
    ]);
  }
}
