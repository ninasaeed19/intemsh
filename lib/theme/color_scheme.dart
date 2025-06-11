import 'package:flutter/material.dart';

ColorScheme buildColorScheme() {
  return const ColorScheme(
    primary: Color(0xFFE91E63),       // primaryPink
    primaryContainer: Color(0xFFC2185B), // darkPink
    secondary: Color(0xFFF8BBD0),     // lightPink
    secondaryContainer: Color(0xFFFCE4EC), // palePink
    surface: Colors.white,
    background: Color(0xFFFCE4EC),    // palePink
    error: Color(0xFFF44336),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );
}