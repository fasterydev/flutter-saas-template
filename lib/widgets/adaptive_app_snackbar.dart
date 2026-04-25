import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';

export 'package:adaptive_platform_ui/adaptive_platform_ui.dart'
    show AdaptiveSnackBarType;

/// Avisos unificados con [AdaptiveSnackBar] (Material en Android, banner en iOS).
abstract final class AdaptiveAppSnackBar {
  static void show(
    BuildContext context,
    String message, {
    AdaptiveSnackBarType type = AdaptiveSnackBarType.info,
    Duration duration = const Duration(seconds: 4),
    String? action,
    VoidCallback? onActionPressed,
  }) {
    if (!context.mounted) return;
    AdaptiveSnackBar.show(
      context,
      message: message,
      type: type,
      duration: duration,
      action: action,
      onActionPressed: onActionPressed,
    );
  }
}
