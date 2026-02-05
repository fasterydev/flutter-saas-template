import 'dart:async';

import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

/// Pantalla de Sign-in / Sign-up con diseño tipo Clerk:
/// fondo azul oscuro, botones Google/GitHub, email y contraseña.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _initialized = ValueNotifier<bool>(false);
  final _loading = ValueNotifier<bool>(false);
  final _user = ValueNotifier<clerk.User?>(null);
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late StreamSubscription<clerk.AuthError> _errorSubscription;
  late ClerkAuthState _authState;

  /// true = Sign up, false = Sign in
  bool _isSignUp = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authState = ClerkAuth.of(context);
      _user.value = _authState.user;
      _authState.addListener(_clerkAuthListener);
      _errorSubscription = _authState.errorStream.listen(_onError);
      _initialized.value = true;
    });
  }

  void _clerkAuthListener() {
    _user.value = _authState.user;
  }

  void _onError(clerk.AuthError error) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(content: Text(error.message)),
    );
  }

  Future<void> _signInWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _onError(clerk.AuthError(message: 'Introduce email y contraseña', code: clerk.AuthErrorCode.signInError));
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

  Future<void> _signUpWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _onError(clerk.AuthError(message: 'Introduce email y contraseña', code: clerk.AuthErrorCode.signInError));
      return;
    }
    if (password.length < 8) {
      _onError(clerk.AuthError(message: 'La contraseña debe tener al menos 8 caracteres', code: clerk.AuthErrorCode.invalidPassword));
      return;
    }
    _loading.value = true;
    try {
      await _authState.attemptSignUp(
        strategy: clerk.Strategy.password,
        emailAddress: email,
        password: password,
      );
      // Si el entorno requiere verificación por email, Clerk lo pedirá en pasos siguientes
    } finally {
      _loading.value = false;
    }
  }

  Future<void> _ssoSignIn(clerk.Strategy strategy) async {
    _loading.value = true;
    try {
      await _authState.ssoSignIn(context, strategy);
    } finally {
      _loading.value = false;
    }
  }

  bool _hasStrategy(clerk.Strategy s) {
    try {
      return _authState.env.config.firstFactors.contains(s);
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authState.removeListener(_clerkAuthListener);
    _errorSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: _kBackgroundColor,
        body: SafeArea(
          child: ListenableBuilder(
            listenable: _initialized,
            builder: (context, _) {
              if (!_initialized.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              return ValueListenableBuilder<clerk.User?>(
                valueListenable: _user,
                builder: (context, clerk.User? user, _) {
                  if (user != null) {
                    return _SignedInContent(authState: _authState);
                  }
                  return ValueListenableBuilder<bool>(
                    valueListenable: _loading,
                    builder: (context, bool loading, _) {
                      if (loading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      return _AuthForm(
                        isSignUp: _isSignUp,
                        onToggleMode: () => setState(() => _isSignUp = !_isSignUp),
                        emailController: _emailController,
                        passwordController: _passwordController,
                        onEmailSubmit: _isSignUp ? _signUpWithEmail : _signInWithEmail,
                        onGoogle: _hasStrategy(clerk.Strategy.oauthGoogle)
                            ? () => _ssoSignIn(clerk.Strategy.oauthGoogle)
                            : null,
                        onGitHub: _hasStrategy(clerk.Strategy.oauthGithub)
                            ? () => _ssoSignIn(clerk.Strategy.oauthGithub)
                            : null,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

const Color _kBackgroundColor = Color(0xFF1E3A5F);

class _AuthForm extends StatelessWidget {
  const _AuthForm({
    required this.isSignUp,
    required this.onToggleMode,
    required this.emailController,
    required this.passwordController,
    required this.onEmailSubmit,
    this.onGoogle,
    this.onGitHub,
  });

  final bool isSignUp;
  final VoidCallback onToggleMode;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onEmailSubmit;
  final VoidCallback? onGoogle;
  final VoidCallback? onGitHub;

  @override
  Widget build(BuildContext context) {
    final showSocial = onGoogle != null || onGitHub != null;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          // Logo placeholder (hexágono)
          Center(
            child: Icon(Icons.account_circle, size: 56, color: Colors.white.withValues(alpha:0.9)),
          ),
          const SizedBox(height: 24),
          Text(
            isSignUp ? 'Create an account' : 'Sign in',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Please sign in to continue',
            style: TextStyle(
              color: Colors.white.withValues(alpha:0.7),
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (showSocial) ...[
            if (onGoogle != null)
              _SocialButton(
                label: 'Google',
                icon: Icons.g_mobiledata_rounded,
                onPressed: onGoogle!,
              ),
            if (onGoogle != null && onGitHub != null) const SizedBox(height: 12),
            if (onGitHub != null)
              _SocialButton(
                label: 'GitHub',
                icon: Icons.code,
                onPressed: onGitHub!,
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.white.withValues(alpha:0.5))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'or',
                    style: TextStyle(color: Colors.white.withValues(alpha:0.8), fontSize: 14),
                  ),
                ),
                Expanded(child: Divider(color: Colors.white.withValues(alpha:0.5))),
              ],
            ),
            const SizedBox(height: 24),
          ],
          Text(
            'Email address',
            style: TextStyle(
              color: Colors.white.withValues(alpha:0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'john@doe.com',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha:0.4)),
              filled: true,
              fillColor: const Color(0xFF2A4A6F),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withValues(alpha:0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withValues(alpha:0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Password',
            style: TextStyle(
              color: Colors.white.withValues(alpha:0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: passwordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onEmailSubmit(),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF2A4A6F),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withValues(alpha:0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withValues(alpha:0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: onEmailSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isSignUp ? 'Create an account' : 'Sign in',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: onToggleMode,
            child: Text(
              isSignUp
                  ? 'Already have an account? Sign in'
                  : "Don't have an account? Create one",
              style: TextStyle(
                color: Colors.white.withValues(alpha:0.9),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          side: BorderSide(color: Colors.white.withValues(alpha:0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _SignedInContent extends StatelessWidget {
  const _SignedInContent({required this.authState});

  final ClerkAuthState authState;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.greenAccent, size: 80),
          const SizedBox(height: 24),
          const Text(
            '¡Has iniciado sesión!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ElevatedButton(
              onPressed: () => authState.signOut(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _kBackgroundColor,
              ),
              child: const Text('Cerrar sesión'),
            ),
          ),
        ],
      ),
    );
  }
}
