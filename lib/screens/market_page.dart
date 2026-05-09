import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/fruit_item.dart';
import '../providers/shop_provider.dart';
import '../widgets/fruit_bg.dart';

// ── In-flight emoji model ─────────────────────────────────────────────────────

class _Flyer {
  final String id, emoji;
  final Offset start;
  _Flyer({required this.id, required this.emoji, required this.start});
}

// ── Market Page ───────────────────────────────────────────────────────────────

/// Wooden-stall themed Market.
/// Navigation: Back → GameMenuPage.
class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> with TickerProviderStateMixin {
  late final AnimationController _cartCtrl;
  late final Animation<double> _cartScale;
  final GlobalKey _cartKey = GlobalKey();
  final List<_Flyer> _flyers = [];

  @override
  void initState() {
    super.initState();
    _cartCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _cartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.40), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.40, end: 0.82), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.82, end: 1.04), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.04, end: 1.00), weight: 15),
    ]).animate(CurvedAnimation(parent: _cartCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _cartCtrl.dispose();
    super.dispose();
  }

  Offset _cartCenter() {
    final rb = _cartKey.currentContext?.findRenderObject() as RenderBox?;
    if (rb == null) return const Offset(52, 760);
    final pos = rb.localToGlobal(Offset.zero);
    return pos + Offset(rb.size.width / 2, rb.size.height / 2);
  }

  void _launch(String emoji, Offset start) {
    final id = '${DateTime.now().microsecondsSinceEpoch}_${emoji.hashCode}';
    setState(() => _flyers.add(_Flyer(id: id, emoji: emoji, start: start)));
  }

  void _onLanded(String id) {
    setState(() => _flyers.removeWhere((f) => f.id == id));
    _cartCtrl.forward(from: 0);
    HapticFeedback.mediumImpact();
  }

  Future<void> _handleTap(
      BuildContext ctx, FruitItem fruit, Offset tapGlobal) async {
    final shop = ctx.read<ShopProvider>();
    if (fruit.isUnlocked) {
      await shop.selectFruit(fruit.id);
      if (ctx.mounted) {
        _toast(ctx, '${fruit.emoji} ${fruit.name} seçildi!', true);
      }
    } else {
      _launch(fruit.emoji, tapGlobal);
      final ok = await shop.purchaseFruit(fruit.id);
      if (!ok) {
        setState(() => _flyers.removeWhere((f) => f.emoji == fruit.emoji));
        if (ctx.mounted) {
          _toast(ctx, 'Yeterli coin yok! Gerekli: ${fruit.price} 🪙', false);
        }
      } else {
        await shop.selectFruit(fruit.id);
        if (ctx.mounted) {
          _toast(ctx, '${fruit.emoji} ${fruit.name} açıldı!', true);
        }
      }
    }
  }

  void _toast(BuildContext ctx, String msg, bool ok) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: ok ? const Color(0xFF52B788) : const Color(0xFFFF6B6B),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final fruits = shop.fruits;

    // Pair into rows of 2
    final rows = <List<FruitItem>>[];
    for (var i = 0; i < fruits.length; i += 2) {
      rows.add(fruits.sublist(i, (i + 2).clamp(0, fruits.length)));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5C3317),
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black45,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          tooltip: 'Oyun Menüsüne Dön',
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('🛒 Manav Market',
            style: TextStyle(
                fontWeight: FontWeight.w900, fontSize: 17, letterSpacing: 0.3)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(children: [
              const Text('🪙', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 4),
              Text('${shop.coins}',
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700))),
            ]),
          ),
        ],
      ),
      body: Stack(children: [
        // ── Fruit background ──────────────────────────────────────────
        const FruitBg(),

        // ── Stall layout ──────────────────────────────────────────────
        Column(children: [
          _StallSignBanner(selectedEmoji: shop.selectedEmoji),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
              itemCount: rows.length,
              itemBuilder: (_, i) => _ShelfRow(
                fruits: rows[i],
                selectedId: shop.selectedFruitId,
                onTap: _handleTap,
              ),
            ),
          ),
        ]),

        // ── Parabolic flyers ──────────────────────────────────────────
        for (final f in _flyers)
          _ParabolicFlyer(
            key: ValueKey(f.id),
            emoji: f.emoji,
            start: f.start,
            targetResolver: _cartCenter,
            onLanded: () => _onLanded(f.id),
          ),

        // ── Borderless shopping cart (bottom-left) ────────────────────
        Positioned(
          left: 16,
          bottom: 20,
          child: _CartWidget(key: _cartKey, scaleAnim: _cartScale),
        ),
      ]),
    );
  }
}

// ── Stall sign banner ─────────────────────────────────────────────────────────

class _StallSignBanner extends StatelessWidget {
  final String selectedEmoji;
  const _StallSignBanner({required this.selectedEmoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B3F00), Color(0xFF5C3317)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4A017), width: 2),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(children: [
        const Text('🏪', style: TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Taze Ürünler',
                style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 0.4)),
            const SizedBox(height: 2),
            Text('Coin harca, meyve aç! Aktif: $selectedEmoji',
                style: const TextStyle(
                    color: Color(0xFFF5DEB3), fontSize: 11, height: 1.3)),
          ]),
        ),
        const Text('🎪', style: TextStyle(fontSize: 22)),
      ]),
    );
  }
}

// ── Shelf row ─────────────────────────────────────────────────────────────────

