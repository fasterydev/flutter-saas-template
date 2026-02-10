import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/env.dart';
import '../../core/nav_data.dart';
import '../../models/shipment_model.dart';
import '../../services/shipments_api.dart';
import '../../widgets/empty_state_message.dart';

/// Lista de embarcaciones/envíos (enterprise).
class ShipmentsListPage extends StatefulWidget {
  const ShipmentsListPage({super.key});

  @override
  State<ShipmentsListPage> createState() => _ShipmentsListPageState();
}

class _ShipmentsListPageState extends State<ShipmentsListPage> {
  List<ShipmentModel> _shipments = [];
  bool _loading = false;

  Future<void> _load(String? token) async {
    if (token == null || token.isEmpty) return;
    if (backendUrl.isEmpty) return;
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final list = await ShipmentsApi.getShipments(token);
      if (!mounted) return;
      setState(() {
        _shipments = list;
        _loading = false;
      });
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[Embarcaciones] Error: $e');
        debugPrint(st.toString());
      }
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Embarcaciones'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.shipmentsNew),
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
              if (token != null && _shipments.isEmpty && !_loading) {
                WidgetsBinding.instance.addPostFrameCallback((_) => _load(token));
              }
              if (_loading && _shipments.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_shipments.isEmpty) {
                return const EmptyStateMessage(
                  message: 'No hay embarcaciones',
                  icon: Icons.flight_takeoff_outlined,
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _shipments.length,
                itemBuilder: (context, i) {
                  final s = _shipments[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(s.label),
                      subtitle: Text(
                        s.itemStatus?.label ?? 'Sin estado',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.shipmentDetail(s.id)),
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
