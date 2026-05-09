import 'package:flutter/material.dart';
import '../widgets/fruit_bg.dart';

/// The Enthusiast's Page — plant growth guide.
/// Title is strictly 'Meraklısına'.
/// Back button → App Home Screen (pop).
class CuriosityPage extends StatelessWidget {
  const CuriosityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('🌿 Meraklısına',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19)),
        elevation: 0,
      ),
      body: Stack(children: [
        const FruitBg(),
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          itemCount: _plants.length,
          itemBuilder: (_, i) => _PlantCard(p: _plants[i]),
        ),
      ]),
    );
  }
}

// ── Plant card ────────────────────────────────────────────────────────────────

class _PlantCard extends StatelessWidget {
  final _Plant p;
  const _PlantCard({required this.p});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(children: [
        // Header gradient
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [p.c1, p.c2]),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Row(children: [
            Text(p.emoji, style: const TextStyle(fontSize: 52)),
            const SizedBox(width: 14),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                Text(p.nameTr,
                    style:
                        const TextStyle(fontSize: 13, color: Colors.white70)),
                const SizedBox(height: 6),
                _badge('${p.days} gün • Hasat'),
              ],
            )),
          ]),
        ),

        // Growth journey
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Büyüme Yolculuğu',
                style: TextStyle(
                    color: Color(0xFF2D6A4F),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5)),
            const SizedBox(height: 10),
            Row(children: [
              for (int i = 0; i < p.stages.length; i++) ...[
                Expanded(
                    child: Column(children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF4EC),
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFF2D6A4F), width: 2),
                    ),
                    child: Center(
                        child: Text(p.stages[i].emoji,
                            style: const TextStyle(fontSize: 26))),
                  ),
                  const SizedBox(height: 5),
                  Text(p.stages[i].label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D6A4F))),
                  Text(p.stages[i].days,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 9, color: Color(0xFF52796F))),
                ])),
                if (i < p.stages.length - 1)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: Icon(Icons.arrow_forward_ios_rounded,
                        size: 11, color: Color(0xFF2D6A4F)),
                  ),
              ],
            ]),
          ]),
        ),

        // Stats grid
        Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _stat('🌡️', 'Sıcaklık', p.temp, const Color(0xFFFFF8E1)),
              _stat('💧', 'Sulama', p.water, const Color(0xFFE3F2FD)),
              _stat('💦', 'Nem', p.humidity, const Color(0xFFE8F5E9)),
              _stat('📅', 'Ekim', p.season, const Color(0xFFFFFDE7)),
            ],
          ),
        ),

        // Tip
        if (p.tip.isNotEmpty)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4EC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFF2D6A4F).withValues(alpha: 0.3)),
            ),
            child: Row(children: [
              const Text('💡', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(p.tip,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2D6A4F),
                          height: 1.5))),
            ]),
          ),
      ]),
    );
  }

  Widget _badge(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(t,
            style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w700)),
      );

  Widget _stat(String icon, String label, String value, Color bg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF52796F),
                      fontWeight: FontWeight.w600)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B4332)),
                  overflow: TextOverflow.ellipsis),
            ],
          )),
        ]),
      );
}

// ── Data models ───────────────────────────────────────────────────────────────

class _Stage {
  final String emoji, label, days;
  const _Stage(this.emoji, this.label, this.days);
}

class _Plant {
  final String name, nameTr, emoji;
  final int days;
  final String temp, humidity, water, season, tip;
  final Color c1, c2;
  final List<_Stage> stages;
  const _Plant(
      {required this.name,
      required this.nameTr,
      required this.emoji,
      required this.days,
      required this.temp,
      required this.humidity,
      required this.water,
      required this.season,
      required this.tip,
      required this.c1,
      required this.c2,
      required this.stages});
}

// ── Plant catalogue ───────────────────────────────────────────────────────────
// Water field format: 'Haftada [X] gün, [Y] ml sulama'

