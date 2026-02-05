import 'dart:async';

import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/brand_asset.dart';
import 'auth_card.dart';

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
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  late ClerkAuthState _authState;
  late StreamSubscription<clerk.AuthError> _errorSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authState = ClerkAuth.of(context);
      _errorSub = _authState.errorStream.listen((e) {
        _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(e.message)));
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _errorSub.cancel();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _scaffoldKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Introduce correo y contraseña')),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textOnPrimary = isDark ? AppTheme.darkForeground : AppTheme.lightForeground;
    final btnBg = isDark ? AppTheme.darkBackground : AppTheme.lightBackground;
    final btnFg = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 396),
                child: AuthCard(
                  description: 'Inicia sesión en tu cuenta',
                  logo: const BrandAsset(height: 48),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _loading,
                    builder: (context, loading, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SocialButton(
                            label: 'Continuar con Google',
                            icon: Icons.g_mobiledata_rounded,
                            backgroundColor: btnBg,
                            foregroundColor: btnFg,
                            onPressed: loading ? null : () => _authState.ssoSignIn(context, clerk.Strategy.oauthGoogle),
                          ),
                          const SizedBox(height: 12),
                          _SocialButton(
                            label: 'Continuar con Apple',
                            icon: Icons.apple,
                            backgroundColor: textOnPrimary,
                            foregroundColor: btnBg,
                            onPressed: loading ? null : () => _authState.ssoSignIn(context, clerk.Strategy.oauthApple),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(child: Divider(color: textOnPrimary.withValues(alpha: 0.5))),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('ó', style: TextStyle(color: textOnPrimary, fontSize: 14)),
                              ),
                              Expanded(child: Divider(color: textOnPrimary.withValues(alpha: 0.5))),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text('Correo electrónico', style: TextStyle(color: textOnPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'nombre@empresa.com',
                              filled: true,
                              fillColor: btnBg,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Contraseña', style: TextStyle(color: textOnPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            onSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: btnBg,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: loading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: btnBg,
                                foregroundColor: btnFg,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                              ),
                              child: loading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Iniciar sesión'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pushReplacementNamed('/auth/sign-up'),
                              child: Text('¿No tienes una cuenta? Regístrate', style: TextStyle(color: textOnPrimary, fontSize: 14)),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pushNamed('/auth/forgot-password'),
                            child: Text('¿Olvidaste tu contraseña?', style: TextStyle(color: textOnPrimary, fontSize: 14)),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon, size: 22), const SizedBox(width: 10), Text(label)],
        ),
      ),
    );
  }
}
