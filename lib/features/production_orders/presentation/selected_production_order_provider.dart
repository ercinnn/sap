import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Hazıredim ekranının üst tablosunda seçili olan üretim siparişinin id'si.
/// Alt tablo (malzeme ihtiyaçları) bu id değiştiğinde otomatik yeniden
/// filtrelenir (bkz. material_requirements_provider.dart).
class SelectedProductionOrderIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;
}

final selectedProductionOrderIdProvider =
    NotifierProvider<SelectedProductionOrderIdNotifier, String?>(
  SelectedProductionOrderIdNotifier.new,
);
