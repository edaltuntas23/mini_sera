import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sensor_provider.dart';
import '../providers/shop_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/fruit_bg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sensor = context.watch<SensorProvider>();
    final shop = context.watch<ShopProvider>();
    final allFruits = shop.fruits;
    final dashFruit = allFruits.firstWhere(
      (f) => f.id == sensor.dashboardFruitId,
      orElse: () => allFruits.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4EC),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded,
                color: Color(0xFF2D6A4F), size: 28),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
            tooltip: 'Menü',
          ),
        ),
      ),
      body: Stack(
        children: [
          const FruitBg(),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
            child: Column(children: [
              const _LogoSection(),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => _showDashboardFruitPicker(context, shop, sensor),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFF52B788).withValues(alpha: 0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF52B788).withValues(alpha: 0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(children: [
                    Text(dashFruit.emoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('İzlenen Bitki',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF52796F),
                                    fontWeight: FontWeight.w600)),
                            Text(dashFruit.name,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1B4332))),
                          ]),
                    ),
                    const Icon(Icons.expand_more_rounded,
                        color: Color(0xFF2D6A4F), size: 22),
                  ]),
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                _PulseDot(),
                const SizedBox(width: 8),
                const Text('CANLI SENSÖR VERİSİ',
                    style: TextStyle(
                        color: Color(0xFF2D6A4F),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2)),
              ]),
              const SizedBox(height: 12),
              _UnifiedSensorCard(sensor: sensor),
              const SizedBox(height: 16),
              _HealthCard(sensor: sensor),
            ]),
          ),
        ],
      ),
    );
  }

  void _showDashboardFruitPicker(
      BuildContext context, ShopProvider shop, SensorProvider sensor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _DashboardFruitPickerSheet(shop: shop, sensor: sensor),
    );
  }
}

class _DashboardFruitPickerSheet extends StatelessWidget {
  final ShopProvider shop;
  final SensorProvider sensor;
  const _DashboardFruitPickerSheet({required this.shop, required this.sensor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D1F16),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
              color: const Color(0xFF2D6A4F),
              borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(height: 16),
        const Text('İzlenen Bitkiyi Seç',
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text('Tüm bitkiler dashboard için erişilebilir',
            style: TextStyle(color: Color(0xFF52796F), fontSize: 12)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: shop.fruits.map((f) {
            final selected = f.id == sensor.dashboardFruitId;
            return GestureDetector(
              onTap: () {
                sensor.setDashboardFruit(f.id, f.name, f.emoji);
                Navigator.pop(context);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF2D6A4F)
                      : const Color(0xFF1A3328),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: selected
                          ? const Color(0xFF52B788)
                          : Colors.transparent,
                      width: 2),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(f.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Text(f.name,
                      style: TextStyle(
                          color:
                              selected ? Colors.white : const Color(0xFF95D5B2),
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                ]),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}

class _UnifiedSensorCard extends StatelessWidget {
  final SensorProvider sensor;
  const _UnifiedSensorCard({required this.sensor});

  @override
  Widget build(BuildContext context) {
    final range = sensor.currentRange;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: const Color(0xFF52B788).withValues(alpha: 0.30), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF2D6A4F).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(children: [
        Row(children: [
          Expanded(
              child: _MetricTile(
                  icon: '🌡️',
                  label: 'Sıcaklık',
                  value: '${sensor.temperature.toStringAsFixed(1)}°C',
                  status: sensor.tempStatus)),
          _vDivider(),
          Expanded(
              child: _MetricTile(
                  icon: '💧',
                  label: 'Nem',
                  value: '%${sensor.humidity.toStringAsFixed(1)}',
                  status: sensor.humidityStatus)),
          _vDivider(),
          Expanded(
              child: _MetricTile(
                  icon: '🚿',
                  label: 'Su',
                  value: '${sensor.waterLevel.toStringAsFixed(0)}ml',
                  status: sensor.waterStatus)),
        ]),
        const SizedBox(height: 14),
        _SensorBar(
            label: 'Sıcaklık',
            fill: ((sensor.temperature - 5) / 35).clamp(0.0, 1.0),
            color: _tempColor(sensor.temperature),
            ideal: range.tempLabel),
        const SizedBox(height: 8),
        _SensorBar(
            label: 'Nem',
            fill: (sensor.humidity / 100).clamp(0.0, 1.0),
            color: const Color(0xFF48CAE4),
            ideal: range.humidLabel),
        const SizedBox(height: 8),
        _SensorBar(
            label: 'Su Seviyesi',
            fill: (sensor.waterLevel / 1000).clamp(0.0, 1.0),
            color: const Color(0xFF0096C7),
            ideal: range.waterLabel),
      ]),
    );
  }

  Widget _vDivider() => Container(
        width: 1,
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: const Color(0xFF2D6A4F).withValues(alpha: 0.15),
      );

  static Color _tempColor(double t) {
    if (t < 15) return const Color(0xFF90E0EF);
    if (t > 28) return const Color(0xFFFF6B6B);
    return const Color(0xFF52B788);
  }
}

class _MetricTile extends StatelessWidget {
  final String icon, label, value;
  final SensorStatus status;
  const _MetricTile(
      {required this.icon,
      required this.label,
      required this.value,
      required this.status});

  Color get _statusColor => switch (status) {
        SensorStatus.normal => const Color(0xFF2D6A4F),
        SensorStatus.warning => const Color(0xFFFFB703),
        SensorStatus.danger => const Color(0xFFFF6B6B),
      };

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(icon, style: const TextStyle(fontSize: 22)),
      const SizedBox(height: 4),
      Text(value,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w900, color: _statusColor)),
      Text(label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF52796F))),
    ]);
  }
}

