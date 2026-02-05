import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Credenciales de Clerk. Solo desde .env o variable de entorno.
///
/// 1) Pon CLERK_PUBLISHABLE_KEY en tu archivo .env (copia .env.example a .env).
/// 2) O al ejecutar: flutter run --dart-define=CLERK_PUBLISHABLE_KEY=pk_test_xxx
///
/// Claves en: https://dashboard.clerk.com/
String get clerkPublishableKey {
  final fromEnv = dotenv.env['CLERK_PUBLISHABLE_KEY']?.trim();
  if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
  return String.fromEnvironment('CLERK_PUBLISHABLE_KEY', defaultValue: '');
}
