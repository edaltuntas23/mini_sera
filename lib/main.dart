import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MiniGreenhouseApp());
}
 
class MiniGreenhouseApp extends StatelessWidget {
  const MiniGreenhouseApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider()..init(),
      child: MaterialApp(
        title: 'Mini Greenhouse',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4CAF50),
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