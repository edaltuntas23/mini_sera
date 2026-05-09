import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/game_provider.dart';
import 'providers/shop_provider.dart';
import 'providers/sensor_provider.dart';
import 'screens/home_page.dart';

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
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()..init()),
        ChangeNotifierProvider(create: (_) => SensorProvider()..startPolling()),
      ],
      child: MaterialApp(
        title: 'Mini Greenhouse',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2D6A4F),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
