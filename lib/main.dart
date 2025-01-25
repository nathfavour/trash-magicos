import 'package:flutter/material.dart';
import 'desktop.dart';

void main() {
  runApp(const MagicOS());
}

class MagicOS extends StatelessWidget {
  const MagicOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MagicOS',
      theme: ThemeData(
        primaryColor: const Color(0xFF8B0000),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF8B0000),
          secondary: Colors.purple[800]!,
          background: Colors.black87,
          surface: Colors.grey[900]!,
        ),
      ),
      home: const DesktopScreen(),
    );
  }
}
