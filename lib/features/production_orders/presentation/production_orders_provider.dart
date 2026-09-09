import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/production_order_repository.dart';
import '../domain/production_order.dart';
import '../domain/production_order_status.dart';
import 'selected_production_order_provider.dart';

/// Supabase Realtime üzerinden üretim siparişlerindeki canlı saha
/// güncellemelerini (durum değişiklikleri, yeni siparişler...) dinler.
final productionOrdersRealtimeProvider =
    StreamProvider<List<ProductionOrder>>((ref) {
  return ref.watch(productionOrderRepositoryProvider).watchAll();
});

/// Hazıredim ekranının üst tablosu için tek gerçek kaynak. Realtime akışını
/// dinleyip state'i canlı tutar; durum güncelleme gibi yazma işlemleri de
/// buradan yapılır (yazma sonrası state'i Realtime akışı otomatik günceller).
class ProductionOrdersNotifier extends AsyncNotifier<List<ProductionOrder>> {
  @override
  Future<List<ProductionOrder>> build() async {
    ref.listen(productionOrdersRealtimeProvider, (previous, next) {
      next.whenData((orders) => state = AsyncValue.data(orders));
    });
    return ref.read(productionOrderRepositoryProvider).getAll();
  }

  Future<void> updateStatus(String id, ProductionOrderStatus status) async {
    await ref.read(productionOrderRepositoryProvider).updateStatus(id, status);
  }
}

final productionOrdersProvider =
    AsyncNotifierProvider<ProductionOrdersNotifier, List<ProductionOrder>>(
  ProductionOrdersNotifier.new,
);

/// Üst tabloda seçili olan üretim siparişinin (varsa) tam kaydı.
final selectedProductionOrderProvider = FutureProvider<ProductionOrder?>((
  ref,
) async {
  final selectedId = ref.watch(selectedProductionOrderIdProvider);
  if (selectedId == null) return null;

  final orders = await ref.watch(productionOrdersProvider.future);
  for (final order in orders) {
    if (order.id == selectedId) return order;
  }
  return null;
});
