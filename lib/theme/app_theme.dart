import 'package:flutter/material.dart';

/// Tabla de tema basada en app-traky-nextjs/app/globals.css
/// Colores convertidos de OKLCH a Flutter Color (aproximados).
class AppTheme {
  AppTheme._();

  // ----- Tema claro (:root) -----
  static const Color lightBackground = Color(0xFFFFFFFF); // oklch(1 0 0)
  static const Color lightForeground = Color(0xFF141414); // oklch(0.08 0 0)
  static const Color lightCard = Color(0xFFEBEBEB); // oklch(0.92 0 0)
  static const Color lightPrimary = Color(0xFF5FB07F); // oklch(0.8336 0.1626 129.97)
  static const Color lightPrimaryForeground = Color(0xFF141414); // texto sobre verde
  static const Color lightSecondary = Color(0xFFF5F5F5); // oklch(0.96 0 0)
  static const Color lightMuted = Color(0xFFF5F5F5);
  static const Color lightMutedForeground = Color(0xFF737373); // oklch(0.5 0 0)
  static const Color lightAccent = Color(0xFF4CAF6E); // oklch(0.8058 0.1869 132.95)
  static const Color lightDestructive = Color(0xFFDC2626); // oklch(0.6213 0.197 24.97)
  static const Color lightBorder = Color(0xFFE6E6E6); // oklch(0.9 0 0)
  static const Color lightInput = Color(0xFFF2F2F2); // oklch(0.95 0 0)
  static const Color lightRing = Color(0xFF5FB07F); // focus = primary

  // ----- Tema oscuro (.dark) -----
  static const Color darkBackground = Color(0xFF1A2332); // oklch(0.1594 0.0622 259.15)
  static const Color darkForeground = Color(0xFFFAFAFA); // oklch(0.98 0 0)
  static const Color darkCard = Color(0xFF1E293B); // oklch(0.15 0.02 250)
  static const Color darkPrimary = Color(0xFF5FB07F); // mismo verde
  static const Color darkPrimaryForeground = Color(0xFF1A2332); // azul oscuro sobre verde
  static const Color darkSecondary = Color(0xFF243447); // oklch(0.18 0.02 250)
  static const Color darkMuted = Color(0xFF243447);
  static const Color darkMutedForeground = Color(0xFFA3A3A3); // oklch(0.65 0 0)
  static const Color darkAccent = Color(0xFF4CAF6E);
  static const Color darkDestructive = Color(0xFFDC2626);
  static const Color darkBorder = Color(0x26FFFFFF); // 15% blanco
  static const Color darkInput = Color(0x33FFFFFF); // 20% blanco
  static const Color darkRing = Color(0xFF5FB07F);

  // Radio (--radius: 1rem ≈ 16)
  static const double radiusSm = 12;
  static const double radiusMd = 14;
  static const double radiusLg = 16;
  static const double radiusXl = 20;

  /// Tabla resumen para referencia (nombre CSS → Color claro / Color oscuro)
  static Map<String, (Color light, Color dark)> get colorTable => {
        'background': (lightBackground, darkBackground),
        'foreground': (lightForeground, darkForeground),
        'card': (lightCard, darkCard),
        'primary': (lightPrimary, darkPrimary),
        'primaryForeground': (lightPrimaryForeground, darkPrimaryForeground),
        'secondary': (lightSecondary, darkSecondary),
        'muted': (lightMuted, darkMuted),
        'mutedForeground': (lightMutedForeground, darkMutedForeground),
        'accent': (lightAccent, darkAccent),
        'destructive': (lightDestructive, darkDestructive),
        'border': (lightBorder, darkBorder),
        'input': (lightInput, darkInput),
        'ring': (lightRing, darkRing),
      };

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        surface: lightBackground,
        onSurface: lightForeground,
        primary: lightPrimary,
        onPrimary: lightPrimaryForeground,
        secondary: lightSecondary,
        onSecondary: lightForeground,
        error: lightDestructive,
        onError: Colors.white,
        outline: lightBorder,
        surfaceContainerHighest: lightCard,
      ),
      scaffoldBackgroundColor: lightBackground,
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightInput,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusMd)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: lightRing, width: 2),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: darkBackground,
        onSurface: darkForeground,
        primary: darkPrimary,
        onPrimary: darkPrimaryForeground,
        secondary: darkSecondary,
        onSecondary: darkForeground,
        error: darkDestructive,
        onError: Colors.white,
        outline: darkBorder,
        surfaceContainerHighest: darkCard,
      ),
      scaffoldBackgroundColor: darkBackground,
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkInput,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusMd)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: darkRing, width: 2),
        ),
      ),
    );
  }
}
