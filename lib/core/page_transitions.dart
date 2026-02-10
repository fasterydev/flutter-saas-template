import 'package:flutter/material.dart';

/// Duración estándar de transición entre páginas.
const Duration kPageTransitionDuration = Duration(milliseconds: 280);

/// Curva de animación para transiciones.
const Curve kPageTransitionCurve = Curves.easeOutCubic;

/// Crea una ruta con transición slide desde la derecha + fade (estilo profesional).
Route<T> slideFadeRoute<T>(RouteSettings settings, Widget page) {
  return PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: kPageTransitionDuration,
    reverseTransitionDuration: kPageTransitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideTween = Tween<Offset>(
        begin: const Offset(0.03, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: kPageTransitionCurve));

      final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: kPageTransitionCurve));

      return SlideTransition(
        position: animation.drive(slideTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}
