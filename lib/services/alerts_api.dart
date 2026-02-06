import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/env.dart';
import '../models/alert_model.dart';

/// Cliente API enterprise para alertas (solo endpoints enterprise con auth).
class AlertsApi {
  AlertsApi._();

  static String get _base {
    final u = backendUrl.trim().replaceAll(RegExp(r'/$'), '');
    if (kDebugMode && u.isEmpty) {
      debugPrint('[AlertsApi] BACKEND_URL está vacío. La petición fallará.');
    }
    return u;
  }

  static Future<AlertsResponse> getAlerts(
    String token, {
    String? trackingNumber,
    String? startDate,
    String? endDate,
    String? status,
    String? warehouseId,
    String? customerId,
    String? enterpriseId,
    int page = 1,
    int limit = 50,
  }) async {
    final q = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (trackingNumber != null && trackingNumber.isNotEmpty)
      q['trackingNumber'] = trackingNumber;
    if (startDate != null && startDate.isNotEmpty) q['startDate'] = startDate;
    if (endDate != null && endDate.isNotEmpty) q['endDate'] = endDate;
    if (status != null && status.isNotEmpty) q['status'] = status;
    if (warehouseId != null && warehouseId.isNotEmpty)
      q['warehouseId'] = warehouseId;
    if (customerId != null && customerId.isNotEmpty)
      q['customerId'] = customerId;
    if (enterpriseId != null && enterpriseId.isNotEmpty)
      q['enterpriseId'] = enterpriseId;

    final fullPath =
        _base.isEmpty ? '/alerts/getAlerts' : '$_base/alerts/getAlerts';
    final uri = Uri.parse(fullPath).replace(queryParameters: q);
    if (kDebugMode) {
      debugPrint('[AlertsApi] GET $uri');
    }
    final r = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode) {
      debugPrint('[AlertsApi] Response getAlerts ${r.statusCode}: ${r.body}');
    }
    Map<String, dynamic> body;
    try {
      body = jsonDecode(r.body) as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) debugPrint('[AlertsApi] Error al parsear JSON: $e');
      rethrow;
    }
    if (r.statusCode != 200) {
      return AlertsResponse(
        data: [],
        message: body['message'] as String?,
        statusCode: r.statusCode,
      );
    }
    return AlertsResponse.fromJson(body);
  }

  static Future<AlertModel?> getAlert(String token, String id) async {
    final uri = Uri.parse('$_base/alerts/getAlert/$id');
    if (kDebugMode) debugPrint('[AlertsApi] GET getAlert/$id');
    final r = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode) {
      debugPrint('[AlertsApi] Response getAlert ${r.statusCode}: ${r.body}');
    }
    if (r.statusCode != 200) return null;
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    final data = body['data'] ?? body;
    return AlertModel.fromJson(data as Map<String, dynamic>);
  }

  static Future<Map<String, dynamic>> createAlert(
    String token,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_base/alerts/createAlert');
    if (kDebugMode) debugPrint('[AlertsApi] POST createAlert');
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
          '[AlertsApi] Response createAlert ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateAlert(
    String token,
    String id,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_base/alerts/updateAlert/$id');
    if (kDebugMode) debugPrint('[AlertsApi] PATCH updateAlert/$id');
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
          '[AlertsApi] Response updateAlert ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> deleteAlert(String token, String id) async {
    final uri = Uri.parse('$_base/alerts/deleteAlert/$id');
    if (kDebugMode) debugPrint('[AlertsApi] DELETE deleteAlert/$id');
    final r = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode) {
      debugPrint(
          '[AlertsApi] Response deleteAlert ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  /// Crea un paquete desde una alerta (alertId + itemStatusId).
  static Future<Map<String, dynamic>> createPackageFromAlert(
    String token, {
    required String alertId,
    required String itemStatusId,
  }) async {
    final uri = Uri.parse('$_base/alerts/createPackageFromAlert');
    if (kDebugMode) debugPrint('[AlertsApi] POST createPackageFromAlert');
    final r = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'alertId': alertId,
        'itemStatusId': itemStatusId,
      }),
    );
    if (kDebugMode) {
      debugPrint(
          '[AlertsApi] Response createPackageFromAlert ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }
}
