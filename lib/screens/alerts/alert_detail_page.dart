import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../../core/nav_data.dart';
import '../../models/alert_model.dart';
import '../../services/alerts_api.dart';
import '../../widgets/detail_row.dart';

/// Ver toda la información de una alerta (solo lectura).
class AlertDetailPage extends StatefulWidget {
  const AlertDetailPage({super.key, required this.id});

  final String id;

  @override
  State<AlertDetailPage> createState() => _AlertDetailPageState();
}

class _AlertDetailPageState extends State<AlertDetailPage> {
  AlertModel? _alert;
  bool _loading = true;
  String? _error;

  Future<void> _load(String token) async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final a = await AlertsApi.getAlert(token, widget.id);
      if (mounted) {
        setState(() {
          _alert = a;
          _loading = false;
          _error = a == null ? 'No se encontró la alerta' : null;
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
        title: const Text('Detalle de alerta'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          if (_alert != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.alertEdit(widget.id)),
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
              if (token != null && _loading && _alert == null) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _load(token));
                return const Center(child: CircularProgressIndicator());
              }
              if (_error != null) {
                return Center(child: Text(_error!));
              }
              final a = _alert!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DetailRow(label: 'ID', value: a.id),
                    DetailRow(label: 'Número de seguimiento', value: a.trackingNumber),
                    DetailRow(label: 'Fecha de registro', value: a.registrationDate),
                    DetailRow(label: 'Valor declarado', value: '${a.declaredValue}'),
                    DetailRow(label: 'Estado', value: a.status),
                    DetailRow(label: 'Peso', value: a.weight?.toString()),
                    DetailRow(label: 'Alto', value: a.height?.toString()),
                    DetailRow(label: 'Ancho', value: a.width?.toString()),
                    DetailRow(label: 'Largo', value: a.length?.toString()),
                    DetailRow(label: 'Comentarios', value: a.comments),
                    DetailRow(label: 'Tiendas', value: a.stores.isEmpty ? null : a.stores.join(', ')),
                    DetailRow(label: 'Casillero', value: a.warehouse?.address ?? a.warehouse?.id),
                    DetailRow(
                      label: 'Cliente',
                      value: a.customer != null
                          ? '${a.customer!.firstName ?? ''} ${a.customer!.lastName ?? ''}'.trim()
                          : a.customer?.email,
                    ),
                    DetailRow(
                      label: 'Creado',
                      value: a.createdAt?.toIso8601String(),
                    ),
                    DetailRow(
                      label: 'Actualizado',
                      value: a.updatedAt?.toIso8601String(),
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
