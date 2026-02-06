import 'package:flutter/material.dart';

import '../core/nav_data.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_asset.dart';

/// Pantalla principal con diseño profesional y navegación por módulos.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar compacta
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    const BrandAsset(height: 28),
                    const Spacer(),
                    Icon(
                      Icons.person_outline_rounded,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
            // Hero / bienvenida
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panel de control',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gestiona alertas, paquetes, embarcaciones y más.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.65),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Accent bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            // Título sección principal
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SectionLabel(
                  label: 'Módulos',
                  colorScheme: colorScheme,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            // Grid de módulos (2 columnas, proporción equilibrada)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.92,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = navMain[index];
                    return _NavCard(
                      item: item,
                      onTap: () => _navigateTo(context, item),
                    );
                  },
                  childCount: navMain.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            // Configuración
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SectionLabel(
                  label: 'Configuración',
                  colorScheme: colorScheme,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = navSecondary[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _NavCard(
                        item: item,
                        onTap: () => _navigateTo(context, item),
                        isSecondary: true,
                      ),
                    );
                  },
                  childCount: navSecondary.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, NavItem item) {
    if (item.comingSoon) return;
    Navigator.of(context).pushNamed(item.route);
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
    required this.colorScheme,
  });

  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.85),
            letterSpacing: 0.15,
          ),
        ),
      ],
    );
  }
}

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.item,
    required this.onTap,
    this.isSecondary = false,
  });

  final NavItem item;
  final VoidCallback onTap;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.darkCard : AppTheme.lightCard;
    final fg = isDark ? AppTheme.darkForeground : AppTheme.lightForeground;
    final borderColor = isDark
        ? colorScheme.outline.withValues(alpha: 0.25)
        : colorScheme.outline.withValues(alpha: 0.4);

    final disabled = item.comingSoon;
    final iconColor = disabled
        ? fg.withValues(alpha: 0.4)
        : colorScheme.primary;
    final textColor = disabled ? fg.withValues(alpha: 0.5) : fg;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      elevation: 0,
      shadowColor: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        splashColor: colorScheme.primary.withValues(alpha: 0.12),
        highlightColor: colorScheme.primary.withValues(alpha: 0.06),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(isSecondary ? 12 : 12),
            child: isSecondary
                ? Row(
                    children: [
                      _IconCircle(
                        icon: item.icon,
                        color: iconColor,
                        backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                        size: 36,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.title,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: textColor.withValues(alpha: 0.6),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _IconCircle(
                        icon: item.icon,
                        color: iconColor,
                        backgroundColor: colorScheme.primary.withValues(alpha: 0.14),
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          height: 1.22,
                        ),
                      ),
                      if (item.comingSoon) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Próximamente',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: fg.withValues(alpha: 0.5),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    this.size = 36,
  });

  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Icon(icon, size: size * 0.52, color: color),
    );
  }
}
