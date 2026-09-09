import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/supabase_repository.dart';
import '../../../core/network/supabase_client.dart';
import '../domain/production_confirmation.dart';

class ProductionConfirmationRepository
    extends SupabaseRepository<ProductionConfirmation> {
  ProductionConfirmationRepository(SupabaseClient client)
      : super(client, 'production_confirmations');

  @override
  ProductionConfirmation fromJson(Map<String, dynamic> json) =>
      ProductionConfirmation.fromJson(json);

  @override
  Map<String, dynamic> toJson(ProductionConfirmation entity) =>
      entity.toJson();

  Future<List<ProductionConfirmation>> getByProductionOrderId(
    String productionOrderId,
  ) async {
    final rows = await client
        .from(table)
        .select()
        .eq('production_order_id', productionOrderId)
        .order('operation_sequence', ascending: true);
    return rows.map(fromJson).toList();
  }
}

final productionConfirmationRepositoryProvider =
    Provider<ProductionConfirmationRepository>((ref) {
  return ProductionConfirmationRepository(ref.watch(supabaseClientProvider));
});
