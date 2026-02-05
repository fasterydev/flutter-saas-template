import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/env.dart';
import '../models/package_model.dart';

/// Cliente API enterprise para paquetes (solo endpoints enterprise con auth).
class PackagesApi {
  PackagesApi._();

  static String get _base {
      final u = backendUrl.trim().replaceAll(RegExp(r'/$'), '');
      if (kDebugMode && u.isEmpty) {
        debugPrint('[PackagesApi] BACKEND_URL está vacío. La petición fallará.');
      }
      return u;
    }

  static Future<PackagesResponse> getPackages(
    String token, {
    String? trackingNumber,
    String? startDate,
    String? endDate,
    String? itemStatusId,
    String? warehouseId,
    String? shipmentId,
    String? customerId,
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
    if (itemStatusId != null && itemStatusId.isNotEmpty)
      q['itemStatusId'] = itemStatusId;
    if (warehouseId != null && warehouseId.isNotEmpty)
      q['warehouseId'] = warehouseId;
    if (shipmentId != null && shipmentId.isNotEmpty)
      q['shipmentId'] = shipmentId;
    if (customerId != null && customerId.isNotEmpty)
      q['customerId'] = customerId;

    final fullPath = _base.isEmpty ? '/packages/getPackages' : '$_base/packages/getPackages';
    final uri = Uri.parse(fullPath).replace(queryParameters: q);
    if (kDebugMode) {
      debugPrint('[PackagesApi] GET $uri');
      debugPrint('[PackagesApi] Bearer token (sesión Clerk): ${token.length} caracteres');
    }
    final r = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode) {
      debugPrint('[PackagesApi] Response getPackages ${r.statusCode}: ${r.body}');
    }
    Map<String, dynamic> body;
    try {
      body = jsonDecode(r.body) as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) debugPrint('[PackagesApi] Error al parsear JSON: $e');
      rethrow;
    }
    if (r.statusCode != 200) {
      return PackagesResponse(
        data: [],
        pagination: null,
        message: body['message'] as String?,
        statusCode: r.statusCode,
      );
    }
    return PackagesResponse.fromJson(body);
  }

  static Future<PackageModel?> getPackage(String token, String id) async {
    final uri = Uri.parse('$_base/packages/getPackage/$id');
    if (kDebugMode) {
      debugPrint(
        '[PackagesApi] GET getPackage/$id — Bearer token (sesión Clerk): ${token.length} caracteres',
      );
    }
    final r = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode)
      debugPrint(
        '[PackagesApi] Response getPackage ${r.statusCode}: ${r.body}',
      );
    if (r.statusCode != 200) return null;
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    final data = body['data'] ?? body;
    return PackageModel.fromJson(data as Map<String, dynamic>);
  }

  static Future<Map<String, dynamic>> createPackage(
    String token,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_base/packages/createPackage');
    if (kDebugMode) {
      debugPrint(
        '[PackagesApi] POST createPackage — Bearer token (sesión Clerk): ${token.length} caracteres',
      );
    }
    final r = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (kDebugMode)
      debugPrint(
        '[PackagesApi] Response createPackage ${r.statusCode}: ${r.body}',
      );
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updatePackage(
    String token,
    String id,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_base/packages/updatePackage/$id');
    if (kDebugMode) {
      debugPrint(
        '[PackagesApi] PATCH updatePackage/$id — Bearer token (sesión Clerk): ${token.length} caracteres',
      );
    }
    final r = await http.patch(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (kDebugMode)
      debugPrint(
        '[PackagesApi] Response updatePackage ${r.statusCode}: ${r.body}',
      );
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> deletePackage(
    String token,
    String id,
  ) async {
    final uri = Uri.parse('$_base/packages/deletePackage/$id');
    if (kDebugMode) {
      debugPrint(
        '[PackagesApi] DELETE deletePackage/$id — Bearer token (sesión Clerk): ${token.length} caracteres',
      );
    }
    final r = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode)
      debugPrint(
        '[PackagesApi] Response deletePackage ${r.statusCode}: ${r.body}',
      );
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<PackagesAnalyticsResponse?> getPackagesAnalytics(
    String token, {
    required String startDate,
    required String endDate,
  }) async {
    final uri = Uri.parse(
      '$_base/packages/getPackagesAnalytics',
    ).replace(queryParameters: {'startDate': startDate, 'endDate': endDate});
    if (kDebugMode) {
      debugPrint(
        '[PackagesApi] GET getPackagesAnalytics — Bearer token (sesión Clerk): ${token.length} caracteres',
      );
    }
    final r = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode)
      debugPrint(
        '[PackagesApi] Response getPackagesAnalytics ${r.statusCode}: ${r.body}',
      );
    if (r.statusCode != 200) return null;
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    final data = body['data'] ?? body;
    return PackagesAnalyticsResponse.fromJson(data as Map<String, dynamic>);
  }
}
