/// SAP hareket kodları: 261 = Malzeme Çıkışı (Goods Issue),
/// 101 = Mamul Girişi (Goods Receipt).
enum MovementType {
  goodsIssue261,
  goodsReceipt101;

  String get value {
    switch (this) {
      case MovementType.goodsIssue261:
        return '261';
      case MovementType.goodsReceipt101:
        return '101';
    }
  }

  static MovementType fromValue(String value) {
    return MovementType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Bilinmeyen movement_type: $value'),
    );
  }
}
