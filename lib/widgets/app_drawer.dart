import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shop_provider.dart';
import '../screens/game_menu_page.dart';
import '../screens/curiosity_page.dart';

/// Drawer navigation:
///   Home  →  (drawer)  →  closes drawer, stays on Home (already there)
///   Game  →  GameMenuPage (pushes)
///   Meraklısına  →  CuriosityPage (pushes)
///   Market is NOT in the drawer — accessible only from GameMenuPage.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // shop provider'ı hala diğer mantıklar için gerekebilir diye tutuyoruz
    // ancak coin gösteren widget'ı aşağıdan kaldırdık.
    context.watch<ShopProvider>();

    return Drawer(
      backgroundColor: const Color(0xFF0D1F16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFF52B788), width: 1.5),
                    ),
                    child: const Center(
                      child: Text('🌱', style: TextStyle(fontSize: 30)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Mini Sera',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'Sera oyunu & bitki rehberi',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  // Coin gösteren Container buradan kaldırıldı.
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Home ─────────────────────────────────────────────────────
            _Item(
              emoji: '🏠',
              label: 'Ana Sayfa',
              subtitle: 'Sensör paneli',
              onTap: () {
                Navigator.pop(context); // close drawer — we're already home
              },
            ),

            _divider(),

            // ── Game (→ GameMenuPage) ─────────────────────────────────────
            _Item(
              emoji: '🎮',
              label: 'Mini Greenhouse Oyunu',
              subtitle: 'Oyna ve coin kazan',
              onTap: () => _go(context, const GameMenuPage()),
            ),

            _divider(),

            // ── Meraklısına ───────────────────────────────────────────────
            _Item(
              emoji: '🌿',
              label: 'Meraklısına',
              subtitle: 'Bitki büyüme rehberi',
              onTap: () => _go(context, const CuriosityPage()),
            ),

            const Spacer(),

            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Mini Sera v1.0.0',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Color(0xFF2D6A4F)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Divider(color: Color(0xFF1A3328), height: 1),
      );

  void _go(BuildContext ctx, Widget page) {
    Navigator.pop(ctx); // close drawer first
    Navigator.push(ctx, MaterialPageRoute(builder: (_) => page));
  }
}

class _Item extends StatelessWidget {
  final String emoji, label, subtitle;
  final VoidCallback onTap;
  const _Item({
    required this.emoji,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFF1A3328),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
      ),
      title: Text(label,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 11, color: Color(0xFF52796F))),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: Color(0xFF2D6A4F), size: 20),
      onTap: onTap,
    );
  }
}
