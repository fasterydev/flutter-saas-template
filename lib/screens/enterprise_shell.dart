import 'package:flutter/material.dart';

import '../core/nav_data.dart';
import '../core/page_transitions.dart';
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
    return Navigator(
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        final name = settings.name ?? AppRoutes.home;

        // ----- Home y configuración -----
        if (name == AppRoutes.home) {
          return slideFadeRoute(settings, const HomePage());
        }
        if (name == AppRoutes.settings) {
          return slideFadeRoute(settings, const SettingsPage());
        }

        // ----- Alertas -----
        if (name == AppRoutes.alerts) {
          return slideFadeRoute(settings, const AlertsListPage());
        }
        if (name == AppRoutes.alertsNew) {
          return slideFadeRoute(settings, const AlertFormPage());
        }
        if (name.startsWith('${AppRoutes.alerts}/') && name != AppRoutes.alertsNew) {
          final rest = name.replaceFirst('${AppRoutes.alerts}/', '');
          if (rest.endsWith('/edit')) {
            final id = rest.replaceFirst('/edit', '');
            return slideFadeRoute(settings, AlertFormPage(id: id));
          }
          return slideFadeRoute(settings, AlertDetailPage(id: rest));
        }

        // ----- Paquetes -----
        if (name == AppRoutes.packages) {
          return slideFadeRoute(settings, const PackagesListPage());
        }
        if (name == AppRoutes.packagesNew) {
          return slideFadeRoute(settings, const PackageFormPage());
        }
        if (name == AppRoutes.packagesAnalytics) {
          return slideFadeRoute(settings, const PackagesAnalyticsPage());
        }
        if (name.startsWith('${AppRoutes.packages}/') && name != AppRoutes.packagesNew && name != AppRoutes.packagesAnalytics && name != AppRoutes.packagesStates) {
          final rest = name.replaceFirst('${AppRoutes.packages}/', '');
          if (rest.endsWith('/edit')) {
            final id = rest.replaceFirst('/edit', '');
            return slideFadeRoute(settings, PackageFormPage(id: id));
          }
          return slideFadeRoute(settings, PackageDetailPage(id: rest));
        }

        // ----- Embarcaciones (shipments) -----
        if (name == AppRoutes.shipments) {
          return slideFadeRoute(settings, const ShipmentsListPage());
        }
        if (name == AppRoutes.shipmentsNew) {
          return slideFadeRoute(settings, const ShipmentFormPage());
        }
        if (name.startsWith('${AppRoutes.shipments}/') && name != AppRoutes.shipmentsNew) {
          final rest = name.replaceFirst('${AppRoutes.shipments}/', '');
          if (rest.endsWith('/edit')) {
            final id = rest.replaceFirst('/edit', '');
            return slideFadeRoute(settings, ShipmentFormPage(id: id));
          }
          return slideFadeRoute(settings, ShipmentDetailPage(id: rest));
        }

        // ----- Casilleros (warehouses) -----
        if (name == AppRoutes.warehouses) {
          return slideFadeRoute(settings, const WarehousesListPage());
        }
        if (name == AppRoutes.warehousesNew) {
          return slideFadeRoute(settings, const WarehouseFormPage());
        }
        if (name.startsWith('${AppRoutes.warehouses}/') && name != AppRoutes.warehousesNew) {
          final rest = name.replaceFirst('${AppRoutes.warehouses}/', '');
          if (rest.endsWith('/edit')) {
            final id = rest.replaceFirst('/edit', '');
            return slideFadeRoute(settings, WarehouseFormPage(id: id));
          }
          return slideFadeRoute(settings, WarehouseDetailPage(id: rest));
        }

        // ----- Clientes -----
        if (name == AppRoutes.customers) {
          return slideFadeRoute(settings, const CustomersListPage());
        }
        if (name == AppRoutes.customersNew) {
          return slideFadeRoute(settings, const CustomerFormPage());
        }
        if (name.startsWith('${AppRoutes.customers}/') && name != AppRoutes.customersNew) {
          final rest = name.replaceFirst('${AppRoutes.customers}/', '');
          if (rest.endsWith('/edit')) {
            final id = rest.replaceFirst('/edit', '');
            return slideFadeRoute(settings, CustomerFormPage(id: id));
          }
          return slideFadeRoute(settings, CustomerDetailPage(id: rest));
        }

        // Placeholder para el resto de rutas (deliveries, sales, analytics, etc.)
        return slideFadeRoute(settings, _PlaceholderPage(title: name));
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
