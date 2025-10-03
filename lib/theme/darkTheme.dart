import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.white.withOpacity(0.6),
      indicatorColor: Colors.blue,
      indicatorSize: TabBarIndicatorSize.tab,
    ),
    colorScheme: ColorScheme.dark(
      // Primary colors - main color
      primary: Colors.blue, // Main color (accent blue)
      onPrimary: Colors.white, // Text/icons on primary
      primaryContainer:
          Colors.white.withOpacity(0.80), // lighter white container
      onPrimaryContainer:
          Colors.blue.shade100, // Light blue text on dark container

      // Secondary colors - accents
      secondary: Colors.grey.shade900, // Dark grey for cards/containers
      onSecondary: Colors.white, // White text on dark grey
      secondaryContainer: Colors.grey.shade800,
      onSecondaryContainer: Colors.grey.shade100,

      // Tertiary colors - additional accents
      tertiary: Colors.blueGrey.shade700,
      onTertiary: Colors.white,
      tertiaryContainer: Colors.blueGrey.shade900,
      onTertiaryContainer: Colors.blueGrey.shade100,

      // Error colors
      error: const Color(0xFFCF6679), // Lighter red for dark theme
      onError: Colors.white,
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),

      // Surface colors - backgrounds
      surface: Colors.black, // Main background (black)
      onSurface: Colors.white, // White text on black surface (maximum contrast)
      surfaceContainerHighest: Colors.grey.shade900, // Elevated surfaces
      onSurfaceVariant: Colors.grey.shade400, // Dimmer text

      // Other
      outline: Colors.grey.shade700, // Borders
      outlineVariant: Colors.grey.shade800, // Subtle borders
      shadow: Colors.black, // Shadows
      scrim: Colors.black, // Modal overlays
      inverseSurface: Colors.white, // Light surface for inverse
      onInverseSurface: Colors.black, // Dark text on light surface
      inversePrimary: Colors.blue.shade700, // Blue for inverse contexts
    ));
