import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
        // Primary colors - main brand color
        primary: Colors.blue, // Main brand color
        onPrimary: Colors.white, // Text/icons on primary
        primaryContainer: Color(0xFFEADDFF), // Lighter primary variant
        onPrimaryContainer: Color(0xFF21005D),

        // Secondary colors - accents
        secondary: Color(0xFF625B71),
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFE8DEF8),
        onSecondaryContainer: Color(0xFF1D192B),

        // Tertiary colors - additional accents
        tertiary: Color(0xFF7D5260),
        onTertiary: Colors.white,
        tertiaryContainer: Color(0xFFFFD8E4),
        onTertiaryContainer: Color(0xFF31111D),

        // Error colors
        error: Color(0xFFB3261E),
        onError: Colors.white,
        errorContainer: Color(0xFFF9DEDC),
        onErrorContainer: Color(0xFF410E0B),

        // Surface colors - backgrounds
        surface: Color(0xFFFEF7FF), // Light background for cards, sheets
        onSurface: Color(0xFF1C1B1F), // Dark text on surface
        surfaceContainerHighest:
            Color(0xFFE6E0E9), // Alternative light surfaces
        onSurfaceVariant: Color(0xFF49454F),

        // Other
        outline: Color(0xFF79747E), // Borders
        outlineVariant: Color(0xFFCAC4D0), // Subtle borders
        shadow: Colors.black, // Shadows
        scrim: Colors.black, // Modal overlays
        inverseSurface: Color(0xFF313033), // Inverse colors
        onInverseSurface: Color(0xFFF4EFF4),
        inversePrimary: Color(0xFFD0BCFF)));
