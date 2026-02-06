/// Modelo de cliente (enterprise), alineado con API y Next.js Customer.
class CustomerModel {
  CustomerModel({
    required this.id,
    this.code,
    this.email,
    this.firstName,
    this.lastName,
    this.isActive = true,
    this.nationality,
    this.identityType,
    this.identityNumber,
    this.whatsapp,
    this.city,
    this.stateOrProvince,
    this.address,
    this.postalCode,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final int? code;
  final String? email;
  final String? firstName;
  final String? lastName;
  final bool isActive;
  final String? nationality;
  final String? identityType;
  final String? identityNumber;
  final String? whatsapp;
  final String? city;
  final String? stateOrProvince;
  final String? address;
  final String? postalCode;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get fullName {
    final parts = [firstName, lastName].where((e) => e != null && e.isNotEmpty);
    return parts.isEmpty ? (email ?? id) : parts.join(' ');
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String,
      code: json['code'] as int?,
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      nationality: json['nationality'] as String?,
      identityType: json['identityType'] as String?,
      identityNumber: json['identityNumber'] as String?,
      whatsapp: json['whatsapp'] as String?,
      city: json['city'] as String?,
      stateOrProvince: json['stateOrProvince'] as String?,
      address: json['address'] as String?,
      postalCode: json['postalCode'] as String?,
      note: json['note'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'isActive': isActive,
        'nationality': nationality,
        'identityType': identityType,
        'identityNumber': identityNumber,
        'whatsapp': whatsapp,
        'city': city,
        'stateOrProvince': stateOrProvince,
        'address': address,
        'postalCode': postalCode,
        'note': note,
      };
}

/// Respuesta paginada de getCustomers.
class CustomersResponse {
  CustomersResponse({
    required this.data,
    this.pagination,
    this.message,
    this.statusCode,
  });

  final List<CustomerModel> data;
  final CustomerPaginationInfo? pagination;
  final String? message;
  final int? statusCode;

  factory CustomersResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final list = raw is List<dynamic> ? raw : <dynamic>[];
    return CustomersResponse(
      data: list
          .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? CustomerPaginationInfo.fromJson(
              json['pagination'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }
}

class CustomerPaginationInfo {
  CustomerPaginationInfo({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    this.hasNextPage,
    this.hasPrevPage,
  });

  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool? hasNextPage;
  final bool? hasPrevPage;

  factory CustomerPaginationInfo.fromJson(Map<String, dynamic> json) =>
      CustomerPaginationInfo(
        total: json['total'] as int? ?? 0,
        page: json['page'] as int? ?? 1,
        limit: json['limit'] as int? ?? 10,
        totalPages: json['totalPages'] as int? ?? 0,
        hasNextPage: json['hasNextPage'] as bool?,
        hasPrevPage: json['hasPrevPage'] as bool?,
      );
}

/// Analíticas de clientes (getCustomersAnalytics).
class CustomersAnalyticsResponse {
  CustomersAnalyticsResponse({required this.data});

  final Map<String, dynamic> data;

  factory CustomersAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      CustomersAnalyticsResponse(data: json['data'] as Map<String, dynamic>? ?? {});
}
