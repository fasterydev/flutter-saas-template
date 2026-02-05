# flutter_project_template

Plantilla de proyecto Flutter con autenticación Clerk (sign-in / sign-up).

## Clerk (Sign-in / Sign-up)

1. Crea una aplicación en [Clerk Dashboard](https://dashboard.clerk.com/) y copia tu **Publishable Key** (empieza por `pk_`).
2. **Solo variables de entorno** (no subas claves al repo):
   - **Con .env:** Copia `.env.example` a `.env`, rellena `CLERK_PUBLISHABLE_KEY` y ejecuta `flutter run`. La app lee la clave del `.env`.
   - **Sin .env:** `flutter run --dart-define=CLERK_PUBLISHABLE_KEY=tu_clave`
3. Si acabas de clonar, crea `.env` (copia de `.env.example`) antes del primer `flutter run`.

La pantalla de prueba muestra la UI de Clerk para **iniciar sesión** y **registrarse**. Una vez autenticado, verás una pantalla de bienvenida y podrás cerrar sesión desde el botón de perfil en la barra superior.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
