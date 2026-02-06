import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/env.dart';
import '../models/customer_model.dart';

/// Cliente API enterprise para clientes (solo endpoints enterprise con auth).
class CustomersApi {
  CustomersApi._();

  static String get _base {
    final u = backendUrl.trim().replaceAll(RegExp(r'/$'), '');
    if (kDebugMode && u.isEmpty) {
      debugPrint('[CustomersApi] BACKEND_URL está vacío. La petición fallará.');
    }
    return u;
  }

  static Future<CustomersResponse> getCustomers(
    String token, {
    String? search,
    bool? isActive,
    String? sortBy,
    int page = 1,
    int limit = 50,
  }) async {
    final q = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search != null && search.isNotEmpty) q['search'] = search;
    if (isActive != null) q['isActive'] = isActive.toString();
    if (sortBy != null && sortBy.isNotEmpty) q['sortBy'] = sortBy;

    final fullPath =
        _base.isEmpty ? '/customers/getCustomers' : '$_base/customers/getCustomers';
    final uri = Uri.parse(fullPath).replace(queryParameters: q);
    if (kDebugMode) debugPrint('[CustomersApi] GET $uri');
    final r = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode) {
      debugPrint(
          '[CustomersApi] Response getCustomers ${r.statusCode}: ${r.body}');
    }
    Map<String, dynamic> body;
    try {
      body = jsonDecode(r.body) as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) debugPrint('[CustomersApi] Error al parsear JSON: $e');
      rethrow;
    }
    if (r.statusCode != 200) {
      return CustomersResponse(
        data: [],
        message: body['message'] as String?,
        statusCode: r.statusCode,
      );
    }
    return CustomersResponse.fromJson(body);
  }

  static Future<CustomerModel?> getCustomer(String token, String id) async {
    final uri = Uri.parse('$_base/customers/getCustomer/$id');
    if (kDebugMode) debugPrint('[CustomersApi] GET getCustomer/$id');
    final r = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode) {
      debugPrint(
          '[CustomersApi] Response getCustomer ${r.statusCode}: ${r.body}');
    }
    if (r.statusCode != 200) return null;
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    final data = body['data'] ?? body;
    return CustomerModel.fromJson(data as Map<String, dynamic>);
  }

  static Future<Map<String, dynamic>> createCustomer(
    String token,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_base/customers/createCustomer');
    if (kDebugMode) debugPrint('[CustomersApi] POST createCustomer');
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
          '[CustomersApi] Response createCustomer ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  /// updateCustomer en la API recibe el body con id incluido (PATCH sin id en path).
  static Future<Map<String, dynamic>> updateCustomer(
    String token,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_base/customers/updateCustomer');
    if (kDebugMode) debugPrint('[CustomersApi] PATCH updateCustomer');
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
          '[CustomersApi] Response updateCustomer ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> deleteCustomer(
      String token, String id) async {
    final uri = Uri.parse('$_base/customers/deleteCustomer/$id');
    if (kDebugMode) debugPrint('[CustomersApi] DELETE deleteCustomer/$id');
    final r = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode) {
      debugPrint(
          '[CustomersApi] Response deleteCustomer ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>?> getCustomersAnalytics(
    String token, {
    required String startDate,
    required String endDate,
  }) async {
    final uri = Uri.parse('$_base/customers/getCustomersAnalytics')
        .replace(queryParameters: {
      'startDate': startDate,
      'endDate': endDate,
    });
    if (kDebugMode) debugPrint('[CustomersApi] GET getCustomersAnalytics');
    final r = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (kDebugMode) {
      debugPrint(
          '[CustomersApi] Response getCustomersAnalytics ${r.statusCode}: ${r.body}');
    }
    if (r.statusCode != 200) return null;
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    return body['data'] as Map<String, dynamic>? ?? body;
  }
}
