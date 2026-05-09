import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import 'curiosity_page.dart';
import 'game_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fadeIn = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF0F7EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded,
                color: Color(0xFF2D6A4F), size: 28),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Text('🌱', style: TextStyle(fontSize: 20)),
                SizedBox(width: 4),
                Text('Mini Sera',
                    style: TextStyle(
                      color: Color(0xFF2D6A4F),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              ],
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideUp,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // ── Logo ──────────────────────────────────────────────
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFFB7E4C7), Color(0xFF52B788)],
                      center: Alignment(-0.3, -0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF52B788).withValues(alpha: 0.4),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🌱', style: TextStyle(fontSize: 64)),
                      SizedBox(height: 4),
                      Text('MINI SERA',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1B4332),
                            letterSpacing: 2,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // ── Welcome text ──────────────────────────────────────
                const Text(
                  'Mini Sera Uygulamasına\nHoş Geldiniz',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1B4332),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sera oyununu oyna, bitkiler hakkında öğren!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF52796F)),
                ),
                const SizedBox(height: 36),
                // ── Game card ─────────────────────────────────────────
                _NavCard(
                  emoji: '🎮',
                  title: 'Mini Greenhouse Oyunu',
                  subtitle: 'Düşen meyveleri yakala, coin kazan!',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF52B788), Color(0xFF2D6A4F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const GameScreen())),
                ),
                const SizedBox(height: 16),
                // ── Curiosity card ────────────────────────────────────
                _NavCard(
                  emoji: '🌿',
                  title: 'Meraklısına Sayfası',
                  subtitle: 'Bitki büyüme rehberi & bilgi kartları',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB7E4C7), Color(0xFF74C69D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  labelColor: const Color(0xFF1B4332),
                  subtitleColor: const Color(0xFF2D6A4F),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CuriosityPage())),
                ),
                const SizedBox(height: 32),
                // ── Tip box ───────────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8F3DC),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: const Color(0xFF95D5B2), width: 1.5),
                  ),
                  child: const Row(
                    children: [
                      Text('💡', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'İpucu: Çilekleri ilkbaharda ek, yaz başında hasat et. İdeal sıcaklık 15–25°C.',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1B4332),
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Nav Card ──────────────────────────────────────────────────────────────────

class _NavCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final Color labelColor;
  final Color subtitleColor;
  final VoidCallback onTap;

  const _NavCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
    this.labelColor = Colors.white,
    this.subtitleColor = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 44)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: labelColor)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(fontSize: 13, color: subtitleColor)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: labelColor.withValues(alpha: 0.7), size: 18),
          ],
        ),
      ),
    );
  }
}
