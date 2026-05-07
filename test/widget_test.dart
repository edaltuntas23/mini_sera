import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sera/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // MyApp() yerine MiniGreenhouseApp() kullanıyoruz
    await tester.pumpWidget(const MiniGreenhouseApp());

    expect(find.text('0'), findsOneWidget);
    // ... geri kalanı aynı
  });
}
