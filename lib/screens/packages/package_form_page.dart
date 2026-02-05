import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../../core/nav_data.dart';
import '../../services/packages_api.dart';

/// Crear o editar paquete (equivalente a [slug] new o id).
class PackageFormPage extends StatefulWidget {
  const PackageFormPage({super.key, this.id});

  /// null = crear, no null = editar
  final String? id;

  @override
  State<PackageFormPage> createState() => _PackageFormPageState();
}

class _PackageFormPageState extends State<PackageFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _loaded = false;

  String _trackingNumber = '';
  int? _weight;
  int? _height;
  int? _width;
  int? _length;
  int? _declaredValue;
  String _comments = '';
  String? _itemStatusId;
  String? _warehouseId;
  String? _shipmentId;
  String? _customerId;
  DateTime? _registrationDate;

  bool get isEdit => widget.id != null && widget.id != 'new';

  Future<void> _loadPackage(String token) async {
    if (widget.id == null || widget.id == 'new') {
      setState(() => _loaded = true);
      return;
    }
    setState(() => _loading = true);
    try {
      final p = await PackagesApi.getPackage(token, widget.id!);
      if (p != null) {
        setState(() {
          _trackingNumber = p.trackingNumber ?? '';
          _weight = p.weight;
          _height = p.height;
          _width = p.width;
          _length = p.length;
          _declaredValue = p.declaredValue;
          _comments = p.comments ?? '';
          _itemStatusId = p.itemStatus?.id;
          _warehouseId = p.warehouse?.id;
          _shipmentId = p.shipment?.id;
          _customerId = p.customer?.id;
          _registrationDate = p.registrationDate;
          _loading = false;
          _loaded = true;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _submit(String token) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final body = <String, dynamic>{
        'trackingNumber': _trackingNumber.trim().isEmpty
            ? null
            : _trackingNumber.trim(),
        'weight': _weight,
        'height': _height,
        'width': _width,
        'length': _length,
        'declaredValue': _declaredValue,
        'comments': _comments.trim().isEmpty ? null : _comments.trim(),
        'itemStatusId': _itemStatusId,
        'warehouseId': _warehouseId,
        'shipmentId': _shipmentId,
        'customerId': _customerId,
        if (_registrationDate != null)
          'registrationDate': _registrationDate!.toIso8601String(),
      };
      if (isEdit) {
        await PackagesApi.updatePackage(token, widget.id!, body);
      } else {
        await PackagesApi.createPackage(token, body);
      }
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.packages, (route) => false);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error al guardar')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar paquete' : 'Nuevo paquete'),
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
                  (_) => _loadPackage(token),
                );
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
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Peso (ej. gramos)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _weight?.toString(),
                        onChanged: (v) => _weight = int.tryParse(v),
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(isEdit ? 'Guardar' : 'Crear paquete'),
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
