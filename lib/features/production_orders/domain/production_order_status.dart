/// `production_orders.status` sütununun izin verilen değerleri.
enum ProductionOrderStatus {
  created,
  released,
  inProcess,
  completed,
  closed;

  String get value {
    switch (this) {
      case ProductionOrderStatus.created:
        return 'created';
      case ProductionOrderStatus.released:
        return 'released';
      case ProductionOrderStatus.inProcess:
        return 'in_process';
      case ProductionOrderStatus.completed:
        return 'completed';
      case ProductionOrderStatus.closed:
        return 'closed';
    }
  }

  static ProductionOrderStatus fromValue(String value) {
    return ProductionOrderStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Bilinmeyen status: $value'),
    );
  }
}
