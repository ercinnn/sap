import 'package:flutter_test/flutter_test.dart';

import 'package:sap/features/bill_of_materials/domain/bill_of_material.dart';
import 'package:sap/features/material_movements/domain/material_movement.dart';
import 'package:sap/features/material_movements/domain/movement_type.dart';
import 'package:sap/features/materials/domain/material.dart';
import 'package:sap/features/materials/domain/material_type.dart';
import 'package:sap/features/production_confirmations/domain/production_confirmation.dart';
import 'package:sap/features/production_orders/domain/production_order.dart';
import 'package:sap/features/production_orders/domain/production_order_status.dart';
import 'package:sap/features/routings/domain/routing.dart';
import 'package:sap/features/work_centers/domain/work_center.dart';
import 'package:sap/features/work_centers/domain/work_center_type.dart';

void main() {
  test('Material toJson/fromJson round-trip preserves data', () {
    const material = Material(
      materialNumber: 'FAB-001',
      description: 'Denim Kumaş 12oz',
      materialType: MaterialType.fabric,
      baseUnit: 'MT',
    );
    final restored = Material.fromJson({
      'id': 'test-id',
      ...material.toJson(),
      'created_at': null,
    });
    expect(restored.materialNumber, material.materialNumber);
    expect(restored.materialType, MaterialType.fabric);
  });

  test('BillOfMaterial round-trip preserves quantity and scrap', () {
    const bom = BillOfMaterial(
      parentMaterialId: 'parent-id',
      componentMaterialId: 'component-id',
      quantity: 1.5,
      unit: 'MT',
      scrapPercentage: 3.5,
    );
    final restored = BillOfMaterial.fromJson({'id': 'bom-id', ...bom.toJson()});
    expect(restored.quantity, 1.5);
    expect(restored.scrapPercentage, 3.5);
  });

  test('WorkCenter round-trip preserves work_center_type', () {
    const workCenter = WorkCenter(
      code: 'WC-10',
      name: 'Kesimhane',
      workCenterType: WorkCenterType.cutting,
    );
    final restored = WorkCenter.fromJson({'id': 'wc-id', ...workCenter.toJson()});
    expect(restored.workCenterType, WorkCenterType.cutting);
  });

  test('Routing round-trip preserves operation_sequence', () {
    const routing = Routing(
      materialId: 'mat-id',
      operationSequence: 20,
      workCenterId: 'wc-id',
      operationDescription: 'Dikim',
      standardTimeMinutes: 12.5,
    );
    final restored = Routing.fromJson({'id': 'r-id', ...routing.toJson()});
    expect(restored.operationSequence, 20);
    expect(restored.standardTimeMinutes, 12.5);
  });

  test('ProductionOrder round-trip preserves status', () {
    const order = ProductionOrder(
      orderNumber: 'PO-1001',
      materialId: 'mat-id',
      orderQuantity: 500,
      status: ProductionOrderStatus.released,
    );
    final restored = ProductionOrder.fromJson({'id': 'po-id', ...order.toJson()});
    expect(restored.status, ProductionOrderStatus.released);
    expect(restored.orderQuantity, 500);
  });

  test('ProductionConfirmation round-trip preserves scrap_quantity', () {
    const confirmation = ProductionConfirmation(
      productionOrderId: 'po-id',
      operationSequence: 30,
      confirmedQuantity: 480,
      scrapQuantity: 20,
    );
    final restored = ProductionConfirmation.fromJson({
      'id': 'pc-id',
      ...confirmation.toJson(),
      'confirmed_at': null,
    });
    expect(restored.confirmedQuantity, 480);
    expect(restored.scrapQuantity, 20);
  });

  test('MaterialMovement round-trip preserves movement_type (261/101)', () {
    const movement = MaterialMovement(
      movementType: MovementType.goodsIssue261,
      materialId: 'mat-id',
      productionOrderId: 'po-id',
      quantity: 100,
      unit: 'PC',
    );
    final restored = MaterialMovement.fromJson({
      'id': 'mm-id',
      ...movement.toJson(),
      'movement_date': null,
    });
    expect(restored.movementType, MovementType.goodsIssue261);
    expect(restored.movementType.value, '261');
  });
}
