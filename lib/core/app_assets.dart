/// Rutas de assets: logo e icono de marca (tema claro y oscuro).
/// Coloca los archivos en `assets/images/` según README de esa carpeta.
class AppAssets {
  AppAssets._();

  static const String _images = 'assets/images';

  /// Logo de la app — tema claro.
  static const String logoLight = '$_images/logo_light.png';

  /// Logo de la app — tema oscuro.
  static const String logoDark = '$_images/logo_dark.png';

  /// Icono de la marca — tema claro.
  static const String iconLight = '$_images/icon_light.png';

  /// Icono de la marca — tema oscuro.
  static const String iconDark = '$_images/icon_dark.png';
}
