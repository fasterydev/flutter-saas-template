import 'dart:async';

import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'auth_card.dart';

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
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  bool _codeSent = false;
  String _error = '';

  late ClerkAuthState _authState;
  late StreamSubscription<clerk.AuthError> _errorSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authState = ClerkAuth.of(context);
      _errorSub = _authState.errorStream.listen((e) {
        setState(() => _error = e.message);
        _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(e.message)));
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    _errorSub.cancel();
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
                  description: _codeSent
                      ? 'Ingresa el nuevo password y el código que se envió a tu correo.'
                      : 'Escribe tu correo para enviar un código de recuperación.',
                  logo: Icon(Icons.lock_reset, size: 48, color: textOnPrimary.withValues(alpha: 0.9)),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _loading,
                    builder: (context, loading, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_error.isNotEmpty) ...[
                            Text(_error, style: const TextStyle(color: AppTheme.lightDestructive, fontSize: 14)),
                            const SizedBox(height: 12),
                          ],
                          if (!_codeSent) ...[
                            Text('Correo electrónico', style: TextStyle(color: textOnPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'ej. nombre@correo.com',
                                filled: true,
                                fillColor: btnBg,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: loading ? null : _sendCode,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnBg,
                                  foregroundColor: btnFg,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                                ),
                                child: loading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Enviar código de recuperación'),
                              ),
                            ),
                          ] else ...[
                            Text('Nueva contraseña', style: TextStyle(color: textOnPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: btnBg,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text('Código de verificación', style: TextStyle(color: textOnPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _codeController,
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
                                onPressed: loading ? null : _resetPassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnBg,
                                  foregroundColor: btnFg,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                                ),
                                child: loading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Restablecer contraseña'),
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/auth/sign-in', (r) => false),
                            child: Text('Volver al inicio de sesión', style: TextStyle(color: textOnPrimary, fontSize: 14)),
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
