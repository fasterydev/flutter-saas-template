import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../../core/nav_data.dart';
import '../../models/package_model.dart';
import '../../services/packages_api.dart';
import '../../widgets/detail_row.dart';

/// Ver toda la información de un paquete (solo lectura).
class PackageDetailPage extends StatefulWidget {
  const PackageDetailPage({super.key, required this.id});

  final String id;

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage> {
  PackageModel? _package;
  bool _loading = true;
  String? _error;

  Future<void> _load(String token) async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final p = await PackagesApi.getPackage(token, widget.id);
      if (mounted) {
        setState(() {
          _package = p;
          _loading = false;
          _error = p == null ? 'No se encontró el paquete' : null;
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
        title: const Text('Detalle del paquete'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          if (_package != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.packageEdit(widget.id)),
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
              if (token != null && _loading && _package == null) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _load(token));
                return const Center(child: CircularProgressIndicator());
              }
              if (_error != null) {
                return Center(child: Text(_error!));
              }
              final p = _package!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DetailRow(label: 'ID', value: p.id),
                    DetailRow(label: 'Número de seguimiento', value: p.trackingNumber),
                    DetailRow(label: 'Estado', value: p.itemStatus?.label ?? p.itemStatus?.id),
                    DetailRow(label: 'Peso', value: p.weight?.toString()),
                    DetailRow(label: 'Alto', value: p.height?.toString()),
                    DetailRow(label: 'Ancho', value: p.width?.toString()),
                    DetailRow(label: 'Largo', value: p.length?.toString()),
                    DetailRow(label: 'Valor declarado', value: p.declaredValue?.toString()),
                    DetailRow(label: 'Fecha de registro', value: p.registrationDate?.toIso8601String()),
                    DetailRow(label: 'Comentarios', value: p.comments),
                    DetailRow(label: 'Tiendas', value: p.stores.isEmpty ? null : p.stores.join(', ')),
                    DetailRow(label: 'Casillero', value: p.warehouse?.address ?? p.warehouse?.city ?? p.warehouse?.id),
                    DetailRow(label: 'Embarcación', value: p.shipment?.label ?? p.shipment?.id),
                    DetailRow(label: 'Cliente', value: p.customer?.name ?? p.customer?.email ?? p.customer?.id),
                    DetailRow(label: 'Creado', value: p.createdAt?.toIso8601String()),
                    DetailRow(label: 'Actualizado', value: p.updatedAt?.toIso8601String()),
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
