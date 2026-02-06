import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/env.dart';
import '../models/shipment_model.dart';

/// Cliente API enterprise para envíos/embarcaciones (solo endpoints enterprise con auth).
class ShipmentsApi {
  ShipmentsApi._();

  static String get _base {
    final u = backendUrl.trim().replaceAll(RegExp(r'/$'), '');
    if (kDebugMode && u.isEmpty) {
      debugPrint(
          '[ShipmentsApi] BACKEND_URL está vacío. La petición fallará.');
    }
    return u;
  }

  static Future<List<ShipmentModel>> getShipments(String token) async {
    final uri = Uri.parse('$_base/shipments/getShipments');
    if (kDebugMode) debugPrint('[ShipmentsApi] GET getShipments');
    final r = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode) {
      debugPrint(
          '[ShipmentsApi] Response getShipments ${r.statusCode}: ${r.body}');
    }
    if (r.statusCode != 200) return [];
    final body = jsonDecode(r.body);
    final list = body is List
        ? body
        : (body is Map && body['data'] != null)
            ? body['data'] as List
            : <dynamic>[];
    return list
        .map((e) => ShipmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<ShipmentModel?> getShipment(String token, String id) async {
    final uri = Uri.parse('$_base/shipments/getShipment/$id');
    if (kDebugMode) debugPrint('[ShipmentsApi] GET getShipment/$id');
    final r = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode) {
      debugPrint(
          '[ShipmentsApi] Response getShipment ${r.statusCode}: ${r.body}');
    }
    if (r.statusCode != 200) return null;
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    final data = body['data'] ?? body;
    return ShipmentModel.fromJson(data as Map<String, dynamic>);
  }

  static Future<Map<String, dynamic>> createShipment(
    String token,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_base/shipments/createShipment');
    if (kDebugMode) debugPrint('[ShipmentsApi] POST createShipment');
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
          '[ShipmentsApi] Response createShipment ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateShipment(
    String token,
    String id,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_base/shipments/updateShipment/$id');
    if (kDebugMode) debugPrint('[ShipmentsApi] PATCH updateShipment/$id');
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
          '[ShipmentsApi] Response updateShipment ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> deleteShipment(
      String token, String id) async {
    final uri = Uri.parse('$_base/shipments/deleteShipment/$id');
    if (kDebugMode) debugPrint('[ShipmentsApi] DELETE deleteShipment/$id');
    final r = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode) {
      debugPrint(
          '[ShipmentsApi] Response deleteShipment ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }
}