class _ShelfRow extends StatelessWidget {
  final List<FruitItem> fruits;
  final String selectedId;
  final Future<void> Function(BuildContext, FruitItem, Offset) onTap;

  const _ShelfRow({
    required this.fruits,
    required this.selectedId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: fruits.map((fruit) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _FruitStall(
                  fruit: fruit,
                  isSelected: fruit.id == selectedId,
                  onTap: (global) => onTap(context, fruit, global),
                ),
              ),
            );
          }).toList(),
        ),
        // Wooden plank
        Container(
          height: 18,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7B4A1E), Color(0xFF9C5F2A), Color(0xFF7B4A1E)],
              stops: [0.0, 0.50, 1.0],
            ),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 5)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              10,
              (_) => Container(
                  width: 1.2,
                  height: 12,
                  color: Colors.black.withValues(alpha: 0.12)),
            ),
          ),
        ),
        // Wall below plank
        Container(
          height: 10,
          margin: const EdgeInsets.only(left: 6, right: 6, bottom: 14),
          decoration: const BoxDecoration(
            color: Color(0xFFDDC4A0),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
          ),
        ),
      ],
    );
  }
}

// ── Fruit item (no box/border — sits directly on shelf) ──────────────────────

class _FruitStall extends StatelessWidget {
  final FruitItem fruit;
  final bool isSelected;
  final void Function(Offset tapGlobal) onTap;

  const _FruitStall({
    required this.fruit,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardKey = GlobalKey();
    return GestureDetector(
      key: cardKey,
      onTap: () {
        final rb = cardKey.currentContext?.findRenderObject() as RenderBox?;
        final centre = rb != null
            ? rb.localToGlobal(Offset(rb.size.width / 2, rb.size.height / 2))
            : Offset(MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height / 2);
        onTap(centre);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Emoji — direct on shelf, no card border
          Stack(alignment: Alignment.center, children: [
            AnimatedScale(
              scale: isSelected ? 1.12 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                fruit.emoji,
                style: TextStyle(
                    fontSize: 52, color: fruit.isUnlocked ? null : null),
              ),
            ),
            if (!fruit.isUnlocked)
              Positioned(
                bottom: 0,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5C3317),
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFFD4A017), width: 1.2),
                  ),
                  child: const Icon(Icons.lock_rounded,
                      size: 11, color: Color(0xFFFFD700)),
                ),
              ),
            if (isSelected && fruit.isUnlocked)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D6A4F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      size: 10, color: Colors.white),
                ),
              ),
          ]),

          const SizedBox(height: 4),
          Text(fruit.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: fruit.isUnlocked
                      ? const Color(0xFF3E2000)
                      : const Color(0xFF7A5C2E))),
          const SizedBox(height: 4),

          // Price badge or owned badge — small, understated
          if (fruit.isUnlocked)
            Text(
              isSelected ? '✓ Seçili' : 'Sahip',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? const Color(0xFF2D6A4F)
                      : const Color(0xFF7B4A1E)),
            )
          else
            Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('🪙', style: TextStyle(fontSize: 11)),
              const SizedBox(width: 3),
              Text('${fruit.price}',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF5C3317))),
            ]),
        ]),
      ),
    );
  }
}

// ── Borderless shopping cart ──────────────────────────────────────────────────

class _CartWidget extends StatelessWidget {
  final Animation<double> scaleAnim;
  const _CartWidget({super.key, required this.scaleAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scaleAnim,
      builder: (_, child) =>
          Transform.scale(scale: scaleAnim.value, child: child),
      child: const Text('🛒', style: TextStyle(fontSize: 56)),
    );
  }
}

// ── Parabolic flyer ───────────────────────────────────────────────────────────

class _ParabolicFlyer extends StatefulWidget {
  final String emoji;
  final Offset start;
  final Offset Function() targetResolver;
  final VoidCallback onLanded;

  const _ParabolicFlyer({
    super.key,
    required this.emoji,
    required this.start,
    required this.targetResolver,
    required this.onLanded,
  });

  @override
  State<_ParabolicFlyer> createState() => _ParabolicFlyerState();
}

class _ParabolicFlyerState extends State<_ParabolicFlyer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Offset _target;

  @override
  void initState() {
    super.initState();
    _target = widget.targetResolver();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 620));
    _ctrl.forward().whenComplete(() {
      if (mounted) widget.onLanded();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double flyerSize = 44;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = Curves.easeInOut.transform(_ctrl.value);
        final midX = (widget.start.dx + _target.dx) / 2;
        const arcHeight = 200.0;
        final minY = min(widget.start.dy, _target.dy);
        final cy = minY - arcHeight;
        final mt = 1 - t;

        final x =
            mt * mt * widget.start.dx + 2 * mt * t * midX + t * t * _target.dx;
        final y =
            mt * mt * widget.start.dy + 2 * mt * t * cy + t * t * _target.dy;

        final scale = 1.0 - t * 0.75;
        final opacity =
            t < 0.80 ? 1.0 : (1.0 - (t - 0.80) / 0.20).clamp(0.0, 1.0);
        final angle = t * 2 * pi;

        return Positioned(
          left: x - flyerSize / 2,
          top: y - flyerSize / 2,
          child: Opacity(
            opacity: opacity,
            child: Transform.rotate(
              angle: angle,
              child: Transform.scale(
                scale: scale,
                child: Text(widget.emoji,
                    style: const TextStyle(fontSize: flyerSize)),
              ),
            ),
          ),
        );
      },
    );
  }
}
