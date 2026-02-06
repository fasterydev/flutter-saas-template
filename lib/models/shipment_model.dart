/// Modelo de envío/embarcación (enterprise), alineado con API y Next.js Shipment.
class ShipmentModel {
  ShipmentModel({
    required this.id,
    required this.label,
    this.comment,
    this.itemStatus,
    this.totalPackages,
    this.totalWeight,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String label;
  final String? comment;
  final ShipmentItemStatusRef? itemStatus;
  final int? totalPackages;
  final int? totalWeight;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      id: json['id'] as String,
      label: json['label'] as String? ?? '',
      comment: json['comment'] as String?,
      itemStatus: json['itemStatus'] != null
          ? ShipmentItemStatusRef.fromJson(
              json['itemStatus'] as Map<String, dynamic>)
          : null,
      totalPackages: json['totalPackages'] as int?,
      totalWeight: json['totalWeight'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'comment': comment,
        'itemStatusId': itemStatus?.id,
      };
}

class ShipmentItemStatusRef {
  ShipmentItemStatusRef({required this.id, this.label, this.icon});

  final String id;
  final String? label;
  final String? icon;

  factory ShipmentItemStatusRef.fromJson(Map<String, dynamic> json) =>
      ShipmentItemStatusRef(
        id: json['id'] as String,
        label: json['label'] as String?,
        icon: json['icon'] as String?,
      );
}
