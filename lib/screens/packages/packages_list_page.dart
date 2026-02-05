import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/env.dart';
import '../../core/nav_data.dart';
import '../../models/package_model.dart';
import '../../services/packages_api.dart';

/// Lista de paquetes (enterprise) con filtros y paginación.
class PackagesListPage extends StatefulWidget {
  const PackagesListPage({super.key});

  @override
  State<PackagesListPage> createState() => _PackagesListPageState();
}

class _PackagesListPageState extends State<PackagesListPage> {
  List<PackageModel> _packages = [];
  PaginationInfo? _pagination;
  bool _loading = false;
  int _page = 1;
  final _limit = 20;
  String? _trackingNumber;

  Future<void> _load(String? token, {bool resetPage = false}) async {
    if (kDebugMode) {
      debugPrint('[Paquetes] Consultar: token=${token != null && token.isNotEmpty ? "${token.length} chars" : "null o vacío"}, BACKEND_URL=$backendUrl');
    }
    if (token == null || token.isEmpty) {
      if (kDebugMode) debugPrint('[Paquetes] No se hace la petición: falta token de sesión.');
      return;
    }
    if (backendUrl.isEmpty) {
      if (kDebugMode) debugPrint('[Paquetes] No se hace la petición: BACKEND_URL está vacío (revisa .env y que esté en assets).');
      return;
    }
    if (resetPage) _page = 1;
    setState(() => _loading = true);
    try {
      final res = await PackagesApi.getPackages(
        token,
        page: _page,
        limit: _limit,
        trackingNumber: _trackingNumber?.trim().isEmpty == true ? null : _trackingNumber,
      );
      setState(() {
        _packages = res.data;
        _pagination = res.pagination;
        _loading = false;
      });
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[Paquetes] Error al consultar API: $e');
        debugPrint(st.toString());
      }
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paquetes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.packagesNew),
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
              if (token != null && _packages.isEmpty && !_loading) {
                WidgetsBinding.instance.addPostFrameCallback((_) => _load(token, resetPage: true));
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
                              labelText: 'Número de seguimiento',
                              hintText: 'Buscar...',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (v) => _trackingNumber = v,
                            onSubmitted: (_) => _load(token, resetPage: true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: _loading ? null : () => _load(token, resetPage: true),
                          child: const Text('Buscar'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _loading && _packages.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : _packages.isEmpty
                            ? const Center(child: Text('No hay paquetes'))
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _packages.length + 1,
                                itemBuilder: (context, i) {
                                  if (i == _packages.length) {
                                    final p = _pagination;
                                    if (p == null || (p.hasNextPage != true)) return const SizedBox.shrink();
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Center(
                                        child: TextButton(
                                          onPressed: () {
                                            _page++;
                                            _load(token, resetPage: false);
                                          },
                                          child: const Text('Cargar más'),
                                        ),
                                      ),
                                    );
                                  }
                                  final p = _packages[i];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      title: Text(p.trackingNumber ?? p.id),
                                      subtitle: Text(
                                        p.itemStatus?.label ?? 'Sin estado',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () => Navigator.of(context)
                                                .pushNamed(AppRoutes.packageEdit(p.id)),
                                          ),
                                        ],
                                      ),
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(AppRoutes.packageEdit(p.id)),
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
        signedOutBuilder: (context, _) => const Center(child: Text('Inicia sesión')),
      ),
    );
  }
}
