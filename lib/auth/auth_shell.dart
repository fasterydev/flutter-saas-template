import 'package:flutter/material.dart';

import 'forgot_password_page.dart';
import 'register_page.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';

/// Navegación de las pantallas de auth (sign-in, sign-up, forgot-password, register).
class AuthShell extends StatelessWidget {
  const AuthShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: SignInPage.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case SignInPage.routeName:
            return MaterialPageRoute(builder: (_) => const SignInPage());
          case SignUpPage.routeName:
            return MaterialPageRoute(builder: (_) => const SignUpPage());
          case ForgotPasswordPage.routeName:
            return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
          case RegisterPage.routeName:
            return MaterialPageRoute(builder: (_) => const RegisterPage());
          default:
            return MaterialPageRoute(builder: (_) => const SignInPage());
        }
      },
    );
  }
}
