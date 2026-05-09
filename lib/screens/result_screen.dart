import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import 'home_page.dart';
import 'game_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int coinsEarned;

  const ResultScreen({
    super.key,
    required this.score,
    required this.coinsEarned,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B1FA2), Color(0xFFE040FB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              ..._confetti.map((p) => Positioned(
                    left: p[0],
                    top: p[1],
                    child: Text('🍓', style: TextStyle(fontSize: p[2])),
                  )),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$score İsabet',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 16, color: Colors.black38)
                          ],
                        )),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🪙', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 8),
                          Text('+$coinsEarned Coin Kazandın!',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Column(
                  children: [
                    // Tekrar Oynat
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<GameProvider>().resetToIdle();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const GameScreen()),
                          );
                        },
                        icon: const Icon(Icons.replay),
                        label: const Text('Tekrar Oynat',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Geri Dön — NO addCoins here, coins already awarded
                    TextButton(
                      onPressed: () {
                        context.read<GameProvider>().resetToIdle();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                          (_) => false,
                        );
                      },
                      child: const Text('Geri Dön',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
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

  static const List<List<double>> _confetti = [
    [20, 80, 36],
    [280, 60, 28],
    [80, 180, 32],
    [300, 160, 40],
    [10, 300, 24],
    [330, 280, 36],
    [150, 380, 28],
    [260, 360, 32],
    [50, 460, 40],
    [310, 440, 24],
    [180, 520, 36],
    [30, 580, 28],
    [290, 560, 32],
    [120, 640, 40],
    [340, 620, 28],
    [70, 700, 36],
  ];
}
