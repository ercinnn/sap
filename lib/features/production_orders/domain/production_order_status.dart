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

  /// Ekranlarda gösterilen Türkçe etiket.
  String get label {
    switch (this) {
      case ProductionOrderStatus.created:
        return 'Oluşturuldu';
      case ProductionOrderStatus.released:
        return 'Serbest Bırakıldı';
      case ProductionOrderStatus.inProcess:
        return 'İşlemde';
      case ProductionOrderStatus.completed:
        return 'Tamamlandı';
      case ProductionOrderStatus.closed:
        return 'Kapatıldı';
    }
  }
}
