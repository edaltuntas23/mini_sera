import 'package:flutter/material.dart';

/// Shared decorative fruit emoji background for ALL pages.
class FruitBg extends StatelessWidget {
  const FruitBg({super.key});

  static const _items = [
    ('🍓', 0.04, 0.04, 28.0, 0.10),
    ('🥕', 0.82, 0.03, 22.0, 0.09),
    ('🌿', 0.48, 0.09, 26.0, 0.08),
    ('🍋', 0.90, 0.17, 22.0, 0.08),
    ('🌱', 0.10, 0.21, 20.0, 0.10),
    ('🍅', 0.65, 0.27, 26.0, 0.07),
    ('🥒', 0.02, 0.38, 20.0, 0.09),
    ('🍒', 0.86, 0.41, 20.0, 0.08),
    ('🌽', 0.40, 0.50, 24.0, 0.07),
    ('🧄', 0.18, 0.57, 20.0, 0.08),
    ('🥑', 0.72, 0.60, 24.0, 0.07),
    ('🍆', 0.07, 0.70, 20.0, 0.07),
    ('🍃', 0.88, 0.75, 22.0, 0.09),
    ('🍓', 0.54, 0.82, 20.0, 0.08),
    ('🥕', 0.28, 0.90, 22.0, 0.07),
    ('🌿', 0.76, 0.93, 20.0, 0.08),
  ];

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: Stack(
        children: _items
            .map((e) => Positioned(
                  left: e.$2 * sz.width,
                  top: e.$3 * sz.height,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: e.$5,
                      child: Text(e.$1, style: TextStyle(fontSize: e.$4)),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
