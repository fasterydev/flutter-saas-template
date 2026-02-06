import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../../core/nav_data.dart';
import '../../models/warehouse_model.dart';
import '../../services/warehouses_api.dart';
import '../../widgets/detail_row.dart';

/// Ver toda la información de un casillero (solo lectura).
class WarehouseDetailPage extends StatefulWidget {
  const WarehouseDetailPage({super.key, required this.id});

  final String id;

  @override
  State<WarehouseDetailPage> createState() => _WarehouseDetailPageState();
}

class _WarehouseDetailPageState extends State<WarehouseDetailPage> {
  WarehouseModel? _warehouse;
  bool _loading = true;
  String? _error;

  Future<void> _load(String token) async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final w = await WarehousesApi.getWarehouse(token, widget.id);
      if (mounted) {
        setState(() {
          _warehouse = w;
          _loading = false;
          _error = w == null ? 'No se encontró el casillero' : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del casillero'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          if (_warehouse != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.warehouseEdit(widget.id)),
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
              if (token != null && _loading && _warehouse == null) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _load(token));
                return const Center(child: CircularProgressIndicator());
              }
              if (_error != null) {
                return Center(child: Text(_error!));
              }
              final w = _warehouse!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DetailRow(label: 'ID', value: w.id),
                    DetailRow(label: 'Código de país', value: w.countryCode),
                    DetailRow(label: 'Dirección', value: w.address),
                    DetailRow(label: 'Suite/Apto', value: w.suiteOrApt),
                    DetailRow(label: 'Ciudad', value: w.city),
                    DetailRow(label: 'Estado', value: w.state),
                    DetailRow(label: 'País', value: w.country),
                    DetailRow(label: 'Código postal', value: w.postalCode),
                    DetailRow(label: 'Teléfono', value: w.phoneNumber),
                    DetailRow(label: 'Activo', value: w.isActive ? 'Sí' : 'No'),
                    DetailRow(
                        label: 'Precio por libra (cliente)',
                        value: w.pricePerPoundClient?.toString()),
                    DetailRow(
                        label: 'Precio por libra (proveedor)',
                        value: w.pricePerPoundProvider?.toString()),
                    DetailRow(
                      label: 'Creado',
                      value: w.createdAt?.toIso8601String(),
                    ),
                    DetailRow(
                      label: 'Actualizado',
                      value: w.updatedAt?.toIso8601String(),
                    ),
                  ],
                ),
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
