/// `materials.material_type` sütununun izin verilen değerleri
/// (bkz. supabase/schema.sql).
enum MaterialType {
  fabric,
  yarn,
  accessory,
  button,
  rivet,
  washChemical,
  label,
  box,
  finishedGood;

  String get value {
    switch (this) {
      case MaterialType.fabric:
        return 'fabric';
      case MaterialType.yarn:
        return 'yarn';
      case MaterialType.accessory:
        return 'accessory';
      case MaterialType.button:
        return 'button';
      case MaterialType.rivet:
        return 'rivet';
      case MaterialType.washChemical:
        return 'wash_chemical';
      case MaterialType.label:
        return 'label';
      case MaterialType.box:
        return 'box';
      case MaterialType.finishedGood:
        return 'finished_good';
    }
  }

  static MaterialType fromValue(String value) {
    return MaterialType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Bilinmeyen material_type: $value'),
    );
  }
}
