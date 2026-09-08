import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bill_of_materials/data/bill_of_material_repository.dart';
import '../../bill_of_materials/domain/bill_of_material.dart';
import '../domain/production_order.dart';
import 'production_orders_provider.dart';
import 'selected_production_order_provider.dart';

/// Üst tabloda seçilen üretim siparişinin malzemesine göre filtrelenen,
/// Hazıredim ekranının alt tablosu (BOM ihtiyaçları: kumaş, düğme, rivet,
/// koli, poşet...). `selectedProductionOrderIdProvider` değiştiğinde
/// otomatik olarak yeniden hesaplanır.
final materialRequirementsProvider =
    FutureProvider<List<BillOfMaterial>>((ref) async {
  final selectedId = ref.watch(selectedProductionOrderIdProvider);
  if (selectedId == null) return const [];

  final orders = await ref.watch(productionOrdersProvider.future);

  ProductionOrder? selectedOrder;
  for (final order in orders) {
    if (order.id == selectedId) {
      selectedOrder = order;
      break;
    }
  }
  if (selectedOrder == null) return const [];

  return ref
      .watch(billOfMaterialRepositoryProvider)
      .getByParentMaterialId(selectedOrder.materialId);
});
