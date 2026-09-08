import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/supabase_repository.dart';
import '../../../core/network/supabase_client.dart';
import '../domain/material_movement.dart';
import '../domain/movement_type.dart';

class MaterialMovementRepository extends SupabaseRepository<MaterialMovement> {
  MaterialMovementRepository(SupabaseClient client)
      : super(client, 'material_movements');

  @override
  MaterialMovement fromJson(Map<String, dynamic> json) =>
      MaterialMovement.fromJson(json);

  @override
  Map<String, dynamic> toJson(MaterialMovement entity) => entity.toJson();

  Future<List<MaterialMovement>> getByProductionOrderId(
    String productionOrderId,
  ) async {
    final rows = await client
        .from(table)
        .select()
        .eq('production_order_id', productionOrderId)
        .order('movement_date');
    return rows.map(fromJson).toList();
  }

  /// 261 - Malzeme Çıkışı kaydı oluşturur.
  Future<MaterialMovement> postGoodsIssue({
    required String materialId,
    required String productionOrderId,
    required double quantity,
    required String unit,
    String? createdBy,
  }) {
    return insert(MaterialMovement(
      movementType: MovementType.goodsIssue261,
      materialId: materialId,
      productionOrderId: productionOrderId,
      quantity: quantity,
      unit: unit,
      createdBy: createdBy,
    ));
  }

  /// 101 - Mamul Girişi kaydı oluşturur.
  Future<MaterialMovement> postGoodsReceipt({
    required String materialId,
    required String productionOrderId,
    required double quantity,
    required String unit,
    String? createdBy,
  }) {
    return insert(MaterialMovement(
      movementType: MovementType.goodsReceipt101,
      materialId: materialId,
      productionOrderId: productionOrderId,
      quantity: quantity,
      unit: unit,
      createdBy: createdBy,
    ));
  }
}

final materialMovementRepositoryProvider =
    Provider<MaterialMovementRepository>((ref) {
  return MaterialMovementRepository(ref.watch(supabaseClientProvider));
});
