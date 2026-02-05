import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Página de registro/onboarding (equivalente a app-traky-nextjs auth/register).
/// Muestra logo y contenido centrado; el onboarding completo puede añadirse después.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static const routeName = '/auth/register';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppTheme.darkForeground : AppTheme.lightForeground;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 80, color: fg.withValues(alpha: 0.9)),
                const SizedBox(height: 24),
                Text(
                  'Registro',
                  style: TextStyle(
                    color: fg,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Completa tu perfil o continúa al inicio.',
                  style: TextStyle(
                    color: fg.withValues(alpha: 0.7),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/auth/sign-up'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary,
                      foregroundColor: isDark ? AppTheme.darkPrimaryForeground : AppTheme.lightPrimaryForeground,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                    ),
                    child: const Text('Crear cuenta'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/auth/sign-in'),
                  child: Text('Ya tengo cuenta', style: TextStyle(color: fg.withValues(alpha: 0.8))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
