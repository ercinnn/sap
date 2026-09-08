import 'package:equatable/equatable.dart';

import 'production_order_status.dart';

/// `production_orders` tablosunun Dart karşılığı — Hazıredim ekranındaki
/// üst tabloda listelenen Kesim/Dikim/Yıkama YM üretim/proses siparişleri.
class ProductionOrder extends Equatable {
  const ProductionOrder({
    this.id,
    required this.orderNumber,
    required this.materialId,
    required this.orderQuantity,
    this.status = ProductionOrderStatus.created,
    this.plannedStartDate,
    this.plannedEndDate,
    this.createdAt,
  });

  final String? id;
  final String orderNumber;
  final String materialId;
  final double orderQuantity;
  final ProductionOrderStatus status;
  final DateTime? plannedStartDate;
  final DateTime? plannedEndDate;
  final DateTime? createdAt;

  factory ProductionOrder.fromJson(Map<String, dynamic> json) {
    return ProductionOrder(
      id: json['id'] as String?,
      orderNumber: json['order_number'] as String,
      materialId: json['material_id'] as String,
      orderQuantity: (json['order_quantity'] as num).toDouble(),
      status: ProductionOrderStatus.fromValue(json['status'] as String),
      plannedStartDate: json['planned_start_date'] == null
          ? null
          : DateTime.parse(json['planned_start_date'] as String),
      plannedEndDate: json['planned_end_date'] == null
          ? null
          : DateTime.parse(json['planned_end_date'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_number': orderNumber,
      'material_id': materialId,
      'order_quantity': orderQuantity,
      'status': status.value,
      'planned_start_date': plannedStartDate?.toIso8601String().split('T').first,
      'planned_end_date': plannedEndDate?.toIso8601String().split('T').first,
    };
  }

  ProductionOrder copyWith({
    String? id,
    String? orderNumber,
    String? materialId,
    double? orderQuantity,
    ProductionOrderStatus? status,
    DateTime? plannedStartDate,
    DateTime? plannedEndDate,
    DateTime? createdAt,
  }) {
    return ProductionOrder(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      materialId: materialId ?? this.materialId,
      orderQuantity: orderQuantity ?? this.orderQuantity,
      status: status ?? this.status,
      plannedStartDate: plannedStartDate ?? this.plannedStartDate,
      plannedEndDate: plannedEndDate ?? this.plannedEndDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        materialId,
        orderQuantity,
        status,
        plannedStartDate,
        plannedEndDate,
        createdAt,
      ];
}
