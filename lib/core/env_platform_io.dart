import 'dart:io' show Platform;

/// En emulador Android, localhost apunta al dispositivo; 10.0.2.2 es el host.
String effectiveBackendUrl(String url) {
  if (url.isEmpty) return url;
  if (Platform.isAndroid &&
      (url.contains('localhost') || url.contains('127.0.0.1'))) {
    return url
        .replaceAll('localhost', '10.0.2.2')
        .replaceAll('127.0.0.1', '10.0.2.2');
  }

  // 10.0.2.2 es especial de Android Emulator; en iOS/macOS debe apuntar al host local.
  if ((Platform.isIOS || Platform.isMacOS) && url.contains('10.0.2.2')) {
    return url.replaceAll('10.0.2.2', '127.0.0.1');
  }
  return url;
}
