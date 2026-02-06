import 'package:flutter/material.dart';

/// Mensaje centrado cuando no hay datos en una lista (paquetes, alertas, clientes, etc.).
class EmptyStateMessage extends StatelessWidget {
  const EmptyStateMessage({
    super.key,
    required this.message,
    this.icon,
  });

  /// Texto a mostrar, ej: "No hay paquetes", "No hay alertas"
  final String message;

  /// Ícono opcional (por defecto: inventory_2_outlined)
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final iconData = icon ?? Icons.inbox_outlined;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 64,
              color: colorScheme.onSurface.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
