import 'package:flutter/material.dart';

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