const _plants = [
  _Plant(
      name: 'Strawberry',
      nameTr: 'Çilek',
      emoji: '🍓',
      days: 90,
      temp: '15–25°C',
      humidity: '%60–80',
      water: 'Haftada 3 gün, 200 ml sulama',
      season: 'İlkbahar',
      tip: 'Çiçeklenme döneminde aşırı sulamadan kaçının.',
      c1: Color(0xFFFF8FAB),
      c2: Color(0xFFB5173A),
      stages: [
        _Stage('🌱', 'Tohum', '0–7 g'),
        _Stage('🪴', 'Fide', '7–30 g'),
        _Stage('🌸', 'Çiçek', '30–60 g'),
        _Stage('🍓', 'Hasat', '60–90 g')
      ]),
  _Plant(
      name: 'Tomato',
      nameTr: 'Domates',
      emoji: '🍅',
      days: 80,
      temp: '18–27°C',
      humidity: '%50–70',
      water: 'Haftada 4 gün, 300 ml sulama',
      season: 'İlkbahar',
      tip: 'Günde en az 6 saat doğrudan güneş ışığı gerektirir.',
      c1: Color(0xFFFF8C42),
      c2: Color(0xFFAA2200),
      stages: [
        _Stage('🌱', 'Tohum', '0–10 g'),
        _Stage('🪴', 'Fide', '10–35 g'),
        _Stage('🌼', 'Çiçek', '35–60 g'),
        _Stage('🍅', 'Hasat', '60–80 g')
      ]),
  _Plant(
      name: 'Bell Pepper',
      nameTr: 'Biber',
      emoji: '🫑',
      days: 100,
      temp: '20–30°C',
      humidity: '%50–75',
      water: 'Haftada 2 gün, 250 ml sulama',
      season: 'İlkbahar',
      tip: 'Yeşilken de hasat edilebilir, kırmızıda daha tatlı.',
      c1: Color(0xFF8BC34A),
      c2: Color(0xFF2E5902),
      stages: [
        _Stage('🌱', 'Tohum', '0–14 g'),
        _Stage('🪴', 'Fide', '14–40 g'),
        _Stage('🌿', 'Büyüme', '40–75 g'),
        _Stage('🫑', 'Hasat', '75–100 g')
      ]),
  _Plant(
      name: 'Eggplant',
      nameTr: 'Patlıcan',
      emoji: '🍆',
      days: 110,
      temp: '22–30°C',
      humidity: '%60–70',
      water: 'Haftada 3 gün, 280 ml sulama',
      season: 'İlkbahar–Yaz',
      tip: 'Toprak 18°C altına düşerse büyüme yavaşlar.',
      c1: Color(0xFFCE93D8),
      c2: Color(0xFF4A0072),
      stages: [
        _Stage('🌱', 'Tohum', '0–12 g'),
        _Stage('🪴', 'Fide', '12–45 g'),
        _Stage('💜', 'Çiçek', '45–85 g'),
        _Stage('🍆', 'Hasat', '85–110 g')
      ]),
  _Plant(
      name: 'Corn',
      nameTr: 'Mısır',
      emoji: '🌽',
      days: 75,
      temp: '18–32°C',
      humidity: '%50–80',
      water: 'Haftada 4 gün, 350 ml sulama',
      season: 'Yaz',
      tip: 'Rüzgarla tozlaşır; en az 4 sıra yan yana ekin.',
      c1: Color(0xFFFFEB3B),
      c2: Color(0xFFE65100),
      stages: [
        _Stage('🌱', 'Tohum', '0–7 g'),
        _Stage('🌿', 'Filiz', '7–30 g'),
        _Stage('🌾', 'Püskül', '30–60 g'),
        _Stage('🌽', 'Hasat', '60–75 g')
      ]),
  _Plant(
      name: 'Watermelon',
      nameTr: 'Karpuz',
      emoji: '🍉',
      days: 90,
      temp: '22–35°C',
      humidity: '%50–65',
      water: 'Haftada 2 gün, 500 ml sulama',
      season: 'Yaz',
      tip: 'Meyvenin altına sap veya tahta koyun, çürümeyi önler.',
      c1: Color(0xFF80CBC4),
      c2: Color(0xFF004D40),
      stages: [
        _Stage('🌱', 'Tohum', '0–10 g'),
        _Stage('🌿', 'Sürüngen', '10–35 g'),
        _Stage('🌸', 'Çiçek', '35–60 g'),
        _Stage('🍉', 'Hasat', '60–90 g')
      ]),
  _Plant(
      name: 'Cherry',
      nameTr: 'Kiraz',
      emoji: '🍒',
      days: 365,
      temp: '10–20°C',
      humidity: '%50–70',
      water: 'Haftada 2 gün, 150 ml sulama',
      season: 'Sonbahar',
      tip: 'İlk meyve 3–5 yılda gelir; sabır gerektirir!',
      c1: Color(0xFFEF9A9A),
      c2: Color(0xFF8B0000),
      stages: [
        _Stage('🌱', 'Fidan', '0–30 g'),
        _Stage('🌳', 'Ağaç', '1–2 yıl'),
        _Stage('🌸', 'Çiçek', '3. yıl'),
        _Stage('🍒', 'Hasat', '3–5 yıl')
      ]),
  _Plant(
      name: 'Avocado',
      nameTr: 'Avokado',
      emoji: '🥑',
      days: 365,
      temp: '18–26°C',
      humidity: '%50–70',
      water: 'Haftada 2 gün, 400 ml sulama',
      season: 'İlkbahar',
      tip: 'Çekirdeği su bardağında köklendir, sonra toprağa aktar.',
      c1: Color(0xFFA5D6A7),
      c2: Color(0xFF1B5E20),
      stages: [
        _Stage('🪨', 'Çekirdek', '0–14 g'),
        _Stage('🌱', 'Kök', '14–60 g'),
        _Stage('🌿', 'Fidan', '60–365 g'),
        _Stage('🥑', 'Hasat', '3–5 yıl')
      ]),
  _Plant(
      name: 'Cucumber',
      nameTr: 'Salatalık',
      emoji: '🥒',
      days: 60,
      temp: '18–28°C',
      humidity: '%60–90',
      water: 'Haftada 4 gün, 300 ml sulama',
      season: 'İlkbahar–Yaz',
      tip: 'Düzenli hasat bitkiyi daha üretken yapar.',
      c1: Color(0xFF69F0AE),
      c2: Color(0xFF00600F),
      stages: [
        _Stage('🌱', 'Tohum', '0–7 g'),
        _Stage('🪴', 'Fide', '7–25 g'),
        _Stage('🌼', 'Çiçek', '25–45 g'),
        _Stage('🥒', 'Hasat', '45–60 g')
      ]),
  _Plant(
      name: 'Carrot',
      nameTr: 'Havuç',
      emoji: '🥕',
      days: 75,
      temp: '10–20°C',
      humidity: '%40–60',
      water: 'Haftada 3 gün, 180 ml sulama',
      season: 'İlkbahar–Sonbahar',
      tip: 'Gevşek, taşsız toprak için derin kazan.',
      c1: Color(0xFFFFCC80),
      c2: Color(0xFFBF360C),
      stages: [
        _Stage('🌱', 'Tohum', '0–14 g'),
        _Stage('🌿', 'Yaprak', '14–40 g'),
        _Stage('🟠', 'Kök', '40–65 g'),
        _Stage('🥕', 'Hasat', '65–75 g')
      ]),
  _Plant(
      name: 'Garlic',
      nameTr: 'Sarımsak',
      emoji: '🧄',
      days: 240,
      temp: '5–25°C',
      humidity: '%40–60',
      water: 'Haftada 2 gün, 120 ml sulama',
      season: 'Sonbahar',
      tip: 'Yapraklar sararınca hasat vakti gelmiştir.',
      c1: Color(0xFFFFF9C4),
      c2: Color(0xFF827717),
      stages: [
        _Stage('🌱', 'Diş', '0–21 g'),
        _Stage('🌿', 'Filiz', '21–90 g'),
        _Stage('💚', 'Büyüme', '90–200 g'),
        _Stage('🧄', 'Hasat', '200–240 g')
      ]),
  _Plant(
      name: 'Lemon',
      nameTr: 'Limon',
      emoji: '🍋',
      days: 365,
      temp: '15–30°C',
      humidity: '%50–70',
      water: 'Haftada 2 gün, 350 ml sulama',
      season: 'İlkbahar',
      tip: 'Kışın iç mekâna al; dona dayanıklı değildir.',
      c1: Color(0xFFFFF176),
      c2: Color(0xFFF9A825),
      stages: [
        _Stage('🌱', 'Fidan', '0–30 g'),
        _Stage('🌳', 'Ağaç', '1–2 yıl'),
        _Stage('🌸', 'Çiçek', '2–3 yıl'),
        _Stage('🍋', 'Hasat', '3–4 yıl')
      ]),
];
