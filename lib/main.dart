// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/game_provider.dart';
import 'providers/shop_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MiniGreenhouseApp());
}

class MiniGreenhouseApp extends StatelessWidget {
  const MiniGreenhouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // GameProvider handles the live game loop, score, and basket position.
        ChangeNotifierProvider(create: (_) => GameProvider()),
        // ShopProvider handles coin balance, unlocked fruits, and selection.
        // It loads persisted data from SharedPreferences on construction.
        ChangeNotifierProvider(create: (_) => ShopProvider()..init()),
      ],
      child: MaterialApp(
        title: 'Mini Greenhouse',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4CAF50), // Green greenhouse theme
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'sans-serif',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
