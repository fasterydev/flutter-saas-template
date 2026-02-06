/// Modelo de almacén (enterprise), alineado con API y Next.js Warehouse.
class WarehouseModel {
  WarehouseModel({
    required this.id,
    required this.countryCode,
    required this.address,
    required this.suiteOrApt,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.phoneNumber,
    this.isActive = true,
    this.pricePerPoundClient,
    this.pricePerPoundProvider,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String countryCode;
  final String address;
  final String suiteOrApt;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String phoneNumber;
  final bool isActive;
  final int? pricePerPoundClient;
  final int? pricePerPoundProvider;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: json['id'] as String,
      countryCode: json['countryCode'] as String? ?? '',
      address: json['address'] as String? ?? '',
      suiteOrApt: json['suiteOrApt'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      pricePerPoundClient: json['pricePerPoundClient'] as int?,
      pricePerPoundProvider: json['pricePerPoundProvider'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'countryCode': countryCode,
        'address': address,
        'suiteOrApt': suiteOrApt,
        'city': city,
        'state': state,
        'country': country,
        'postalCode': postalCode,
        'phoneNumber': phoneNumber,
        'isActive': isActive,
        'pricePerPoundClient': pricePerPoundClient,
        'pricePerPoundProvider': pricePerPoundProvider,
      };
}
