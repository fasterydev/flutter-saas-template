import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../../core/nav_data.dart';
import '../../services/warehouses_api.dart';

/// Crear o editar casillero/almacén.
class WarehouseFormPage extends StatefulWidget {
  const WarehouseFormPage({super.key, this.id});

  final String? id;

  @override
  State<WarehouseFormPage> createState() => _WarehouseFormPageState();
}

class _WarehouseFormPageState extends State<WarehouseFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _loaded = false;

  String _countryCode = '';
  String _address = '';
  String _suiteOrApt = '';
  String _city = '';
  String _state = '';
  String _country = '';
  String _postalCode = '';
  String _phoneNumber = '';
  bool _isActive = true;
  int? _pricePerPoundClient;
  int? _pricePerPoundProvider;

  bool get isEdit => widget.id != null && widget.id != 'new';

  Future<void> _loadWarehouse(String token) async {
    if (widget.id == null || widget.id == 'new') {
      if (mounted) setState(() => _loaded = true);
      return;
    }
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final w = await WarehousesApi.getWarehouse(token, widget.id!);
      if (!mounted) return;
      if (w != null) {
        setState(() {
          _countryCode = w.countryCode;
          _address = w.address;
          _suiteOrApt = w.suiteOrApt;
          _city = w.city;
          _state = w.state;
          _country = w.country;
          _postalCode = w.postalCode;
          _phoneNumber = w.phoneNumber;
          _isActive = w.isActive;
          _pricePerPoundClient = w.pricePerPoundClient;
          _pricePerPoundProvider = w.pricePerPoundProvider;
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
        'countryCode': _countryCode.trim(),
        'address': _address.trim(),
        'suiteOrApt': _suiteOrApt.trim(),
        'city': _city.trim(),
        'state': _state.trim(),
        'country': _country.trim(),
        'postalCode': _postalCode.trim(),
        'phoneNumber': _phoneNumber.trim(),
        'isActive': _isActive,
        'pricePerPoundClient': _pricePerPoundClient,
        'pricePerPoundProvider': _pricePerPoundProvider,
      };
      if (isEdit) {
        await WarehousesApi.updateWarehouse(token, widget.id!, body);
      } else {
        await WarehousesApi.createWarehouse(token, body);
      }
      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.warehouses, (route) => false);
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
        title: Text(isEdit ? 'Editar casillero' : 'Nuevo casillero'),
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
                    (_) => _loadWarehouse(token));
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
                          labelText: 'Código de país',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _countryCode,
                        onChanged: (v) => _countryCode = v,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Dirección',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _address,
                        onChanged: (v) => _address = v,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Suite/Apto',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _suiteOrApt,
                        onChanged: (v) => _suiteOrApt = v,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Ciudad',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _city,
                        onChanged: (v) => _city = v,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Estado',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _state,
                        onChanged: (v) => _state = v,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'País',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _country,
                        onChanged: (v) => _country = v,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Código postal',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _postalCode,
                        onChanged: (v) => _postalCode = v,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        initialValue: _phoneNumber,
                        onChanged: (v) => _phoneNumber = v,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        title: const Text('Activo'),
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v ?? true),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Precio por libra (cliente)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _pricePerPoundClient?.toString(),
                        onChanged: (v) =>
                            _pricePerPoundClient = int.tryParse(v ?? ''),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Precio por libra (proveedor)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _pricePerPoundProvider?.toString(),
                        onChanged: (v) =>
                            _pricePerPoundProvider = int.tryParse(v ?? ''),
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
                            : Text(isEdit ? 'Guardar' : 'Crear casillero'),
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
