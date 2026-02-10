/// Modelo de alerta (enterprise), alineado con API y Next.js Alert.
class AlertModel {
  AlertModel({
    required this.id,
    required this.trackingNumber,
    required this.registrationDate,
    required this.declaredValue,
    required this.status,
    this.weight,
    this.height,
    this.width,
    this.length,
    this.comments,
    this.stores = const [],
    this.invoicesFileUrl,
    this.warehouse,
    this.customer,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String trackingNumber;
  final String registrationDate;
  final int declaredValue;
  final String status; // 'archived' | 'unreviewed'
  final int? weight;
  final int? height;
  final int? width;
  final int? length;
  final String? comments;
  final List<String> stores;
  final List<AlertFileItem>? invoicesFileUrl;
  final AlertWarehouseRef? warehouse;
  final AlertCustomerRef? customer;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      trackingNumber: json['trackingNumber'] as String? ?? '',
      registrationDate: json['registrationDate']?.toString() ?? '',
      declaredValue: json['declaredValue'] as int? ?? 0,
      status: json['status'] as String? ?? 'unreviewed',
      weight: json['weight'] as int?,
      height: json['height'] as int?,
      width: json['width'] as int?,
      length: json['length'] as int?,
      comments: json['comments'] as String?,
      stores: json['stores'] != null
          ? List<String>.from(json['stores'] as List)
          : [],
      invoicesFileUrl: json['invoicesFileUrl'] != null
          ? (json['invoicesFileUrl'] as List)
              .map((e) => AlertFileItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      warehouse: json['warehouse'] != null
          ? AlertWarehouseRef.fromJson(json['warehouse'] as Map<String, dynamic>)
          : null,
      customer: json['customer'] != null
          ? AlertCustomerRef.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'trackingNumber': trackingNumber,
        'registrationDate': registrationDate,
        'declaredValue': declaredValue,
        'status': status,
        'weight': weight,
        'height': height,
        'width': width,
        'length': length,
        'comments': comments,
        'stores': stores,
        'warehouseId': warehouse?.id,
        'customerId': customer?.id,
      };
}

class AlertFileItem {
  AlertFileItem({
    required this.name,
    required this.url,
    required this.type,
  });

  final String name;
  final String url;
  final String type;

  factory AlertFileItem.fromJson(Map<String, dynamic> json) => AlertFileItem(
        name: json['name'] as String? ?? '',
        url: json['url'] as String? ?? '',
        type: json['type'] as String? ?? '',
      );
}

class AlertWarehouseRef {
  AlertWarehouseRef({required this.id, this.address, this.city});

  final String id;
  final String? address;
  final String? city;

  factory AlertWarehouseRef.fromJson(Map<String, dynamic> json) =>
      AlertWarehouseRef(
        id: json['id'] as String,
        address: json['address'] as String?,
        city: json['city'] as String?,
      );
}

class AlertCustomerRef {
  AlertCustomerRef({required this.id, this.firstName, this.lastName, this.email});

  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;

  factory AlertCustomerRef.fromJson(Map<String, dynamic> json) =>
      AlertCustomerRef(
        id: json['id'] as String,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
      );
}

/// Respuesta paginada de getAlerts.
class AlertsResponse {
  AlertsResponse({
    required this.data,
    this.total = 0,
    this.page = 1,
    this.limit = 50,
    this.totalPages = 0,
    this.message,
    this.statusCode,
  });

  final List<AlertModel> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final String? message;
  final int? statusCode;

  factory AlertsResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final list = raw is List<dynamic> ? raw : <dynamic>[];
    return AlertsResponse(
      data: list
          .map((e) => AlertModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 50,
      totalPages: json['totalPages'] as int? ?? 0,
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }
}
