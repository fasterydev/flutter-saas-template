import 'package:flutter/material.dart';

/// Fila de solo lectura para pantallas de detalle (etiqueta + valor).
class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    this.value,
    this.child,
  });

  final String label;
  final String? value;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: child ??
                Text(
                  value ?? '—',
                  style: theme.textTheme.bodyMedium,
                ),
          ),
        ],
      ),
    );
  }
}
