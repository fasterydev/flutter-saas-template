import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'env_platform_stub.dart' if (dart.library.io) 'env_platform_io.dart' as platform;

String get backendUrl {
  final raw = dotenv.env['BACKEND_URL']?.trim() ??
      String.fromEnvironment('BACKEND_URL', defaultValue: '');
  return platform.effectiveBackendUrl(raw);
}
