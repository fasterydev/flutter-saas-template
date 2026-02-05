import 'package:flutter/material.dart';

import '../core/app_assets.dart';

/// Logo o icono de marca que cambia según el tema (claro/oscuro).
/// Reutilizable en AppBar, splash, etc.
class BrandAsset extends StatelessWidget {
  const BrandAsset({
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.useIcon = false,
  });

  /// Altura; si no se indica, se deduce según [useIcon].
  final double? height;

  /// Ancho; si no se indica, se mantiene la proporción del asset.
  final double? width;

  /// Ajuste del dibujo (contain, cover, etc.).
  final BoxFit fit;

  /// Si true usa icon_light/icon_dark; si false usa logo_light/logo_dark.
  final bool useIcon;

  /// Asset según tema actual (claro/oscuro).
  static String assetForTheme(BuildContext context, {bool asIcon = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (asIcon) return isDark ? AppAssets.iconDark : AppAssets.iconLight;
    return isDark ? AppAssets.logoDark : AppAssets.logoLight;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final path = useIcon
        ? (isDark ? AppAssets.iconDark : AppAssets.iconLight)
        : (isDark ? AppAssets.logoDark : AppAssets.logoLight);
    final h = height ?? (useIcon ? 28.0 : 32.0);
    final w = width;

    return Image.asset(
      path,
      height: h,
      width: w,
      fit: fit,
      errorBuilder: (_, __, ___) => Icon(
        useIcon ? Icons.inventory_2_outlined : Icons.image_not_supported_outlined,
        size: h,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
