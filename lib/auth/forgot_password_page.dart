import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import 'auth_form_widgets.dart';
import 'sign_in_page.dart';

/// Página de recuperación de contraseña (equivalente a app-traky-nextjs auth/forgot-password).
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  static const routeName = '/auth/forgot-password';

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  final _loading = ValueNotifier<bool>(false);

  bool _codeSent = false;
  String _error = '';

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
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Introduce tu correo electrónico');
      return;
    }
    _loading.value = true;
    setState(() => _error = '');
    try {
      await _authState.initiatePasswordReset(
        identifier: email,
        strategy: clerk.Strategy.resetPasswordEmailCode,
      );
      setState(() => _codeSent = true);
    } finally {
      _loading.value = false;
    }
  }

  Future<void> _resetPassword() async {
    final password = _passwordController.text;
    final code = _codeController.text.trim();
    if (code.isEmpty || password.isEmpty) {
      setState(() => _error = 'Introduce el código y la nueva contraseña');
      return;
    }
    if (password.length < 8) {
      setState(() => _error = 'La contraseña debe tener al menos 8 caracteres');
      return;
    }
    _loading.value = true;
    setState(() => _error = '');
    try {
      await _authState.attemptSignIn(
        strategy: clerk.Strategy.resetPasswordEmailCode,
        code: code,
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
    final fieldFill =
        scheme.brightness == Brightness.light ? Colors.white : scheme.surface;

    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: scheme.surface,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.lock_reset_rounded, size: 40, color: accent),
                    const SizedBox(height: 24),
                    Text(
                      _codeSent
                          ? 'Ingresa el nuevo password y el código que se envió a tu correo.'
                          : 'Escribe tu correo para enviar un código de recuperación.',
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
                            if (_error.isNotEmpty) ...[
                              Text(
                                _error,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: scheme.error,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            if (!_codeSent) ...[
                              AuthLabeledField(
                                label: 'Correo electrónico',
                                controller: _emailController,
                                fillColor: fieldFill,
                                onPrimary: onText,
                                keyboardType: TextInputType.emailAddress,
                                hintText: 'ej. nombre@correo.com',
                              ),
                              const SizedBox(height: 24),
                              AuthPrimaryCtaButton(
                                label: 'Enviar código de recuperación',
                                loading: loading,
                                onPrimary: scheme.onPrimary,
                                primary: scheme.primary,
                                onPressed: loading ? null : _sendCode,
                              ),
                            ] else ...[
                              AuthLabeledField(
                                label: 'Nueva contraseña',
                                controller: _passwordController,
                                fillColor: fieldFill,
                                onPrimary: onText,
                                obscure: true,
                              ),
                              const SizedBox(height: 16),
                              AuthLabeledField(
                                label: 'Código de verificación',
                                controller: _codeController,
                                fillColor: fieldFill,
                                onPrimary: onText,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 24),
                              AuthPrimaryCtaButton(
                                label: 'Restablecer contraseña',
                                loading: loading,
                                onPrimary: scheme.onPrimary,
                                primary: scheme.primary,
                                onPressed: loading ? null : _resetPassword,
                              ),
                            ],
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                SignInPage.routeName,
                                (r) => false,
                              ),
                              style: TextButton.styleFrom(foregroundColor: accent),
                              child: Text(
                                'Volver al inicio de sesión',
                                style: theme.textTheme.labelLarge,
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
        ),
      ),
    );
  }
}
