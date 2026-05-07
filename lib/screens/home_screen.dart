import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provides/game_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0FFF0), Color(0xFFE8F5E9)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score: ${provider.score}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            _BigButton(
              label: 'PLAY',
              icon: Icons.play_arrow,
              color: Colors.green,
              onTap: () => provider.startGame(),
            ),
          ],
        ),
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
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );
  }
}
