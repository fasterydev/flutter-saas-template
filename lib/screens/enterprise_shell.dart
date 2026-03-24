import 'package:flutter/material.dart';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';

import '../core/nav_data.dart';
import '../core/page_transitions.dart';
import '../widgets/platform_module_navigator.dart';
import 'alerts/alert_detail_page.dart';
import 'alerts/alert_form_page.dart';
import 'alerts/alerts_list_page.dart';
import 'customers/customer_detail_page.dart';
import 'customers/customer_form_page.dart';
import 'customers/customers_list_page.dart';
import 'home_page.dart';
import 'packages/package_detail_page.dart';
import 'packages/package_form_page.dart';
import 'packages/packages_analytics_page.dart';
import 'packages/packages_list_page.dart';
import 'settings_page.dart';
import 'shipments/shipment_detail_page.dart';
import 'shipments/shipment_form_page.dart';
import 'shipments/shipments_list_page.dart';
import 'warehouses/warehouse_detail_page.dart';
import 'warehouses/warehouse_form_page.dart';
import 'warehouses/warehouses_list_page.dart';

/// Shell de la app enterprise: home y rutas (alerts, packages, customers, warehouses, shipments).
class EnterpriseShell extends StatelessWidget {
  const EnterpriseShell({super.key});

  @override
  Widget build(BuildContext context) {
    Route<dynamic> pageRoute(RouteSettings settings, Widget child) {
      return slideFadeRoute(
        settings,
        _AdaptiveShellScaffold(
          currentRoute: settings.name ?? AppRoutes.home,
          child: child,
        ),
      );
    }

    return Navigator(
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        final name = settings.name ?? AppRoutes.home;

        // ----- Home y configuración -----
        if (name == AppRoutes.home) {
          return pageRoute(settings, const HomePage());
        }
        if (name == AppRoutes.settings) {
          return pageRoute(settings, const SettingsPage());
        }

        // ----- Alertas -----
        if (name == AppRoutes.alerts) {
          return pageRoute(settings, const AlertsListPage());
        }
        if (name == AppRoutes.alertsNew) {
          return pageRoute(settings, const AlertFormPage());
        }
        if (name.startsWith('${AppRoutes.alerts}/') && name != AppRoutes.alertsNew) {
          final rest = name.replaceFirst('${AppRoutes.alerts}/', '');
          if (rest.endsWith('/edit')) {
            final id = rest.replaceFirst('/edit', '');
            return pageRoute(settings, AlertFormPage(id: id));
          }
          return pageRoute(settings, AlertDetailPage(id: rest));
        }

        // ----- Paquetes -----
        if (name == AppRoutes.packages) {
          return pageRoute(settings, const PackagesListPage());
        }
        if (name == AppRoutes.packagesNew) {
          return pageRoute(settings, const PackageFormPage());
        }
        if (name == AppRoutes.packagesAnalytics) {
          return pageRoute(settings, const PackagesAnalyticsPage());
        }
        if (name.startsWith('${AppRoutes.packages}/') && name != AppRoutes.packagesNew && name != AppRoutes.packagesAnalytics && name != AppRoutes.packagesStates) {
          final rest = name.replaceFirst('${AppRoutes.packages}/', '');
          if (rest.endsWith('/edit')) {
            final id = rest.replaceFirst('/edit', '');
            return pageRoute(settings, PackageFormPage(id: id));
          }
          return pageRoute(settings, PackageDetailPage(id: rest));
        }

        // ----- Embarcaciones (shipments) -----
        if (name == AppRoutes.shipments) {
          return pageRoute(settings, const ShipmentsListPage());
        }
        if (name == AppRoutes.shipmentsNew) {
          return pageRoute(settings, const ShipmentFormPage());
        }
        if (name.startsWith('${AppRoutes.shipments}/') && name != AppRoutes.shipmentsNew) {
          final rest = name.replaceFirst('${AppRoutes.shipments}/', '');
          if (rest.endsWith('/edit')) {
            final id = rest.replaceFirst('/edit', '');
            return pageRoute(settings, ShipmentFormPage(id: id));
          }
          return pageRoute(settings, ShipmentDetailPage(id: rest));
        }

        // ----- Casilleros (warehouses) -----
        if (name == AppRoutes.warehouses) {
          return pageRoute(settings, const WarehousesListPage());
        }
        if (name == AppRoutes.warehousesNew) {
          return pageRoute(settings, const WarehouseFormPage());
        }
        if (name.startsWith('${AppRoutes.warehouses}/') && name != AppRoutes.warehousesNew) {
          final rest = name.replaceFirst('${AppRoutes.warehouses}/', '');
          if (rest.endsWith('/edit')) {
            final id = rest.replaceFirst('/edit', '');
            return pageRoute(settings, WarehouseFormPage(id: id));
          }
          return pageRoute(settings, WarehouseDetailPage(id: rest));
        }

        // ----- Clientes -----
        if (name == AppRoutes.customers) {
          return pageRoute(settings, const CustomersListPage());
        }
        if (name == AppRoutes.customersNew) {
          return pageRoute(settings, const CustomerFormPage());
        }
        if (name.startsWith('${AppRoutes.customers}/') && name != AppRoutes.customersNew) {
          final rest = name.replaceFirst('${AppRoutes.customers}/', '');
          if (rest.endsWith('/edit')) {
            final id = rest.replaceFirst('/edit', '');
            return pageRoute(settings, CustomerFormPage(id: id));
          }
          return pageRoute(settings, CustomerDetailPage(id: rest));
        }

        // Placeholder para el resto de rutas (deliveries, sales, analytics, etc.)
        return pageRoute(settings, _PlaceholderPage(title: name));
      },
    );
  }
}

