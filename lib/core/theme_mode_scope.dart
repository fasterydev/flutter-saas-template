import 'package:flutter/material.dart';

/// Provee el tema actual y un setter para que Configuración pueda cambiarlo.
class ThemeModeScope extends InheritedWidget {
  const ThemeModeScope({
    super.key,
    required this.themeMode,
    required this.setThemeMode,
    required super.child,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> setThemeMode;

  static ThemeModeScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeModeScope>();
  }

  static ThemeModeScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'ThemeModeScope not found. Wrap MaterialApp with ThemeModeScope.');
    return scope!;
  }

  @override
  bool updateShouldNotify(ThemeModeScope oldWidget) {
    return themeMode != oldWidget.themeMode;
  }
}
