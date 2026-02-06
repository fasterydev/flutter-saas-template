import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../../core/nav_data.dart';
import '../../models/shipment_model.dart';
import '../../services/shipments_api.dart';
import '../../widgets/detail_row.dart';

/// Ver toda la información de una embarcación (solo lectura).
class ShipmentDetailPage extends StatefulWidget {
  const ShipmentDetailPage({super.key, required this.id});

  final String id;

  @override
  State<ShipmentDetailPage> createState() => _ShipmentDetailPageState();
}

class _ShipmentDetailPageState extends State<ShipmentDetailPage> {
  ShipmentModel? _shipment;
  bool _loading = true;
  String? _error;

  Future<void> _load(String token) async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final s = await ShipmentsApi.getShipment(token, widget.id);
      if (mounted) {
        setState(() {
          _shipment = s;
          _loading = false;
          _error = s == null ? 'No se encontró la embarcación' : null;
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
        title: const Text('Detalle de embarcación'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          if (_shipment != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.shipmentEdit(widget.id)),
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
              if (token != null && _loading && _shipment == null) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _load(token));
                return const Center(child: CircularProgressIndicator());
              }
              if (_error != null) {
                return Center(child: Text(_error!));
              }
              final s = _shipment!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DetailRow(label: 'ID', value: s.id),
                    DetailRow(label: 'Etiqueta', value: s.label),
                    DetailRow(label: 'Comentario', value: s.comment),
                    DetailRow(
                        label: 'Estado',
                        value: s.itemStatus?.label ?? s.itemStatus?.id),
                    DetailRow(
                        label: 'Total paquetes',
                        value: s.totalPackages?.toString()),
                    DetailRow(
                        label: 'Peso total', value: s.totalWeight?.toString()),
                    DetailRow(
                      label: 'Creado',
                      value: s.createdAt?.toIso8601String(),
                    ),
                    DetailRow(
                      label: 'Actualizado',
                      value: s.updatedAt?.toIso8601String(),
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
