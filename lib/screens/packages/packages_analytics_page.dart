import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../../models/package_model.dart';
import '../../services/packages_api.dart';
import '../../theme/app_theme.dart';

/// Analíticas de paquetes (getPackagesAnalytics).
class PackagesAnalyticsPage extends StatefulWidget {
  const PackagesAnalyticsPage({super.key});

  @override
  State<PackagesAnalyticsPage> createState() => _PackagesAnalyticsPageState();
}

class _PackagesAnalyticsPageState extends State<PackagesAnalyticsPage> {
  PackagesAnalyticsResponse? _data;
  bool _loading = false;
  DateTime _start = DateTime.now().subtract(const Duration(days: 30));
  DateTime _end = DateTime.now();

  Future<void> _load(String token) async {
    setState(() => _loading = true);
    try {
      final startStr = '${_start.year}-${_start.month.toString().padLeft(2, '0')}-${_start.day.toString().padLeft(2, '0')}';
      final endStr = '${_end.year}-${_end.month.toString().padLeft(2, '0')}-${_end.day.toString().padLeft(2, '0')}';
      final res = await PackagesApi.getPackagesAnalytics(
        token,
        startDate: startStr,
        endDate: endStr,
      );
      setState(() {
        _data = res;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analíticas de Paquetes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ClerkAuthBuilder(
        signedInBuilder: (context, authState) {
          return FutureBuilder<String?>(
            future: authState.sessionToken().then((t) => t.jwt),
            builder: (context, snapshot) {
              final token = snapshot.data;
              if (token == null && !snapshot.hasError) {
                return const Center(child: CircularProgressIndicator());
              }
              if (token != null && _data == null && !_loading) {
                WidgetsBinding.instance.addPostFrameCallback((_) => _load(token));
              }
              if (_loading && _data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              final d = _data;
              if (d == null) {
                return const Center(child: Text('Sin datos o error al cargar'));
              }
              final comp = d.comparison;
              final isUp = comp.trend == 'up';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Período actual',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${d.currentPeriod.totalNewPackages} paquetes',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  isUp ? Icons.trending_up : Icons.trending_down,
                                  color: isUp ? Colors.green : Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${comp.percentageChange.toStringAsFixed(1)}% vs período anterior',
                                  style: TextStyle(
                                    color: isUp ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Paquetes por día (período actual)',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: d.currentPeriod.chartData
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(e.date),
                                        Text('${e.count}'),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _loading || token == null
                          ? null
                          : () async {
                              final range = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                                initialDateRange: DateTimeRange(start: _start, end: _end),
                              );
                              if (range != null) {
                                setState(() {
                                  _start = range.start;
                                  _end = range.end;
                                });
                                _load(token!);
                              }
                            },
                      child: const Text('Cambiar rango de fechas'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        signedOutBuilder: (context, _) => const Center(child: Text('Inicia sesión')),
      ),
    );
  }
}
