import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../../core/nav_data.dart';
import '../../services/shipments_api.dart';

/// Crear o editar embarcación/envío.
class ShipmentFormPage extends StatefulWidget {
  const ShipmentFormPage({super.key, this.id});

  final String? id;

  @override
  State<ShipmentFormPage> createState() => _ShipmentFormPageState();
}

class _ShipmentFormPageState extends State<ShipmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _loaded = false;

  String _label = '';
  String _comment = '';
  String? _itemStatusId;

  bool get isEdit => widget.id != null && widget.id != 'new';

  Future<void> _loadShipment(String token) async {
    if (widget.id == null || widget.id == 'new') {
      if (mounted) setState(() => _loaded = true);
      return;
    }
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final s = await ShipmentsApi.getShipment(token, widget.id!);
      if (!mounted) return;
      if (s != null) {
        setState(() {
          _label = s.label;
          _comment = s.comment ?? '';
          _itemStatusId = s.itemStatus?.id;
          _loading = false;
          _loaded = true;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit(String token) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final body = <String, dynamic>{
        'label': _label.trim(),
        'comment': _comment.trim().isEmpty ? null : _comment.trim(),
        'itemStatusId': _itemStatusId,
      };
      if (isEdit) {
        await ShipmentsApi.updateShipment(token, widget.id!, body);
      } else {
        await ShipmentsApi.createShipment(token, body);
      }
      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.shipments, (route) => false);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al guardar')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar embarcación' : 'Nueva embarcación'),
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
              if (token != null && !_loaded && !_loading) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _loadShipment(token));
              }
              if (!_loaded && _loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Etiqueta / Nombre',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _label,
                        onChanged: (v) => _label = v,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Comentario',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        initialValue: _comment,
                        onChanged: (v) => _comment = v,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _loading || token == null
                            ? null
                            : () => _submit(token!),
                        child: _loading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(isEdit ? 'Guardar' : 'Crear embarcación'),
                      ),
                    ],
                  ),
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
