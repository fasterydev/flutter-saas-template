import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/env.dart';
import '../../core/nav_data.dart';
import '../../models/customer_model.dart';
import '../../services/customers_api.dart';
import '../../widgets/empty_state_message.dart';

/// Lista de clientes (enterprise).
class CustomersListPage extends StatefulWidget {
  const CustomersListPage({super.key});

  @override
  State<CustomersListPage> createState() => _CustomersListPageState();
}

class _CustomersListPageState extends State<CustomersListPage> {
  List<CustomerModel> _customers = [];
  bool _loading = false;
  int _page = 1;
  final _limit = 20;
  String _search = '';

  Future<void> _load(String? token, {bool resetPage = false}) async {
    if (token == null || token.isEmpty) return;
    if (backendUrl.isEmpty) return;
    if (resetPage) _page = 1;
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final res = await CustomersApi.getCustomers(
        token,
        page: _page,
        limit: _limit,
        search: _search.trim().isEmpty ? null : _search.trim(),
      );
      if (!mounted) return;
      setState(() {
        _customers = res.data;
        _loading = false;
      });
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[Clientes] Error: $e');
        debugPrint(st.toString());
      }
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.customersNew),
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
              if (token != null && _customers.isEmpty && !_loading) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _load(token, resetPage: true));
              }
              if (_loading && _customers.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_customers.isEmpty) {
                return const EmptyStateMessage(
                  message: 'No hay clientes',
                  icon: Icons.people_outline,
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Buscar',
                              hintText: 'Nombre, email...',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (v) => _search = v,
                            onSubmitted: (_) => _load(token, resetPage: true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: _loading
                              ? null
                              : () => _load(token, resetPage: true),
                          child: const Text('Buscar'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _customers.length,
                      itemBuilder: (context, i) {
                        final c = _customers[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(c.fullName),
                            subtitle: Text(c.email ?? '—'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.of(context)
                                .pushNamed(AppRoutes.customerDetail(c.id)),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
