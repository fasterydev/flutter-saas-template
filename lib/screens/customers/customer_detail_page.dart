import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../../core/nav_data.dart';
import '../../models/customer_model.dart';
import '../../services/customers_api.dart';
import '../../widgets/detail_row.dart';

/// Ver toda la información de un cliente (solo lectura).
class CustomerDetailPage extends StatefulWidget {
  const CustomerDetailPage({super.key, required this.id});

  final String id;

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  CustomerModel? _customer;
  bool _loading = true;
  String? _error;

  Future<void> _load(String token) async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final c = await CustomersApi.getCustomer(token, widget.id);
      if (mounted) {
        setState(() {
          _customer = c;
          _loading = false;
          _error = c == null ? 'No se encontró el cliente' : null;
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
        title: const Text('Detalle del cliente'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          if (_customer != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.customerEdit(widget.id)),
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
              if (token != null && _loading && _customer == null) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _load(token));
                return const Center(child: CircularProgressIndicator());
              }
              if (_error != null) {
                return Center(child: Text(_error!));
              }
              final c = _customer!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DetailRow(label: 'ID', value: c.id),
                    DetailRow(label: 'Código', value: c.code?.toString()),
                    DetailRow(label: 'Nombre', value: c.firstName),
                    DetailRow(label: 'Apellido', value: c.lastName),
                    DetailRow(label: 'Nombre completo', value: c.fullName),
                    DetailRow(label: 'Email', value: c.email),
                    DetailRow(label: 'Activo', value: c.isActive ? 'Sí' : 'No'),
                    DetailRow(label: 'WhatsApp', value: c.whatsapp),
                    DetailRow(label: 'Ciudad', value: c.city),
                    DetailRow(label: 'Estado/Provincia', value: c.stateOrProvince),
                    DetailRow(label: 'Dirección', value: c.address),
                    DetailRow(label: 'Código postal', value: c.postalCode),
                    DetailRow(label: 'Nacionalidad', value: c.nationality),
                    DetailRow(label: 'Tipo de identidad', value: c.identityType),
                    DetailRow(label: 'Número de identidad', value: c.identityNumber),
                    DetailRow(label: 'Nota', value: c.note),
                    DetailRow(
                      label: 'Creado',
                      value: c.createdAt?.toIso8601String(),
                    ),
                    DetailRow(
                      label: 'Actualizado',
                      value: c.updatedAt?.toIso8601String(),
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
