# flutter_project_template

Plantilla de proyecto Flutter con autenticación Clerk (sign-in / sign-up).

## Clerk (Sign-in / Sign-up)

1. Crea una aplicación en [Clerk Dashboard](https://dashboard.clerk.com/) y copia tu **Publishable Key** (empieza por `pk_`).
2. **Solo variables de entorno** (no subas claves al repo):
   - **Con .env:** Copia `.env.example` a `.env`, rellena `CLERK_PUBLISHABLE_KEY` y ejecuta `flutter run`. La app lee la clave del `.env`.
   - **Sin .env:** `flutter run --dart-define=CLERK_PUBLISHABLE_KEY=tu_clave`
3. Si acabas de clonar, crea `.env` (copia de `.env.example`) antes del primer `flutter run`.

La pantalla de prueba muestra la UI de Clerk para **iniciar sesión** y **registrarse**. Una vez autenticado, verás una pantalla de bienvenida y podrás cerrar sesión desde el botón de perfil en la barra superior.

## Comandos Flutter

Ejecuta estos comandos desde la raíz del repositorio (donde está `pubspec.yaml`).

### Entorno y dependencias

```bash
flutter doctor -v
```

```bash
flutter pub get
```

Descarga y resuelve las dependencias definidas en `pubspec.yaml`. Úsalo tras clonar el repo o cuando cambies dependencias.

```bash
flutter pub upgrade
```

Actualiza paquetes dentro de los rangos de versión permitidos.

```bash
flutter pub outdated
```

Lista qué dependencias tienen versiones más nuevas disponibles.

### Ejecutar la app

```bash
flutter run
```

Ejecuta en el dispositivo o emulador por defecto. Con `.env` configurado, la app puede leer `CLERK_PUBLISHABLE_KEY` según la configuración del proyecto.

```bash
flutter run -d chrome
```

Ejecuta la versión web en Chrome.

```bash
flutter run -d macos
```

Ejecuta en macOS (si el soporte está habilitado).

```bash
flutter devices
```

Lista dispositivos y emuladores disponibles.

```bash
flutter run --dart-define=CLERK_PUBLISHABLE_KEY=tu_clave_pk_
```

Ejecuta sin `.env`, pasando la clave publicable de Clerk por línea de comandos.

### Calidad y pruebas

```bash
flutter analyze
```

```bash
flutter test
```

### iOS y macOS (CocoaPods)

Tras `flutter pub get`, si compilar en iOS o macOS falla por pods:

```bash
cd ios && pod install && cd ..
```

```bash
cd macos && pod install && cd ..
```

### Builds de release (ejemplos)

```bash
flutter build apk
```

```bash
flutter build ios
```

```bash
flutter build web
```

```bash
flutter build macos
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
