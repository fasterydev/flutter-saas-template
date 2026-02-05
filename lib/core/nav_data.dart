import 'package:flutter/material.dart';

/// Ítem del menú principal (navMain) o secundario (navSecondary).
class NavItem {
  const NavItem({
    required this.title,
    required this.route,
    required this.icon,
    this.comingSoon = false,
    this.isActive = false,
    this.items = const [],
  });

  final String title;
  final String route;
  final IconData icon;
  final bool comingSoon;
  final bool isActive;
  final List<NavSubItem> items;
}

class NavSubItem {
  const NavSubItem({required this.title, required this.route});

  final String title;
  final String route;
}

/// Rutas de la app (enterprise).
class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const alerts = '/alerts';
  static const alertsAnalytics = '/alerts/analytics';
  static const packages = '/packages';
  static const packagesStates = '/packages/states';
  static const packagesAnalytics = '/packages/analytics';
  static const packagesNew = '/packages/new';
  static String packageEdit(String id) => '/packages/$id';

  static const shipments = '/shipments';
  static const shipmentsStates = '/shipments/states';
  static const shipmentsAnalytics = '/shipments/analytics';

  static const warehouses = '/warehouses';

  static const deliveries = '/deliveries';
  static const deliveriesAnalytics = '/deliveries/analytics';

  static const sales = '/sales';
  static const salesAnalytics = '/sales/analytics';

  static const customers = '/customers';
  static const customersAnalytics = '/customers/analytics';

  static const settings = '/settings';
}

/// Datos de navegación principal (equivalente a navMain en Next.js).
final List<NavItem> navMain = [
  NavItem(
    title: 'Alertas',
    route: AppRoutes.alerts,
    icon: Icons.notifications_outlined,
    comingSoon: false,
    items: [
      const NavSubItem(title: 'Todas las alertas', route: AppRoutes.alerts),
      const NavSubItem(title: 'Analíticas', route: AppRoutes.alertsAnalytics),
    ],
  ),
  NavItem(
    title: 'Paquetes',
    route: AppRoutes.packages,
    icon: Icons.inventory_2_outlined,
    comingSoon: false,
    items: [
      const NavSubItem(title: 'Todos los paquetes', route: AppRoutes.packages),
      const NavSubItem(title: 'Estados de seguimiento', route: AppRoutes.packagesStates),
      const NavSubItem(title: 'Analíticas', route: AppRoutes.packagesAnalytics),
    ],
  ),
  NavItem(
    title: 'Embarcaciones',
    route: AppRoutes.shipments,
    icon: Icons.flight_takeoff_outlined,
    comingSoon: false,
    items: [
      const NavSubItem(title: 'Todas las embarcaciones', route: AppRoutes.shipments),
      const NavSubItem(title: 'Estados de embarcaciones', route: AppRoutes.shipmentsStates),
      const NavSubItem(title: 'Analíticas', route: AppRoutes.shipmentsAnalytics),
    ],
  ),
  NavItem(
    title: 'Casilleros',
    route: AppRoutes.warehouses,
    icon: Icons.warehouse_outlined,
    comingSoon: false,
    items: [
      const NavSubItem(title: 'Todos los casilleros', route: AppRoutes.warehouses),
    ],
  ),
  NavItem(
    title: 'Envíos',
    route: AppRoutes.deliveries,
    icon: Icons.local_shipping_outlined,
    comingSoon: false,
    items: [
      const NavSubItem(title: 'Todos los envíos', route: AppRoutes.deliveries),
      const NavSubItem(title: 'Analíticas', route: AppRoutes.deliveriesAnalytics),
    ],
  ),
  NavItem(
    title: 'Comprobantes',
    route: AppRoutes.sales,
    icon: Icons.receipt_long_outlined,
    comingSoon: false,
    items: [
      const NavSubItem(title: 'Todos los comprobantes', route: AppRoutes.sales),
      const NavSubItem(title: 'Analíticas', route: AppRoutes.salesAnalytics),
    ],
  ),
  NavItem(
    title: 'Clientes',
    route: AppRoutes.customers,
    icon: Icons.people_outline,
    comingSoon: false,
    items: [
      const NavSubItem(title: 'Todos los clientes', route: AppRoutes.customers),
      const NavSubItem(title: 'Analíticas', route: AppRoutes.customersAnalytics),
    ],
  ),
];

/// Navegación secundaria (navSecondary).
final List<NavItem> navSecondary = [
  NavItem(
    title: 'Configuración',
    route: AppRoutes.settings,
    icon: Icons.settings_outlined,
  ),
];
