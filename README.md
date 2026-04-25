# Traky

Plantilla de proyecto Flutter con autenticación Clerk (sign-in / sign-up).

## Clerk (Sign-in / Sign-up)

1. Crea una aplicación en [Clerk Dashboard](https://dashboard.clerk.com/) y copia tu **Publishable Key** (empieza por `pk_`).
2. **Solo variables de entorno** (no subas claves al repo):
   - **Con .env:** Copia `.env.example` a `.env`, rellena `CLERK_PUBLISHABLE_KEY` y ejecuta `flutter run`. La app lee la clave del `.env`.
   - **Sin .env:** `flutter run --dart-define=CLERK_PUBLISHABLE_KEY=tu_clave`
3. Si acabas de clonar, crea `.env` (copia de `.env.example`) antes del primer `flutter run`.

La pantalla de prueba muestra la UI de Clerk para **iniciar sesión** y **registrarse**. Una vez autenticado, verás una pantalla de bienvenida y podrás cerrar sesión desde el botón de perfil en la barra superior.

## Icono de la app (logo del launcher)

El proyecto usa [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) para generar los iconos de **Android** e **iOS** a partir de unas imágenes base. La configuración está en `pubspec.yaml` (bloque `flutter_launcher_icons` y `dev_dependencies`).

### 1) Preparar las imágenes (recomendado)

Sustituye estos archivos en tu repo (mismas rutas y nombres que en `pubspec.yaml`):

| Archivo | Uso | Tamaño recomendado |
|---------|-----|---------------------|
| `assets/icon/app_icon.png` | Base para iOS y referencia general | **1024×1024 px**, PNG |
| `assets/icon/app_icon_foreground.png` | Primer plano del icono adaptativo Android | **1024×1024 px**, PNG, logo centrado con margen (~20 %) |

- **Android adaptive**: el fondo del icono adaptativo está definido con `adaptive_icon_background: "#FFFFFF"` en `pubspec.yaml`. Puedes cambiar el color hexadecimal o usar una imagen de fondo según la [documentación del paquete](https://pub.dev/packages/flutter_launcher_icons).
- **iOS**: conviene que el diseño ocupe bien el cuadrado y evite bordes transparentes muy grandes.

### 2) Regenerar los iconos en todas las densidades

Desde la raíz del proyecto:

```bash
flutter pub get
dart run flutter_launcher_icons
```

Si no ves el cambio en el dispositivo:

```bash
flutter clean
flutter pub get
dart run flutter_launcher_icons
flutter run
```

### 3) Si cambias rutas o nombres de archivo

Edita el bloque `flutter_launcher_icons:` en `pubspec.yaml` (`image_path`, `adaptive_icon_foreground`, etc.) para que apunten a tus nuevos archivos y vuelve a ejecutar `dart run flutter_launcher_icons`.

### 4) Si actualizas la versión del paquete `flutter_launcher_icons`

En `pubspec.yaml`, dentro de `dev_dependencies`, cambia la línea `flutter_launcher_icons: ^...` a la versión deseada (consulta [pub.dev](https://pub.dev/packages/flutter_launcher_icons)), ejecuta `flutter pub get` y luego `dart run flutter_launcher_icons` de nuevo.

### 5) Nombre de la app en el sistema (no es el logo)

Esto es independiente del launcher: por defecto el nombre visible es **Traky**. Si lo cambias, revisa al menos:

- `android/app/src/main/AndroidManifest.xml` → `android:label`
- `ios/Runner/Info.plist` → `CFBundleDisplayName` y `CFBundleName`
- `lib/main.dart` → `MaterialApp(title: ...)`

> El campo `name:` en `pubspec.yaml` es el **nombre del paquete Dart** (p. ej. `flutter_project_template`); renombrarlo implica cambiar imports en todo el código. No hace falta tocarlo solo para cambiar logo o nombre en pantalla.

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

### iOS (CocoaPods)

Tras `flutter pub get`, si compilar en iOS falla por pods:

```bash
cd ios && pod install && cd ..
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

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