class _SensorBar extends StatelessWidget {
  final String label, ideal;
  final double fill;
  final Color color;
  const _SensorBar(
      {required this.label,
      required this.fill,
      required this.color,
      required this.ideal});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
        width: 70,
        child: Text(label,
            style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF52796F),
                fontWeight: FontWeight.w600)),
      ),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: fill,
            minHeight: 8,
            backgroundColor: const Color(0xFF2D6A4F).withValues(alpha: 0.08),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Text(ideal,
          style: const TextStyle(fontSize: 9, color: Color(0xFF52796F))),
    ]);
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF52B788), width: 2.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF52B788).withValues(alpha: 0.30),
              blurRadius: 28,
              spreadRadius: 4,
            )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Transform.scale(
          scale: 1.25,
          child: Image.asset(
            'assets/app_logo.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF1B4332),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🌿', style: TextStyle(fontSize: 42)),
                  SizedBox(height: 2),
                  Text('MINI SERA',
                      style: TextStyle(
                          fontSize: 8,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2)),
                ],
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 14),
      const Text('Mini Sera Uygulamasına Hoş Geldiniz',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0xFF1B4332),
              fontSize: 16,
              fontWeight: FontWeight.w700)),
    ]);
  }
}

class _HealthCard extends StatelessWidget {
  final SensorProvider sensor;
  const _HealthCard({required this.sensor});

  @override
  Widget build(BuildContext context) {
    final score = [sensor.tempStatus, sensor.humidityStatus, sensor.waterStatus]
        .where((s) => s == SensorStatus.normal)
        .length;

    final (emoji, label, color) = switch (score) {
      3 => ('🌟', 'Mükemmel! Sera koşulları ideal.', const Color(0xFF2D6A4F)),
      2 => (
          '✅',
          'İyi. Küçük ayarlamalar gerekebilir.',
          const Color(0xFF52B788)
        ),
      1 => (
          '⚠️',
          'Dikkat! Birden fazla sorun tespit edildi.',
          const Color(0xFFFFB703)
        ),
      _ => ('🆘', 'Acil müdahale gerekiyor!', const Color(0xFFFF6B6B)),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.40), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.10),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(width: 14),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Sera Sağlık Skoru: $score/3',
                style: TextStyle(
                    color: color, fontSize: 14, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF2D6A4F), fontSize: 12, height: 1.4)),
          ]),
        ),
      ]),
    );
  }
}

class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _anim,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
              color: Color(0xFF2D6A4F), shape: BoxShape.circle),
        ),
      );
}
