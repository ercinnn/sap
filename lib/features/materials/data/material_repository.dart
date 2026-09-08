import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/supabase_repository.dart';
import '../../../core/network/supabase_client.dart';
import '../domain/material.dart';

class MaterialRepository extends SupabaseRepository<Material> {
  MaterialRepository(SupabaseClient client) : super(client, 'materials');

  @override
  Material fromJson(Map<String, dynamic> json) => Material.fromJson(json);

  @override
  Map<String, dynamic> toJson(Material entity) => entity.toJson();

  Future<Material?> getByMaterialNumber(String materialNumber) async {
    final row = await client
        .from(table)
        .select()
        .eq('material_number', materialNumber)
        .maybeSingle();
    return row == null ? null : fromJson(row);
  }
}

final materialRepositoryProvider = Provider<MaterialRepository>((ref) {
  return MaterialRepository(ref.watch(supabaseClientProvider));
});
