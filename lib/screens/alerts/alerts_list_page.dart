import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/env.dart';
import '../../core/nav_data.dart';
import '../../models/alert_model.dart';
import '../../services/alerts_api.dart';
import '../../widgets/empty_state_message.dart';

/// Lista de alertas (enterprise) con filtros.
class AlertsListPage extends StatefulWidget {
  const AlertsListPage({super.key});

  @override
  State<AlertsListPage> createState() => _AlertsListPageState();
}

class _AlertsListPageState extends State<AlertsListPage> {
  List<AlertModel> _alerts = [];
  bool _loading = false;
  int _page = 1;
  final _limit = 20;

  Future<void> _load(String? token, {bool resetPage = false}) async {
    if (token == null || token.isEmpty) return;
    if (backendUrl.isEmpty) return;
    if (resetPage) _page = 1;
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final res = await AlertsApi.getAlerts(
        token,
        page: _page,
        limit: _limit,
      );
      if (!mounted) return;
      setState(() {
        _alerts = res.data;
        _loading = false;
      });
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[Alertas] Error: $e');
        debugPrint(st.toString());
      }
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.alertsNew),
          ),
        ],
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
              if (token != null && _alerts.isEmpty && !_loading) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _load(token, resetPage: true));
              }
              if (_loading && _alerts.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_alerts.isEmpty) {
                return const EmptyStateMessage(
                  message: 'No hay alertas',
                  icon: Icons.notifications_none_outlined,
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _alerts.length,
                itemBuilder: (context, i) {
                  final a = _alerts[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(a.trackingNumber),
                      subtitle: Text('Estado: ${a.status}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.alertDetail(a.id)),
                    ),
                  );
                },
              );
            },
          );
        },
        signedOutBuilder: (context, _) =>
            const Center(child: Text('Inicia sesión')),
      ),
    );
  }
}
