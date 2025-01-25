import 'package:flutter/material.dart';
import 'desktop.dart';
import 'theme.dart'; // Add this import

void main() {
  runApp(const MagicOS());
}

class MagicOS extends StatelessWidget {
  const MagicOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MagicOS',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        primaryColor: const Color(0xFF8B0000),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF8B0000),
          secondary: Colors.purple[800]!,
          surface: Colors.grey[900]!,
        ),
        // Add dynamic color scheme
        extensions: <ThemeExtension<dynamic>>[
          CustomColors(
            accentColor: Colors.deepPurpleAccent,
            highlightColor: Colors.redAccent,
          ),
        ],
      ),
      home: const DesktopScreen(),
    );
  }
}
