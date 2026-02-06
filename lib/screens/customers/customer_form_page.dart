import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../../core/nav_data.dart';
import '../../services/customers_api.dart';

/// Crear o editar cliente.
class CustomerFormPage extends StatefulWidget {
  const CustomerFormPage({super.key, this.id});

  final String? id;

  @override
  State<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _loaded = false;

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  bool _isActive = true;
  String _whatsapp = '';
  String _city = '';
  String _stateOrProvince = '';
  String _address = '';
  String _postalCode = '';
  String _note = '';
  String? _nationality;
  String? _identityType;
  String? _identityNumber;

  bool get isEdit => widget.id != null && widget.id != 'new';

  Future<void> _loadCustomer(String token) async {
    if (widget.id == null || widget.id == 'new') {
      if (mounted) setState(() => _loaded = true);
      return;
    }
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final c = await CustomersApi.getCustomer(token, widget.id!);
      if (!mounted) return;
      if (c != null) {
        setState(() {
          _firstName = c.firstName ?? '';
          _lastName = c.lastName ?? '';
          _email = c.email ?? '';
          _isActive = c.isActive;
          _whatsapp = c.whatsapp ?? '';
          _city = c.city ?? '';
          _stateOrProvince = c.stateOrProvince ?? '';
          _address = c.address ?? '';
          _postalCode = c.postalCode ?? '';
          _note = c.note ?? '';
          _nationality = c.nationality;
          _identityType = c.identityType;
          _identityNumber = c.identityNumber;
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
        'firstName': _firstName.trim(),
        'lastName': _lastName.trim(),
        'email': _email.trim(),
        'isActive': _isActive,
        'whatsapp': _whatsapp.trim().isEmpty ? null : _whatsapp.trim(),
        'city': _city.trim().isEmpty ? null : _city.trim(),
        'stateOrProvince': _stateOrProvince.trim().isEmpty ? null : _stateOrProvince.trim(),
        'address': _address.trim().isEmpty ? null : _address.trim(),
        'postalCode': _postalCode.trim().isEmpty ? null : _postalCode.trim(),
        'note': _note.trim().isEmpty ? null : _note.trim(),
        'nationality': _nationality,
        'identityType': _identityType,
        'identityNumber': _identityNumber,
      };
      if (isEdit) {
        body['id'] = widget.id;
        await CustomersApi.updateCustomer(token, body);
      } else {
        await CustomersApi.createCustomer(token, body);
      }
      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.customers, (route) => false);
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
        title: Text(isEdit ? 'Editar cliente' : 'Nuevo cliente'),
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
                    (_) => _loadCustomer(token));
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
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _firstName,
                        onChanged: (v) => _firstName = v,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Apellido',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _lastName,
                        onChanged: (v) => _lastName = v,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        initialValue: _email,
                        onChanged: (v) => _email = v,
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
                          labelText: 'WhatsApp',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _whatsapp,
                        onChanged: (v) => _whatsapp = v,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Ciudad',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _city,
                        onChanged: (v) => _city = v,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Dirección',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        initialValue: _address,
                        onChanged: (v) => _address = v,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nota',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        initialValue: _note,
                        onChanged: (v) => _note = v,
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
                            : Text(isEdit ? 'Guardar' : 'Crear cliente'),
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
