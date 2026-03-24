import 'package:flutter/material.dart';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';

class ModuleNavItem {
  const ModuleNavItem({
    required this.label,
    required this.icon,
    required this.iosSymbol,
    required this.route,
    this.selectedIcon,
    this.selectedIosSymbol,
  });

  final String label;
  final IconData icon;
  final String iosSymbol;
  final String route;
  final IconData? selectedIcon;
  final String? selectedIosSymbol;
}

/// Configuración de bottom navigation usando adaptive_platform_ui.
AdaptiveBottomNavigationBar buildAdaptiveModuleBottomNavigationBar({
  required List<ModuleNavItem> items,
  required int selectedIndex,
  required ValueChanged<int> onTap,
  bool useNativeBottomBar = true,
}) {
  return AdaptiveBottomNavigationBar(
    useNativeBottomBar: useNativeBottomBar,
    selectedIndex: selectedIndex,
    onTap: onTap,
    items: items
        .map(
          (item) => AdaptiveNavigationDestination(
            icon: PlatformInfo.isIOS ? item.iosSymbol : item.icon,
            selectedIcon: PlatformInfo.isIOS
                ? (item.selectedIosSymbol ?? item.iosSymbol)
                : (item.selectedIcon ?? item.icon),
            label: item.label,
          ),
        )
        .toList(),
  );
}
