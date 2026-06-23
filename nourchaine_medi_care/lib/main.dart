import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart'; // ← ADD
import 'screens/Landing_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const MediCareApp());
}

class MediCareApp extends StatelessWidget {
  const MediCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediCare Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B9EE8),
          brightness: Brightness.light,
        ),
      ),
      home: const LandingPage(),
    );
  }
}