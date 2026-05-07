import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';
import 'shop_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0FFF0), Color(0xFFE8F5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CoinsDisplay(coins: provider.coins),
                    const SizedBox.shrink(),
                  ],
                ),
              ),

              const Spacer(),

              // ── Logo / Title ─────────────────────────────────────────────
              const Text('🌱', style: TextStyle(fontSize: 72)),
              const SizedBox(height: 12),
              const Text(
                'Mini Greenhouse',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E7D32),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Catch falling fruits to earn coins!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green.shade700,
                ),
              ),

              const SizedBox(height: 16),

              // ── Active fruit preview ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      provider.activeFruit.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.activeFruit.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        Text(
                          '+${provider.activeFruit.pointValue} pts each',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── High score ───────────────────────────────────────────────
              if (provider.highScore > 0)
                Text(
                  '🏆  Best: ${provider.highScore}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.amber.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              const Spacer(),

              // ── Buttons ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 24),
                child: Column(
                  children: [
                    _BigButton(
                      label: 'Play',
                      icon: Icons.play_arrow_rounded,
                      color: const Color(0xFF4CAF50),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const GameScreen()),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _BigButton(
                      label: 'Shop',
                      icon: Icons.storefront_rounded,
                      color: const Color(0xFFFF7043),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ShopScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _CoinsDisplay extends StatelessWidget {
  final int coins;
  const _CoinsDisplay({required this.coins});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD700)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🪙', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(
            '$coins',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Color(0xFF795548),
            ),
          ),
        ],
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BigButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 22),
        label: Text(
          label,
          style: const TextStyle(
              fontSize: 17, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
        ),
      ),
    );
  }
}