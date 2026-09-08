import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/supabase_repository.dart';
import '../../../core/network/supabase_client.dart';
import '../domain/bill_of_material.dart';

class BillOfMaterialRepository extends SupabaseRepository<BillOfMaterial> {
  BillOfMaterialRepository(SupabaseClient client)
      : super(client, 'bill_of_materials');

  @override
  BillOfMaterial fromJson(Map<String, dynamic> json) =>
      BillOfMaterial.fromJson(json);

  @override
  Map<String, dynamic> toJson(BillOfMaterial entity) => entity.toJson();

  /// Bir üretim/mamul malzemesinin ihtiyaç duyduğu tüm bileşenler
  /// (Hazıredim ekranındaki alt tablo).
  Future<List<BillOfMaterial>> getByParentMaterialId(
    String parentMaterialId,
  ) async {
    final rows = await client
        .from(table)
        .select()
        .eq('parent_material_id', parentMaterialId);
    return rows.map(fromJson).toList();
  }
}

final billOfMaterialRepositoryProvider =
    Provider<BillOfMaterialRepository>((ref) {
  return BillOfMaterialRepository(ref.watch(supabaseClientProvider));
});
