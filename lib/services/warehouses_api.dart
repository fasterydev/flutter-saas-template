import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/env.dart';
import '../models/warehouse_model.dart';

/// Cliente API enterprise para almacenes (solo endpoints enterprise con auth).
class WarehousesApi {
  WarehousesApi._();

  static String get _base {
    final u = backendUrl.trim().replaceAll(RegExp(r'/$'), '');
    if (kDebugMode && u.isEmpty) {
      debugPrint(
          '[WarehousesApi] BACKEND_URL está vacío. La petición fallará.');
    }
    return u;
  }

  static Future<List<WarehouseModel>> getWarehouses(String token) async {
    final uri = Uri.parse('$_base/warehouses/getWarehouses');
    if (kDebugMode) debugPrint('[WarehousesApi] GET getWarehouses');
    final r = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode) {
      debugPrint(
          '[WarehousesApi] Response getWarehouses ${r.statusCode}: ${r.body}');
    }
    if (r.statusCode != 200) return [];
    final body = jsonDecode(r.body);
    final list = body is List
        ? body
        : (body is Map && body['data'] != null)
            ? body['data'] as List
            : <dynamic>[];
    return list
        .map((e) => WarehouseModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<WarehouseModel?> getWarehouse(String token, String id) async {
    final uri = Uri.parse('$_base/warehouses/getWarehouse/$id');
    if (kDebugMode) debugPrint('[WarehousesApi] GET getWarehouse/$id');
    final r = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode) {
      debugPrint(
          '[WarehousesApi] Response getWarehouse ${r.statusCode}: ${r.body}');
    }
    if (r.statusCode != 200) return null;
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    final data = body['data'] ?? body;
    return WarehouseModel.fromJson(data as Map<String, dynamic>);
  }

  static Future<Map<String, dynamic>> createWarehouse(
    String token,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_base/warehouses/createWarehouse');
    if (kDebugMode) debugPrint('[WarehousesApi] POST createWarehouse');
    final r = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (kDebugMode) {
      debugPrint(
          '[WarehousesApi] Response createWarehouse ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateWarehouse(
    String token,
    String id,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_base/warehouses/updateWarehouse/$id');
    if (kDebugMode) debugPrint('[WarehousesApi] PATCH updateWarehouse/$id');
    final r = await http.patch(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (kDebugMode) {
      debugPrint(
          '[WarehousesApi] Response updateWarehouse ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> deleteWarehouse(
      String token, String id) async {
    final uri = Uri.parse('$_base/warehouses/deleteWarehouse/$id');
    if (kDebugMode) debugPrint('[WarehousesApi] DELETE deleteWarehouse/$id');
    final r = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode) {
      debugPrint(
          '[WarehousesApi] Response deleteWarehouse ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }
}
