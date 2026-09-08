import 'package:equatable/equatable.dart';

import 'movement_type.dart';

/// `material_movements` tablosunun Dart karşılığı — 261 (Malzeme Çıkışı)
/// ve 101 (Mamul Girişi) hareketleri.
class MaterialMovement extends Equatable {
  const MaterialMovement({
    this.id,
    required this.movementType,
    required this.materialId,
    this.productionOrderId,
    required this.quantity,
    required this.unit,
    this.movementDate,
    this.createdBy,
  });

  final String? id;
  final MovementType movementType;
  final String materialId;
  final String? productionOrderId;
  final double quantity;
  final String unit;
  final DateTime? movementDate;
  final String? createdBy;

  factory MaterialMovement.fromJson(Map<String, dynamic> json) {
    return MaterialMovement(
      id: json['id'] as String?,
      movementType: MovementType.fromValue(json['movement_type'] as String),
      materialId: json['material_id'] as String,
      productionOrderId: json['production_order_id'] as String?,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      movementDate: json['movement_date'] == null
          ? null
          : DateTime.parse(json['movement_date'] as String),
      createdBy: json['created_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movement_type': movementType.value,
      'material_id': materialId,
      'production_order_id': productionOrderId,
      'quantity': quantity,
      'unit': unit,
      'created_by': createdBy,
    };
  }

  MaterialMovement copyWith({
    String? id,
    MovementType? movementType,
    String? materialId,
    String? productionOrderId,
    double? quantity,
    String? unit,
    DateTime? movementDate,
    String? createdBy,
  }) {
    return MaterialMovement(
      id: id ?? this.id,
      movementType: movementType ?? this.movementType,
      materialId: materialId ?? this.materialId,
      productionOrderId: productionOrderId ?? this.productionOrderId,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      movementDate: movementDate ?? this.movementDate,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        movementType,
        materialId,
        productionOrderId,
        quantity,
        unit,
        movementDate,
        createdBy,
      ];
}
