import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';
import '../widgets/adaptive_app_snackbar.dart';
import '../widgets/brand_asset.dart';
import 'auth_form_widgets.dart';

/// Página de inicio de sesión (equivalente a app-traky-nextjs auth/sign-in).
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static const routeName = '/auth/sign-in';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      final c = _snackBodyContext;
      if (c == null || !c.mounted) return;
      AdaptiveAppSnackBar.show(
        c,
        'Introduce correo y contraseña',
        type: AdaptiveSnackBarType.info,
      );
      return;
    }
    _loading.value = true;
    try {
      await _authState.attemptSignIn(
        strategy: clerk.Strategy.password,
        identifier: email,
        password: password,
      );
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
                              const SizedBox(height: 20),
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
                                        onGoogle: () => _authState.ssoSignIn(
                                              context,
                                              clerk.Strategy.oauthGoogle,
                                            ),
                                        onApple: () => _authState.ssoSignIn(
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
                                          'Correo electrónico',
                                          hint: 'nombre@gmail.com',
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      TextField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        textInputAction: TextInputAction.done,
                                        onSubmitted: (_) => _submit(),
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: scheme.onSurface,
                                        ),
                                        cursorColor: scheme.primary,
                                        decoration: AppTheme.profileFieldDecoration(
                                          context,
                                          'Contraseña',
                                        ),
                                      ),
                                      const SizedBox(height: 26),
                                      AuthPrimaryCtaButton(
                                        label: 'Iniciar sesión',
                                        loading: loading,
                                        onPrimary: scheme.onPrimary,
                                        primary: scheme.primary,
                                        onPressed: loading ? null : _submit,
                                      ),
                                      const SizedBox(height: 18),
                                      Center(
                                        child: TextButton(
                                          onPressed: () => Navigator.of(context)
                                              .pushReplacementNamed('/auth/sign-up'),
                                          style: TextButton.styleFrom(
                                            foregroundColor: accent,
                                          ),
                                          child: Text(
                                            '¿No tienes una cuenta? Regístrate',
                                            style: theme.textTheme.labelLarge?.copyWith(
                                              decoration: TextDecoration.underline,
                                              decorationColor:
                                                  accent.withValues(alpha: 0.45),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context)
                                            .pushNamed('/auth/forgot-password'),
                                        style: TextButton.styleFrom(
                                          foregroundColor: accent,
                                        ),
                                        child: Text(
                                          '¿Olvidaste tu contraseña?',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w500,
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
