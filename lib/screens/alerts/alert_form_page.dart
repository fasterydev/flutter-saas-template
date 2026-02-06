import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../../core/nav_data.dart';
import '../../services/alerts_api.dart';

/// Crear o editar alerta.
class AlertFormPage extends StatefulWidget {
  const AlertFormPage({super.key, this.id});

  final String? id;

  @override
  State<AlertFormPage> createState() => _AlertFormPageState();
}

class _AlertFormPageState extends State<AlertFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _loaded = false;

  String _trackingNumber = '';
  String _registrationDate = '';
  int _declaredValue = 0;
  String _status = 'unreviewed';
  int? _weight;
  int? _height;
  int? _width;
  int? _length;
  String _comments = '';
  String? _warehouseId;
  String? _customerId;

  bool get isEdit => widget.id != null && widget.id != 'new';

  Future<void> _loadAlert(String token) async {
    if (widget.id == null || widget.id == 'new') {
      if (mounted) setState(() => _loaded = true);
      return;
    }
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final a = await AlertsApi.getAlert(token, widget.id!);
      if (!mounted) return;
      if (a != null) {
        setState(() {
          _trackingNumber = a.trackingNumber;
          _registrationDate = a.registrationDate;
          _declaredValue = a.declaredValue;
          _status = a.status;
          _weight = a.weight;
          _height = a.height;
          _width = a.width;
          _length = a.length;
          _comments = a.comments ?? '';
          _warehouseId = a.warehouse?.id;
          _customerId = a.customer?.id;
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
        'trackingNumber': _trackingNumber.trim(),
        'registrationDate': _registrationDate.isEmpty
            ? DateTime.now().toIso8601String()
            : _registrationDate,
        'declaredValue': _declaredValue,
        'status': _status,
        'weight': _weight,
        'height': _height,
        'width': _width,
        'length': _length,
        'comments': _comments.trim().isEmpty ? null : _comments.trim(),
        'warehouseId': _warehouseId,
        'customerId': _customerId,
      };
      if (isEdit) {
        await AlertsApi.updateAlert(token, widget.id!, body);
      } else {
        await AlertsApi.createAlert(token, body);
      }
      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.alerts, (route) => false);
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
        title: Text(isEdit ? 'Editar alerta' : 'Nueva alerta'),
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
                    (_) => _loadAlert(token));
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
                          labelText: 'Número de seguimiento',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _trackingNumber,
                        onChanged: (v) => _trackingNumber = v,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Fecha de registro (YYYY-MM-DD)',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _registrationDate,
                        onChanged: (v) => _registrationDate = v,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Valor declarado',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _declaredValue.toString(),
                        onChanged: (v) => _declaredValue = int.tryParse(v) ?? 0,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _status,
                        decoration: const InputDecoration(
                          labelText: 'Estado',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'unreviewed', child: Text('Sin revisar')),
                          DropdownMenuItem(value: 'archived', child: Text('Archivada')),
                        ],
                        onChanged: (v) => setState(() => _status = v ?? _status),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Comentarios',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        initialValue: _comments,
                        onChanged: (v) => _comments = v,
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
                            : Text(isEdit ? 'Guardar' : 'Crear alerta'),
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
