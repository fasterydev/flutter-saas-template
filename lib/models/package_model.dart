/// Modelo de paquete (enterprise), alineado con API y Next.js Package.
class PackageModel {
  PackageModel({
    required this.id,
    this.trackingNumber,
    this.weight,
    this.height,
    this.width,
    this.length,
    this.stores = const [],
    this.declaredValue,
    this.registrationDate,
    this.comments,
    this.invoicesFileUrl,
    this.itemStatus,
    this.warehouse,
    this.shipment,
    this.customer,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? trackingNumber;
  final int? weight;
  final int? height;
  final int? width;
  final int? length;
  final List<String> stores;
  final int? declaredValue;
  final DateTime? registrationDate;
  final String? comments;
  final List<FileItem>? invoicesFileUrl;
  final ItemStatusRef? itemStatus;
  final WarehouseRef? warehouse;
  final ShipmentRef? shipment;
  final CustomerRef? customer;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'] as String,
      trackingNumber: json['trackingNumber'] as String?,
      weight: json['weight'] as int?,
      height: json['height'] as int?,
      width: json['width'] as int?,
      length: json['length'] as int?,
      stores: json['stores'] != null
          ? List<String>.from(json['stores'] as List)
          : [],
      declaredValue: json['declaredValue'] as int?,
      registrationDate: json['registrationDate'] != null
          ? DateTime.tryParse(json['registrationDate'] as String)
          : null,
      comments: json['comments'] as String?,
      invoicesFileUrl: json['invoicesFileUrl'] != null
          ? (json['invoicesFileUrl'] as List)
              .map((e) => FileItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      itemStatus: json['itemStatus'] != null
          ? ItemStatusRef.fromJson(json['itemStatus'] as Map<String, dynamic>)
          : null,
      warehouse: json['warehouse'] != null
          ? WarehouseRef.fromJson(json['warehouse'] as Map<String, dynamic>)
          : null,
      shipment: json['shipment'] != null
          ? ShipmentRef.fromJson(json['shipment'] as Map<String, dynamic>)
          : null,
      customer: json['customer'] != null
          ? CustomerRef.fromJson(json['customer'] as Map<String, dynamic>)
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
        'id': id,
        'trackingNumber': trackingNumber,
        'weight': weight,
        'height': height,
        'width': width,
        'length': length,
        'stores': stores,
        'declaredValue': declaredValue,
        'registrationDate': registrationDate?.toIso8601String(),
        'comments': comments,
        'itemStatusId': itemStatus?.id,
        'warehouseId': warehouse?.id,
        'shipmentId': shipment?.id,
        'customerId': customer?.id,
      };
}

class FileItem {
  FileItem({required this.name, required this.url, required this.type});

  final String name;
  final String url;
  final String type;

  factory FileItem.fromJson(Map<String, dynamic> json) => FileItem(
        name: json['name'] as String? ?? '',
        url: json['url'] as String? ?? '',
        type: json['type'] as String? ?? '',
      );
}

class ItemStatusRef {
  ItemStatusRef({required this.id, this.label, this.icon});

  final String id;
  final String? label;
  final String? icon;

  factory ItemStatusRef.fromJson(Map<String, dynamic> json) => ItemStatusRef(
        id: json['id'] as String,
        label: json['label'] as String?,
        icon: json['icon'] as String?,
      );
}

class WarehouseRef {
  WarehouseRef({
    required this.id,
    this.address,
    this.city,
    this.state,
    this.countryCode,
  });

  final String id;
  final String? address;
  final String? city;
  final String? state;
  final String? countryCode;

  factory WarehouseRef.fromJson(Map<String, dynamic> json) => WarehouseRef(
        id: json['id'] as String,
        address: json['address'] as String?,
        city: json['city'] as String?,
        state: json['state'] as String?,
        countryCode: json['countryCode'] as String?,
      );
}

class ShipmentRef {
  ShipmentRef({required this.id, this.label});

  final String id;
  final String? label;

  factory ShipmentRef.fromJson(Map<String, dynamic> json) => ShipmentRef(
        id: json['id'] as String,
        label: json['label'] as String?,
      );
}

class CustomerRef {
  CustomerRef({required this.id, this.name, this.email});

  final String id;
  final String? name;
  final String? email;

  factory CustomerRef.fromJson(Map<String, dynamic> json) => CustomerRef(
        id: json['id'] as String,
        name: json['name'] as String?,
        email: json['email'] as String?,
      );
}

/// Respuesta paginada de getPackages.
class PackagesResponse {
  PackagesResponse({
    required this.data,
    this.pagination,
    this.message,
    this.statusCode,
  });

  final List<PackageModel> data;
  final PaginationInfo? pagination;
  final String? message;
  final int? statusCode;

  factory PackagesResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final list = raw is List<dynamic> ? raw : <dynamic>[];
    return PackagesResponse(
      data: list.map((e) => PackageModel.fromJson(e as Map<String, dynamic>)).toList(),
      pagination: json['pagination'] != null
          ? PaginationInfo.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }
}

class PaginationInfo {
  PaginationInfo({
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

  factory PaginationInfo.fromJson(Map<String, dynamic> json) => PaginationInfo(
        total: json['total'] as int? ?? 0,
        page: json['page'] as int? ?? 1,
        limit: json['limit'] as int? ?? 10,
        totalPages: json['totalPages'] as int? ?? 0,
        hasNextPage: json['hasNextPage'] as bool?,
        hasPrevPage: json['hasPrevPage'] as bool?,
      );
}

/// Analíticas de paquetes (getPackagesAnalytics).
class PackagesAnalyticsResponse {
  PackagesAnalyticsResponse({
    required this.currentPeriod,
    required this.previousPeriod,
    required this.comparison,
  });

  final AnalyticsPeriod currentPeriod;
  final AnalyticsPeriod previousPeriod;
  final AnalyticsComparison comparison;

  factory PackagesAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      PackagesAnalyticsResponse(
        currentPeriod: AnalyticsPeriod.fromJson(
            json['currentPeriod'] as Map<String, dynamic>),
        previousPeriod: AnalyticsPeriod.fromJson(
            json['previousPeriod'] as Map<String, dynamic>),
        comparison: AnalyticsComparison.fromJson(
            json['comparison'] as Map<String, dynamic>),
      );
}

class AnalyticsPeriod {
  AnalyticsPeriod({
    required this.startDate,
    required this.endDate,
    required this.totalNewPackages,
    required this.chartData,
  });

  final String startDate;
  final String endDate;
  final int totalNewPackages;
  final List<ChartDataPoint> chartData;

  factory AnalyticsPeriod.fromJson(Map<String, dynamic> json) =>
      AnalyticsPeriod(
        startDate: json['startDate'] as String? ?? '',
        endDate: json['endDate'] as String? ?? '',
        totalNewPackages: json['totalNewPackages'] as int? ?? 0,
        chartData: (json['chartData'] as List<dynamic>?)
                ?.map((e) =>
                    ChartDataPoint.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class ChartDataPoint {
  ChartDataPoint({required this.date, required this.count});

  final String date;
  final int count;

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) =>
      ChartDataPoint(
        date: json['date'] as String? ?? '',
        count: json['count'] as int? ?? 0,
      );
}

class AnalyticsComparison {
  AnalyticsComparison({
    required this.difference,
    required this.percentageChange,
    required this.trend,
  });

  final int difference;
  final double percentageChange;
  final String trend;

  factory AnalyticsComparison.fromJson(Map<String, dynamic> json) =>
      AnalyticsComparison(
        difference: json['difference'] as int? ?? 0,
        percentageChange: (json['percentageChange'] as num?)?.toDouble() ?? 0,
        trend: json['trend'] as String? ?? 'stable',
      );
}
