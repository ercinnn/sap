import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/supabase_repository.dart';
import '../../../core/network/supabase_client.dart';
import '../domain/production_order.dart';
import '../domain/production_order_status.dart';

class ProductionOrderRepository extends SupabaseRepository<ProductionOrder> {
  ProductionOrderRepository(SupabaseClient client)
      : super(client, 'production_orders');

  @override
  ProductionOrder fromJson(Map<String, dynamic> json) =>
      ProductionOrder.fromJson(json);

  @override
  Map<String, dynamic> toJson(ProductionOrder entity) => entity.toJson();

  Future<ProductionOrder> updateStatus(
    String id,
    ProductionOrderStatus status,
  ) async {
    final row = await client
        .from(table)
        .update({'status': status.value})
        .eq('id', id)
        .select()
        .single();
    return fromJson(row);
  }

  /// Hazıredim ekranının üst tablosu için canlı (Realtime) akış.
  Stream<List<ProductionOrder>> watchAll() {
    return client
        .from(table)
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((rows) => rows.map(fromJson).toList());
  }
}

final productionOrderRepositoryProvider =
    Provider<ProductionOrderRepository>((ref) {
  return ProductionOrderRepository(ref.watch(supabaseClientProvider));
});
