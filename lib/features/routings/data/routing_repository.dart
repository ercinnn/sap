import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/supabase_repository.dart';
import '../../../core/network/supabase_client.dart';
import '../domain/routing.dart';

class RoutingRepository extends SupabaseRepository<Routing> {
  RoutingRepository(SupabaseClient client) : super(client, 'routings');

  @override
  Routing fromJson(Map<String, dynamic> json) => Routing.fromJson(json);

  @override
  Map<String, dynamic> toJson(Routing entity) => entity.toJson();

  /// Bir malzemenin operasyon sırasına göre sıralanmış iş planı
  /// (10-Kesim -> 20-Dikim -> 30-Yıkama -> 40-Kalite/Paket).
  Future<List<Routing>> getByMaterialId(String materialId) async {
    final rows = await client
        .from(table)
        .select()
        .eq('material_id', materialId)
        .order('operation_sequence');
    return rows.map(fromJson).toList();
  }
}

final routingRepositoryProvider = Provider<RoutingRepository>((ref) {
  return RoutingRepository(ref.watch(supabaseClientProvider));
});
