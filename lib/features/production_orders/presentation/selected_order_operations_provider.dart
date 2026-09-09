import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../production_confirmations/data/production_confirmation_repository.dart';
import '../../production_confirmations/domain/production_confirmation.dart';
import '../../routings/data/routing_repository.dart';
import '../../routings/domain/routing.dart';
import 'production_orders_provider.dart';

/// Seçili üretim siparişinin malzemesine ait iş planı (10-Kesim, 20-Dikim...)
/// - Operasyon Teyidi diyaloğundaki adım seçimi için kullanılır.
final selectedOrderRoutingsProvider = FutureProvider<List<Routing>>((
  ref,
) async {
  final order = await ref.watch(selectedProductionOrderProvider.future);
  if (order == null) return const [];
  return ref.watch(routingRepositoryProvider).getByMaterialId(order.materialId);
});

/// Seçili siparişe girilmiş operasyon teyitleri (operasyon sırasına göre).
final selectedOrderConfirmationsProvider =
    FutureProvider<List<ProductionConfirmation>>((ref) async {
  final order = await ref.watch(selectedProductionOrderProvider.future);
  if (order == null) return const [];
  return ref
      .watch(productionConfirmationRepositoryProvider)
      .getByProductionOrderId(order.id!);
});
