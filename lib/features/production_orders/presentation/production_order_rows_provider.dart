import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../materials/presentation/materials_map_provider.dart';
import '../domain/production_order_status.dart';
import 'production_orders_provider.dart';

/// Hazıredim ekranının üst tablosunda gösterilen, malzeme açıklaması ile
/// zenginleştirilmiş satır (ProductionOrder + Material.description).
class ProductionOrderRow {
  const ProductionOrderRow({
    required this.id,
    required this.orderNumber,
    required this.materialDescription,
    required this.orderQuantity,
    required this.status,
    this.plannedStartDate,
    this.plannedEndDate,
  });

  final String id;
  final String orderNumber;
  final String materialDescription;
  final double orderQuantity;
  final ProductionOrderStatus status;
  final DateTime? plannedStartDate;
  final DateTime? plannedEndDate;
}

final productionOrderRowsProvider = FutureProvider<List<ProductionOrderRow>>((
  ref,
) async {
  final orders = await ref.watch(productionOrdersProvider.future);
  final materials = await ref.watch(materialsMapProvider.future);

  return orders
      .where((order) => order.id != null)
      .map(
        (order) => ProductionOrderRow(
          id: order.id!,
          orderNumber: order.orderNumber,
          materialDescription:
              materials[order.materialId]?.description ?? order.materialId,
          orderQuantity: order.orderQuantity,
          status: order.status,
          plannedStartDate: order.plannedStartDate,
          plannedEndDate: order.plannedEndDate,
        ),
      )
      .toList();
});
