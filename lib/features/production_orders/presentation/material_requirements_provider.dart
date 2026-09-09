import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bill_of_materials/data/bill_of_material_repository.dart';
import '../../bill_of_materials/domain/bill_of_material.dart';
import '../../materials/presentation/materials_map_provider.dart';
import '../../material_movements/data/material_movement_repository.dart';
import '../../material_movements/domain/movement_type.dart';
import 'production_orders_provider.dart';

/// Üst tabloda seçilen üretim siparişinin malzemesine göre filtrelenen ham
/// BOM satırları (Hazıredim ekranının alt tablosunun veri kaynağı).
final materialRequirementsProvider =
    FutureProvider<List<BillOfMaterial>>((ref) async {
  final order = await ref.watch(selectedProductionOrderProvider.future);
  if (order == null) return const [];

  return ref
      .watch(billOfMaterialRepositoryProvider)
      .getByParentMaterialId(order.materialId);
});

/// Hazıredim ekranının alt tablosunda gösterilen, malzeme açıklaması ve
/// sipariş miktarına göre hesaplanmış ihtiyaç/çıkış durumu ile
/// zenginleştirilmiş satır.
class MaterialRequirementRow {
  const MaterialRequirementRow({
    required this.componentMaterialId,
    required this.componentMaterialNumber,
    required this.componentDescription,
    required this.unit,
    required this.requiredQuantity,
    required this.issuedQuantity,
  });

  final String componentMaterialId;
  final String componentMaterialNumber;
  final String componentDescription;
  final String unit;
  final double requiredQuantity;
  final double issuedQuantity;

  bool get isFullyIssued =>
      requiredQuantity > 0 && issuedQuantity >= requiredQuantity;
}

final materialRequirementRowsProvider =
    FutureProvider<List<MaterialRequirementRow>>((ref) async {
  final order = await ref.watch(selectedProductionOrderProvider.future);
  if (order == null) return const [];

  final bomLines = await ref.watch(materialRequirementsProvider.future);
  if (bomLines.isEmpty) return const [];

  final materials = await ref.watch(materialsMapProvider.future);
  final movements = await ref
      .watch(materialMovementRepositoryProvider)
      .getByProductionOrderId(order.id!);

  final issuedByComponent = <String, double>{};
  for (final movement in movements) {
    if (movement.movementType == MovementType.goodsIssue261) {
      issuedByComponent[movement.materialId] =
          (issuedByComponent[movement.materialId] ?? 0) + movement.quantity;
    }
  }

  return bomLines.map((bom) {
    final component = materials[bom.componentMaterialId];
    final required =
        order.orderQuantity * bom.quantity * (1 + bom.scrapPercentage / 100);
    return MaterialRequirementRow(
      componentMaterialId: bom.componentMaterialId,
      componentMaterialNumber:
          component?.materialNumber ?? bom.componentMaterialId,
      componentDescription: component?.description ?? '-',
      unit: bom.unit,
      requiredQuantity: required,
      issuedQuantity: issuedByComponent[bom.componentMaterialId] ?? 0,
    );
  }).toList();
});
