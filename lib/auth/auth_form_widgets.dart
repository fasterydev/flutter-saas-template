import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Rutas de SVG en [assets/clerk/](logos OAuth para botones sociales).
abstract final class AuthClerkAssets {
  AuthClerkAssets._();

  static const googleSvg = 'assets/clerk/google.svg';
  static const appleSvg = 'assets/clerk/apple.svg';
}

/// Divisor “o” entre SSO y formulario de correo.
class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key, required this.onPrimary});

  final Color onPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final line = onPrimary.withValues(alpha: 0.35);
    return Row(
      children: [
        Expanded(child: Divider(color: line, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'o',
            style: theme.textTheme.labelLarge?.copyWith(
              color: onPrimary.withValues(alpha: 0.75),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: line, thickness: 1)),
      ],
    );
  }
}

/// Botón social sobre fondo primary (borde suave + tipografía del tema).
class AuthSocialButton extends StatelessWidget {
  const AuthSocialButton({
    super.key,
    required this.label,
    required this.leading,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPrimary,
    this.onPressed,
  });

  final String label;
  final Widget leading;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color onPrimary;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: BorderSide(
            color: onPrimary.withValues(alpha: 0.62),
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 22,
              width: 22,
              child: leading,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Google y Apple en una fila (2 columnas): tarjetas compactas, solo icono.
class AuthSocialIconRow extends StatelessWidget {
  const AuthSocialIconRow({
    super.key,
    required this.googleIcon,
    required this.appleIcon,
    required this.accent,
    required this.loading,
    this.onGoogle,
    this.onApple,
  });

  final Widget googleIcon;
  final Widget appleIcon;
  final Color accent;
  final bool loading;
  final VoidCallback? onGoogle;
  final VoidCallback? onApple;

  static const double _height = 52;
  static const double _iconSize = 26;

  @override
  Widget build(BuildContext context) {
    final side = BorderSide(color: accent.withValues(alpha: 0.62), width: 1);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
    );
    final scheme = Theme.of(context).colorScheme;
    final iconTileBg = scheme.brightness == Brightness.dark
        ? scheme.surfaceContainerHighest
        : Colors.white;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Semantics(
            label: 'Continuar con Google',
            button: true,
            enabled: !loading && onGoogle != null,
            child: SizedBox(
              height: _height,
              child: OutlinedButton(
                onPressed: loading ? null : onGoogle,
                style: OutlinedButton.styleFrom(
                  backgroundColor: iconTileBg,
                  foregroundColor: accent,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, _height),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: shape,
                  side: side,
                ),
                child: Center(
                  child: SizedBox(
                    width: _iconSize,
                    height: _iconSize,
                    child: googleIcon,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Semantics(
            label: 'Continuar con Apple',
            button: true,
            enabled: !loading && onApple != null,
            child: SizedBox(
              height: _height,
              child: OutlinedButton(
                onPressed: loading ? null : onApple,
                style: OutlinedButton.styleFrom(
                  backgroundColor: iconTileBg,
                  foregroundColor: scheme.onSurface,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, _height),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: shape,
                  side: side,
                ),
                child: Center(
                  child: SizedBox(
                    width: _iconSize,
                    height: _iconSize,
                    child: appleIcon,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Campo con etiqueta.
class AuthLabeledField extends StatelessWidget {
  const AuthLabeledField({
    super.key,
    required this.label,
    required this.controller,
    required this.fillColor,
    required this.onPrimary,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.onSubmitted,
    this.requiredField = false,
    this.requiredColor,
  });

  final String label;
  final TextEditingController controller;
  final Color fillColor;
  final Color onPrimary;
  final bool obscure;
  final TextInputType keyboardType;
  final String? hintText;
  final void Function(String)? onSubmitted;
  final bool requiredField;
  final Color? requiredColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final labelStyle = theme.textTheme.labelLarge?.copyWith(
      color: onPrimary.withValues(alpha: 0.92),
      fontWeight: FontWeight.w600,
      letterSpacing: -0.15,
    );
    final fieldBorder = scheme.outline.withValues(alpha: 0.65);
    final fieldText = scheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(label, style: labelStyle),
            if (requiredField) ...[
              Text(
                ' *',
                style: labelStyle?.copyWith(
                  color: requiredColor ?? scheme.error,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          textInputAction: obscure ? TextInputAction.done : TextInputAction.next,
          onSubmitted: onSubmitted,
          style: theme.textTheme.bodyLarge?.copyWith(color: fieldText),
          cursorColor: scheme.primary,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: fieldText.withValues(alpha: 0.45),
            ),
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              borderSide: BorderSide(color: fieldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              borderSide: BorderSide(color: fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              borderSide: BorderSide(color: scheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/// Botón principal de acción (relleno [primary], texto [onPrimary]).
class AuthPrimaryCtaButton extends StatelessWidget {
  const AuthPrimaryCtaButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onPrimary,
    required this.primary,
    this.onPressed,
    this.icon,
  });

  final String label;
  final bool loading;
  final Color onPrimary;
  final Color primary;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const kCtaHeight = 50.0;
    return SizedBox(
      height: kCtaHeight,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kCtaHeight / 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: loading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: onPrimary,
                ),
              )
            : icon == null
                ? Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: onPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 22, color: onPrimary),
                      const SizedBox(width: 10),
                      Text(
                        label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: onPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
