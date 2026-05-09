import 'package:flutter/material.dart';

class CuriosityPage extends StatelessWidget {
  const CuriosityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D6A4F),
        foregroundColor: Colors.white,
        title: const Text('🌿 Meraklısına Sayfası',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        itemCount: _plants.length,
        itemBuilder: (_, i) => _PlantCard(plant: _plants[i]),
      ),
    );
  }
}

// ── Plant Card ────────────────────────────────────────────────────────────────

class _PlantCard extends StatelessWidget {
  final _PlantData plant;
  const _PlantCard({required this.plant});

  @override
  Widget build(BuildContext context) {
    final p = plant;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [p.colorLight, p.colorDark]),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Text(p.ripeEmoji, style: const TextStyle(fontSize: 48)),
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
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white70)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('${p.daysToHarvest} gün • Hasat',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Growth journey
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Büyüme Yolculuğu',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D6A4F),
                        letterSpacing: 0.5)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (int i = 0; i < p.stages.length; i++) ...[
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD8F3DC),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color(0xFF95D5B2), width: 2),
                              ),
                              child: Center(
                                  child: Text(p.stages[i].emoji,
                                      style: const TextStyle(fontSize: 26))),
                            ),
                            const SizedBox(height: 6),
                            Text(p.stages[i].label,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D6A4F))),
                            Text(p.stages[i].days,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 9, color: Color(0xFF52796F))),
                          ],
                        ),
                      ),
                      if (i < p.stages.length - 1)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 18),
                          child: Icon(Icons.arrow_forward_ios_rounded,
                              size: 12, color: Color(0xFF95D5B2)),
                        ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Stats grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.6,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _Stat(
                    '🌡️', 'Sıcaklık', p.temperature, const Color(0xFFFFE8CC)),
                _Stat('💧', 'Su', p.water, const Color(0xFFCCE5FF)),
                _Stat('💦', 'Nem', p.humidity, const Color(0xFFD4EDDA)),
                _Stat('📅', 'Ekim', p.sowingSeason, const Color(0xFFFFF3CD)),
              ],
            ),
          ),
          // Tip
          if (p.tip.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD8F3DC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(p.tip,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1B4332),
                            height: 1.5)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;

  const _Stat(this.icon, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
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
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data ──────────────────────────────────────────────────────────────────────

class _Stage {
  final String emoji, label, days;
  const _Stage(this.emoji, this.label, this.days);
}

class _PlantData {
  final String name, nameTr, ripeEmoji;
  final int daysToHarvest;
  final String temperature, humidity, water, sowingSeason, tip;
  final Color colorLight, colorDark;
  final List<_Stage> stages;
  const _PlantData({
    required this.name,
    required this.nameTr,
    required this.ripeEmoji,
    required this.daysToHarvest,
    required this.temperature,
    required this.humidity,
    required this.water,
    required this.sowingSeason,
    required this.tip,
    required this.colorLight,
    required this.colorDark,
    required this.stages,
  });
}

const _plants = [
  _PlantData(
      name: 'Strawberry',
      nameTr: 'Çilek',
      ripeEmoji: '🍓',
      daysToHarvest: 90,
      temperature: '15–25°C',
      humidity: '%60–80',
      water: '2–3×/hafta',
      sowingSeason: 'İlkbahar',
      tip: 'Çiçeklenme döneminde aşırı su vermekten kaçının.',
      colorLight: Color(0xFFFF8FAB),
      colorDark: Color(0xFFD62839),
      stages: [
        _Stage('🌱', 'Tohum', '0–7 gün'),
        _Stage('🪴', 'Fide', '7–30 gün'),
        _Stage('🌸', 'Çiçek', '30–60 gün'),
        _Stage('🍓', 'Hasat', '60–90 gün')
      ]),
  _PlantData(
      name: 'Tomato',
      nameTr: 'Domates',
      ripeEmoji: '🍅',
      daysToHarvest: 80,
      temperature: '18–27°C',
      humidity: '%50–70',
      water: '3–4×/hafta',
      sowingSeason: 'İlkbahar',
      tip: 'Günde en az 6 saat doğrudan güneş ışığı gerekir.',
      colorLight: Color(0xFFFF8C42),
      colorDark: Color(0xFFCC3300),
      stages: [
        _Stage('🌱', 'Tohum', '0–10 gün'),
        _Stage('🪴', 'Fide', '10–35 gün'),
        _Stage('🌼', 'Çiçek', '35–60 gün'),
        _Stage('🍅', 'Hasat', '60–80 gün')
      ]),
  _PlantData(
      name: 'Bell Pepper',
      nameTr: 'Biber',
      ripeEmoji: '🫑',
      daysToHarvest: 100,
      temperature: '20–30°C',
      humidity: '%50–75',
      water: '2×/hafta',
      sowingSeason: 'İlkbahar',
      tip: 'Yeşil biberler olgunlaşmadan önce hasat edilebilir.',
      colorLight: Color(0xFF8BC34A),
      colorDark: Color(0xFF33691E),
      stages: [
        _Stage('🌱', 'Tohum', '0–14 gün'),
        _Stage('🪴', 'Fide', '14–40 gün'),
        _Stage('🌿', 'Gelişme', '40–75 gün'),
        _Stage('🫑', 'Hasat', '75–100 gün')
      ]),
  _PlantData(
      name: 'Eggplant',
      nameTr: 'Patlıcan',
      ripeEmoji: '🍆',
      daysToHarvest: 110,
      temperature: '22–30°C',
      humidity: '%60–70',
      water: '2–3×/hafta',
      sowingSeason: 'İlkbahar–Yaz',
      tip: 'Toprak sıcaklığı 18°C altına düşerse büyüme durur.',
      colorLight: Color(0xFFCE93D8),
      colorDark: Color(0xFF6A1B9A),
      stages: [
        _Stage('🌱', 'Tohum', '0–12 gün'),
        _Stage('🪴', 'Fide', '12–45 gün'),
        _Stage('💜', 'Çiçek', '45–85 gün'),
        _Stage('🍆', 'Hasat', '85–110 gün')
      ]),
  _PlantData(
      name: 'Corn',
      nameTr: 'Mısır',
      ripeEmoji: '🌽',
      daysToHarvest: 75,
      temperature: '18–32°C',
      humidity: '%50–80',
      water: '3–4×/hafta',
      sowingSeason: 'Yaz',
      tip: 'Mısır rüzgarla tozlaşır; en az 4 sıra yan yana ekin.',
      colorLight: Color(0xFFFFEB3B),
      colorDark: Color(0xFFF57F17),
      stages: [
        _Stage('🌱', 'Tohum', '0–7 gün'),
        _Stage('🌿', 'Filiz', '7–30 gün'),
        _Stage('🌾', 'Püskül', '30–60 gün'),
        _Stage('🌽', 'Hasat', '60–75 gün')
      ]),
  _PlantData(
      name: 'Watermelon',
      nameTr: 'Karpuz',
      ripeEmoji: '🍉',
      daysToHarvest: 90,
      temperature: '22–35°C',
      humidity: '%50–65',
      water: 'Seyrek ama derin',
      sowingSeason: 'Yaz',
      tip: 'Meyvenin altına sap koyun; yere temas çürümeye neden olur.',
      colorLight: Color(0xFF80CBC4),
      colorDark: Color(0xFF00695C),
      stages: [
        _Stage('🌱', 'Tohum', '0–10 gün'),
        _Stage('🌿', 'Sürüngen', '10–35 gün'),
        _Stage('🌸', 'Çiçek', '35–60 gün'),
        _Stage('🍉', 'Hasat', '60–90 gün')
      ]),
  _PlantData(
      name: 'Avocado',
      nameTr: 'Avokado',
      ripeEmoji: '🥑',
      daysToHarvest: 365,
      temperature: '18–26°C',
      humidity: '%50–70',
      water: 'Haftada 1–2',
      sowingSeason: 'İlkbahar',
      tip: 'Çekirdeği su bardağında köklendir, sonra toprağa aktar.',
      colorLight: Color(0xFFA5D6A7),
      colorDark: Color(0xFF2E7D32),
      stages: [
        _Stage('🪨', 'Çekirdek', '0–14 gün'),
        _Stage('🌱', 'Kök', '14–60 gün'),
        _Stage('🌿', 'Fidan', '60–365 gün'),
        _Stage('🥑', 'Hasat', '3–5 yıl')
      ]),
];
