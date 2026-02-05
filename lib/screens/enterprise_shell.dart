import 'package:flutter/material.dart';

import '../core/nav_data.dart';
import 'home_page.dart';
import 'packages/packages_analytics_page.dart';
import 'settings_page.dart';
import 'packages/packages_list_page.dart';
import 'packages/package_form_page.dart';

/// Shell de la app enterprise: home con grid y rutas (packages, alerts, etc.).
class EnterpriseShell extends StatelessWidget {
  const EnterpriseShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        final name = settings.name ?? AppRoutes.home;

        if (name == AppRoutes.home) {
          return MaterialPageRoute(builder: (_) => const HomePage());
        }
        if (name == AppRoutes.packages) {
          return MaterialPageRoute(builder: (_) => const PackagesListPage());
        }
        if (name == AppRoutes.packagesNew) {
          return MaterialPageRoute(builder: (_) => const PackageFormPage());
        }
        if (name == AppRoutes.packagesAnalytics) {
          return MaterialPageRoute(builder: (_) => const PackagesAnalyticsPage());
        }
        if (name == AppRoutes.settings) {
          return MaterialPageRoute(builder: (_) => const SettingsPage());
        }
        // /packages/:id
        if (name.startsWith('/packages/') && name != AppRoutes.packages && name != AppRoutes.packagesNew && name != AppRoutes.packagesAnalytics && name != AppRoutes.packagesStates) {
          final id = name.replaceFirst('/packages/', '');
          return MaterialPageRoute(builder: (_) => PackageFormPage(id: id));
        }

        // Placeholder para el resto de rutas
        return MaterialPageRoute(
          builder: (_) => _PlaceholderPage(title: name),
        );
      },
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'Próximamente',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
