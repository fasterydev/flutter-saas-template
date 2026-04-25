import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';
import '../widgets/adaptive_app_snackbar.dart';
import '../widgets/brand_asset.dart';
import 'auth_form_widgets.dart';
import 'sign_in_page.dart';

/// Página de registro (equivalente a app-traky-nextjs auth/sign-up).
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const routeName = '/auth/sign-up';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _loading = ValueNotifier<bool>(false);
  BuildContext? _snackBodyContext;

  late ClerkAuthState _authState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _authState = ClerkAuth.of(context);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    final c = _snackBodyContext;
    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      if (c == null || !c.mounted) return;
      AdaptiveAppSnackBar.show(
        c,
        'Completa correo y ambas contraseñas',
        type: AdaptiveSnackBarType.info,
      );
      return;
    }
    if (password != confirm) {
      if (c == null || !c.mounted) return;
      AdaptiveAppSnackBar.show(
        c,
        'Las contraseñas no coinciden',
        type: AdaptiveSnackBarType.warning,
      );
      return;
    }
    if (password.length < 8) {
      if (c == null || !c.mounted) return;
      AdaptiveAppSnackBar.show(
        c,
        'La contraseña debe tener al menos 8 caracteres',
        type: AdaptiveSnackBarType.info,
      );
      return;
    }
    _loading.value = true;
    try {
      await _authState.attemptSignUp(
        strategy: clerk.Strategy.password,
        emailAddress: email,
        password: password,
        passwordConfirmation: confirm,
      );
      if (!mounted) return;
      final sc = _snackBodyContext;
      if (sc == null || !sc.mounted) return;
      AdaptiveAppSnackBar.show(
        sc,
        'Si debes confirmar el correo, hazlo y vuelve a entrar. '
        'Con la sesión iniciada completarás la verificación de identidad en la app.',
        type: AdaptiveSnackBarType.success,
        duration: const Duration(seconds: 5),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(SignInPage.routeName);
    } finally {
      _loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final onText = scheme.onSurface;
    final accent = scheme.primary;
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: scheme.surface,
        body: Builder(
          builder: (snackCtx) {
            _snackBodyContext = snackCtx;
            return SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Center(
                                child: BrandAsset(useIcon: true, height: 48),
                              ),
                              const SizedBox(height: 16),
                              const Center(
                                child: BrandAsset(height: 28),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Regístrate para crear una cuenta',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: onText,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 28),
                              ValueListenableBuilder<bool>(
                                valueListenable: _loading,
                                builder: (context, loading, _) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      AuthSocialIconRow(
                                        loading: loading,
                                        accent: accent,
                                        googleIcon: SvgPicture.asset(
                                          AuthClerkAssets.googleSvg,
                                          fit: BoxFit.contain,
                                        ),
                                        appleIcon: SvgPicture.asset(
                                          AuthClerkAssets.appleSvg,
                                          fit: BoxFit.contain,
                                        ),
                                        onGoogle: () => _authState.ssoSignUp(
                                              context,
                                              clerk.Strategy.oauthGoogle,
                                            ),
                                        onApple: () => _authState.ssoSignUp(
                                              context,
                                              clerk.Strategy.oauthApple,
                                            ),
                                      ),
                                      const SizedBox(height: 22),
                                      AuthOrDivider(onPrimary: onText),
                                      const SizedBox(height: 22),
                                      TextField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: scheme.onSurface,
                                        ),
                                        cursorColor: scheme.primary,
                                        decoration: AppTheme.profileFieldDecoration(
                                          context,
                                          'Correo electrónico *',
                                          hint: 'nombre@gmail.com',
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      TextField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        textInputAction: TextInputAction.next,
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: scheme.onSurface,
                                        ),
                                        cursorColor: scheme.primary,
                                        decoration: AppTheme.profileFieldDecoration(
                                          context,
                                          'Contraseña *',
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      TextField(
                                        controller: _confirmPasswordController,
                                        obscureText: true,
                                        textInputAction: TextInputAction.done,
                                        onSubmitted: (_) => _submit(),
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: scheme.onSurface,
                                        ),
                                        cursorColor: scheme.primary,
                                        decoration: AppTheme.profileFieldDecoration(
                                          context,
                                          'Confirmar contraseña *',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Mínimo 8 caracteres',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: scheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      AuthPrimaryCtaButton(
                                        label: 'Registrarse',
                                        icon: Icons.person_add_rounded,
                                        loading: loading,
                                        onPrimary: scheme.onPrimary,
                                        primary: scheme.primary,
                                        onPressed: loading ? null : _submit,
                                      ),
                                      const SizedBox(height: 18),
                                      Center(
                                        child: TextButton(
                                          onPressed: () => Navigator.of(context)
                                              .pushReplacementNamed('/auth/sign-in'),
                                          style: TextButton.styleFrom(
                                            foregroundColor: accent,
                                          ),
                                          child: Text(
                                            '¿Ya tienes una cuenta? Inicia sesión',
                                            style: theme.textTheme.labelLarge?.copyWith(
                                              decoration: TextDecoration.underline,
                                              decorationColor:
                                                  accent.withValues(alpha: 0.45),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
