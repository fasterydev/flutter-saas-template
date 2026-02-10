import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/env.dart';
import '../../core/nav_data.dart';
import '../../models/warehouse_model.dart';
import '../../services/warehouses_api.dart';
import '../../widgets/empty_state_message.dart';

/// Lista de casilleros/almacenes (enterprise).
class WarehousesListPage extends StatefulWidget {
  const WarehousesListPage({super.key});

  @override
  State<WarehousesListPage> createState() => _WarehousesListPageState();
}

class _WarehousesListPageState extends State<WarehousesListPage> {
  List<WarehouseModel> _warehouses = [];
  bool _loading = false;

  Future<void> _load(String? token) async {
    if (token == null || token.isEmpty) return;
    if (backendUrl.isEmpty) return;
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final list = await WarehousesApi.getWarehouses(token);
      if (!mounted) return;
      setState(() {
        _warehouses = list;
        _loading = false;
      });
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[Casilleros] Error: $e');
        debugPrint(st.toString());
      }
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Casilleros'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.warehousesNew),
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
              if (token != null && _warehouses.isEmpty && !_loading) {
                WidgetsBinding.instance.addPostFrameCallback((_) => _load(token));
              }
              if (_loading && _warehouses.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_warehouses.isEmpty) {
                return const EmptyStateMessage(
                  message: 'No hay casilleros',
                  icon: Icons.warehouse_outlined,
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _warehouses.length,
                itemBuilder: (context, i) {
                  final w = _warehouses[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(w.address),
                      subtitle: Text('${w.city}, ${w.country}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.warehouseDetail(w.id)),
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
