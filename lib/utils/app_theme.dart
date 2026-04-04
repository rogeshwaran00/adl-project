import 'package:flutter/material.dart';

class AppTheme {
  // Colors extracted from Figma theme.css
  static const Color primary = Color(0xFF030213);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color green600 = Color(0xFF16A34A);
  static const Color green500 = Color(0xFF22C55E);
  static const Color purple600 = Color(0xFF9333EA);
  static const Color purple500 = Color(0xFFA855F7);
  static const Color amber600 = Color(0xFFD97706);
  static const Color red600 = Color(0xFFDC2626);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);

  /// Premium CTA height (full-width primary / secondary buttons).
  static const double elevatedButtonMinHeight = 50;

  static RoundedRectangleBorder get elevatedButtonShape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: blue600,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: gray50,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gray200, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gray200, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: blue500, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, elevatedButtonMinHeight),
          shape: elevatedButtonShape,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// [ElevatedButton] on a gradient [Container] (transparent fill, shows gradient behind).
  static ButtonStyle elevatedOnGradient({
    Color? foregroundColor,
    Color? disabledForegroundColor,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: foregroundColor ?? Colors.white,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: disabledForegroundColor ?? gray500,
      minimumSize: const Size(double.infinity, elevatedButtonMinHeight),
      shape: elevatedButtonShape,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }

  /// Solid fill, full width (e.g. export, amber secondary CTA).
  static ButtonStyle elevatedSolid(
    Color backgroundColor, {
    Color foregroundColor = Colors.white,
    Color? disabledForegroundColor,
    Color? disabledBackgroundColor,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledForegroundColor: disabledForegroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      shadowColor: Colors.transparent,
      elevation: 0,
      minimumSize: const Size(double.infinity, elevatedButtonMinHeight),
      shape: elevatedButtonShape,
    );
  }

  /// White fill + border (secondary action).
  static ButtonStyle elevatedSecondaryOutlined() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: gray700,
      shadowColor: Colors.transparent,
      elevation: 0,
      minimumSize: const Size(double.infinity, elevatedButtonMinHeight),
      shape: elevatedButtonShape,
      side: const BorderSide(color: gray200),
    );
  }

  /// Muted action (e.g. copy).
  static ButtonStyle elevatedMuted() {
    return ElevatedButton.styleFrom(
      backgroundColor: gray100,
      foregroundColor: gray700,
      shadowColor: Colors.transparent,
      elevation: 0,
      minimumSize: const Size(double.infinity, elevatedButtonMinHeight),
      shape: elevatedButtonShape,
    );
  }

  /// Full-width outline (e.g. reject, logout).
  static ButtonStyle outlinedFullWidth({
    Color sideColor = gray200,
    Color? foregroundColor,
    double sideWidth = 2,
  }) {
    return OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, elevatedButtonMinHeight),
      shape: elevatedButtonShape,
      side: BorderSide(color: sideColor, width: sideWidth),
      foregroundColor: foregroundColor ?? gray700,
    );
  }

  /// Compact destructive control (e.g. remove image overlay).
  static ButtonStyle elevatedCompactDanger() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      minimumSize: const Size(0, 40),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      shape: elevatedButtonShape,
      elevation: 0,
      shadowColor: Colors.transparent,
    );
  }

  /// [AlertDialog] / inline confirm (not full width).
  static ButtonStyle elevatedDialogAction(Color backgroundColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      minimumSize: const Size(96, elevatedButtonMinHeight),
      shape: elevatedButtonShape,
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}

// Gradient presets matching Figma design
class AppGradients {
  static const LinearGradient blueSplash = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6), Color(0xFF22C55E)],
  );

  static const LinearGradient blueHeader = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
  );

  static const LinearGradient greenHeader = LinearGradient(
    colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
  );

  static const LinearGradient purpleHeader = LinearGradient(
    colors: [Color(0xFF9333EA), Color(0xFFA855F7)],
  );

  static const LinearGradient grayHeader = LinearGradient(
    colors: [Color(0xFF374151), Color(0xFF4B5563)],
  );

  static const LinearGradient blueGreen = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF22C55E)],
  );
}