class _AdaptiveShellScaffold extends StatelessWidget {
  const _AdaptiveShellScaffold({
    required this.child,
    required this.currentRoute,
  });

  final Widget child;
  final String currentRoute;

  int _selectedIndexForRoute(String route) {
    if (route == AppRoutes.home) return 0;
    if (route == AppRoutes.packages || route.startsWith('${AppRoutes.packages}/')) {
      return 1;
    }
    if (route == AppRoutes.shipments || route.startsWith('${AppRoutes.shipments}/')) {
      return 2;
    }
    if (route == AppRoutes.warehouses || route.startsWith('${AppRoutes.warehouses}/')) {
      return 3;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndexForRoute(currentRoute);
    return AdaptiveScaffold(
      body: child,
      bottomNavigationBar: buildAdaptiveModuleBottomNavigationBar(
        useNativeBottomBar: true,
        selectedIndex: selectedIndex,
        items: const [
          ModuleNavItem(
            label: 'Inicio',
            icon: Icons.home_rounded,
            iosSymbol: 'house.fill',
            route: AppRoutes.home,
          ),
          ModuleNavItem(
            label: 'Paquetes',
            icon: Icons.inventory_2_outlined,
            iosSymbol: 'cube.box',
            route: AppRoutes.packages,
          ),
          ModuleNavItem(
            label: 'Embarc.',
            icon: Icons.flight_takeoff_outlined,
            iosSymbol: 'airplane',
            route: AppRoutes.shipments,
          ),
          ModuleNavItem(
            label: 'Casilleros',
            icon: Icons.warehouse_outlined,
            iosSymbol: 'archivebox',
            route: AppRoutes.warehouses,
          ),
        ],
        onTap: (index) {
          const routes = [
            AppRoutes.home,
            AppRoutes.packages,
            AppRoutes.shipments,
            AppRoutes.warehouses,
          ];
          if (index == selectedIndex) {
            return;
          }
          Navigator.of(context).pushNamedAndRemoveUntil(
            routes[index],
            (route) => false,
          );
        },
      ),
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
