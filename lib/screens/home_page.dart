import 'package:flutter/material.dart';

import '../core/nav_data.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_asset.dart';

/// Pantalla principal con grid de navegación (navMain + navSecondary).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BrandAsset(height: 28),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: const [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Menú principal',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  ...navMain.map((item) => _NavCard(
                        item: item,
                        onTap: () => _navigateTo(context, item),
                      )),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Configuración',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
              ),
              const SizedBox(height: 12),
              ...navSecondary.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _NavCard(item: item, onTap: () => _navigateTo(context, item)),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, NavItem item) {
    if (item.comingSoon) return;
    Navigator.of(context).pushNamed(item.route);
  }
}

class _NavCard extends StatelessWidget {
  const _NavCard({required this.item, required this.onTap});

  final NavItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final fg = isDark ? AppTheme.darkForeground : AppTheme.lightForeground;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: InkWell(
        onTap: item.comingSoon ? null : onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                size: 32,
                color: item.comingSoon
                    ? fg.withValues(alpha: 0.4)
                    : theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: item.comingSoon ? fg.withValues(alpha: 0.5) : fg,
                ),
              ),
              if (item.comingSoon)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Próximamente',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: fg.withValues(alpha: 0.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
