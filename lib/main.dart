import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'auth/auth_shell.dart';
import 'core/env.dart';
import 'core/theme_mode_scope.dart';
import 'screens/enterprise_shell.dart';
import 'src/clerk_credentials.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // Si no existe .env, se usará --dart-define=...
    assert(() {
      // ignore: avoid_print
      print('[main] .env no cargado: $e');
      return true;
    }());
  }
  assert(() {
    // ignore: avoid_print
    print('[main] BACKEND_URL = "${backendUrl.isEmpty ? "(vacío)" : backendUrl}"');
    return true;
  }());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeModeScope(
      themeMode: _themeMode,
      setThemeMode: _setThemeMode,
      child: _buildApp(),
    );
  }

  Widget _buildApp() {
    if (clerkPublishableKey.isEmpty) {
      return MaterialApp(
        title: 'Clerk Auth',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        home: const _ClerkKeyMissingScreen(),
      );
    }

    return ClerkAuth(
      config: ClerkAuthConfig(publishableKey: clerkPublishableKey),
      child: MaterialApp(
        title: 'Clerk Auth',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        home: const _AuthGate(),
      ),
    );
  }
}

/// Pantalla que se muestra cuando no está configurada la clave de Clerk.
class _ClerkKeyMissingScreen extends StatelessWidget {
  const _ClerkKeyMissingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración Clerk'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.key_off,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Falta la clave de Clerk',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Obtén tu publishable key (pk_...) en dashboard.clerk.com '
                'y ejecuta la app con:\n\n'
                'flutter run --dart-define=CLERK_PUBLISHABLE_KEY=tu_clave',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Puerta de autenticación: muestra Sign-in/Sign-up si no hay sesión,
/// o la pantalla de prueba si está autenticado.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ClerkErrorListener(
          child: ClerkAuthBuilder(
            signedInBuilder: (context, authState) => const EnterpriseShell(),
            signedOutBuilder: (context, authState) => const AuthShell(),
          ),
        ),
      ),
    );
  }
}
