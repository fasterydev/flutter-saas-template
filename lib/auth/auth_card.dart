import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Card con fondo primary (verde) y texto claro, como en app-traky-nextjs.
class AuthCard extends StatelessWidget {
  const AuthCard({
    super.key,
    required this.child,
    this.description,
    this.logo,
  });

  final Widget child;
  final String? description;
  final Widget? logo;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgPrimary = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    final textOnPrimary = isDark ? AppTheme.darkForeground : AppTheme.lightForeground;

    return Card(
      color: bgPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (logo != null) ...[
              Center(child: logo),
              const SizedBox(height: 16),
            ],
            if (description != null) ...[
              Text(
                description!,
                style: TextStyle(
                  color: textOnPrimary.withValues(alpha: 0.95),
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
