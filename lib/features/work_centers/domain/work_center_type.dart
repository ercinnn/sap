/// `work_centers.work_center_type` sütununun izin verilen değerleri.
enum WorkCenterType {
  cutting,
  sewing,
  washing,
  ironingPacking;

  String get value {
    switch (this) {
      case WorkCenterType.cutting:
        return 'cutting';
      case WorkCenterType.sewing:
        return 'sewing';
      case WorkCenterType.washing:
        return 'washing';
      case WorkCenterType.ironingPacking:
        return 'ironing_packing';
    }
  }

  static WorkCenterType fromValue(String value) {
    return WorkCenterType.values.firstWhere(
      (e) => e.value == value,
      orElse: () =>
          throw ArgumentError('Bilinmeyen work_center_type: $value'),
    );
  }
}
