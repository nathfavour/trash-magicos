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

// Custom theme extension for additional colors
class CustomColors extends ThemeExtension<CustomColors> {
  final Color accentColor;
  final Color highlightColor;

  CustomColors({required this.accentColor, required this.highlightColor});

  @override
  CustomColors copyWith({Color? accentColor, Color? highlightColor}) {
    return CustomColors(
      accentColor: accentColor ?? this.accentColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t)!,
    );
  }
}
