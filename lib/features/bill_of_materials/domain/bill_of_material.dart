import 'package:equatable/equatable.dart';

/// `bill_of_materials` tablosunun Dart karşılığı — bir ana malzemenin
/// (örn. Jean Pantolon) bir bileşenden (kumaş, düğme, rivet...) ne kadar
/// gerektiğini tanımlar.
class BillOfMaterial extends Equatable {
  const BillOfMaterial({
    this.id,
    required this.parentMaterialId,
    required this.componentMaterialId,
    required this.quantity,
    required this.unit,
    this.scrapPercentage = 0,
    this.createdAt,
  });

  final String? id;
  final String parentMaterialId;
  final String componentMaterialId;
  final double quantity;
  final String unit;
  final double scrapPercentage;
  final DateTime? createdAt;

  factory BillOfMaterial.fromJson(Map<String, dynamic> json) {
    return BillOfMaterial(
      id: json['id'] as String?,
      parentMaterialId: json['parent_material_id'] as String,
      componentMaterialId: json['component_material_id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      scrapPercentage: (json['scrap_percentage'] as num?)?.toDouble() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent_material_id': parentMaterialId,
      'component_material_id': componentMaterialId,
      'quantity': quantity,
      'unit': unit,
      'scrap_percentage': scrapPercentage,
    };
  }

  BillOfMaterial copyWith({
    String? id,
    String? parentMaterialId,
    String? componentMaterialId,
    double? quantity,
    String? unit,
    double? scrapPercentage,
    DateTime? createdAt,
  }) {
    return BillOfMaterial(
      id: id ?? this.id,
      parentMaterialId: parentMaterialId ?? this.parentMaterialId,
      componentMaterialId: componentMaterialId ?? this.componentMaterialId,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      scrapPercentage: scrapPercentage ?? this.scrapPercentage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        parentMaterialId,
        componentMaterialId,
        quantity,
        unit,
        scrapPercentage,
        createdAt,
      ];
}
