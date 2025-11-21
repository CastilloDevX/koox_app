import 'package:flutter/material.dart';
import 'views/HomeScreen.dart';

void main() {
  runApp(const KooxApp());
}

class KooxApp extends StatelessWidget {
  const KooxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koox Campeche',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFDC2626),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFDC2626),
          primary: const Color(0xFFDC2626),
        ),
      ),
      home: const HomeScreen(), 
    );
  }
}
