import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../material_movements/data/material_movement_repository.dart';
import '../../production_confirmations/data/production_confirmation_repository.dart';
import '../../production_confirmations/domain/production_confirmation.dart';
import '../../routings/domain/routing.dart';
import '../../work_centers/domain/work_center.dart';
import 'material_requirements_provider.dart';
import 'selected_order_operations_provider.dart';

/// FAZ 5: 261 (Malzeme Çıkışı), 101 (Mamul Girişi) ve Operasyon Teyidi
/// diyalogları. Her fonksiyon kendi başarı/hata bildirimini SnackBar ile
/// gösterir; ilgili provider'ları başarılı işlemden sonra invalidate eder.

double? _parseQuantity(String? value) {
  if (value == null) return null;
  return double.tryParse(value.trim().replaceAll(',', '.'));
}

/// 261 - Bir BOM bileşeni için malzeme çıkışı diyaloğu.
Future<void> showGoodsIssueDialog({
  required BuildContext context,
  required WidgetRef ref,
  required String productionOrderId,
  required MaterialRequirementRow row,
}) async {
  final remaining = row.requiredQuantity - row.issuedQuantity;
  final defaultQuantity = remaining > 0 ? remaining : row.requiredQuantity;
  final controller = TextEditingController(
    text: defaultQuantity.toStringAsFixed(3),
  );
  final formKey = GlobalKey<FormState>();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      bool isSaving = false;
      return StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text('261 — Malzeme Çıkışı: ${row.componentMaterialNumber}'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.componentDescription),
                const SizedBox(height: 12),
                Text(
                  'Gerekli: ${row.requiredQuantity.toStringAsFixed(3)} ${row.unit}   •   '
                  'Çıkışı Yapılan: ${row.issuedQuantity.toStringAsFixed(3)} ${row.unit}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Çıkış Miktarı (${row.unit})',
                  ),
                  validator: (value) {
                    final parsed = _parseQuantity(value);
                    if (parsed == null || parsed <= 0) {
                      return 'Geçerli bir miktar girin';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving
                  ? null
                  : () => Navigator.of(dialogContext).pop(),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      if (!(formKey.currentState?.validate() ?? false)) {
                        return;
                      }
                      setState(() => isSaving = true);
                      final quantity = _parseQuantity(controller.text)!;
                      try {
                        await ref
                            .read(materialMovementRepositoryProvider)
                            .postGoodsIssue(
                              materialId: row.componentMaterialId,
                              productionOrderId: productionOrderId,
                              quantity: quantity,
                              unit: row.unit,
                            );
                        ref.invalidate(materialRequirementRowsProvider);
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${row.componentMaterialNumber} için ${quantity.toStringAsFixed(3)} ${row.unit} çıkışı yapıldı.',
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        setState(() => isSaving = false);
                        if (dialogContext.mounted) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(content: Text('Hata: $e')),
                          );
                        }
                      }
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Çıkışı Onayla'),
            ),
          ],
        ),
      );
    },
  );
}

/// 101 - Sipariş için tamamlanan mamulün depoya girişi.
Future<void> showGoodsReceiptDialog({
  required BuildContext context,
  required WidgetRef ref,
  required String productionOrderId,
  required String materialId,
  required String materialDescription,
  required double orderQuantity,
  required String unit,
}) async {
  final controller = TextEditingController(
    text: orderQuantity.toStringAsFixed(0),
  );
  final formKey = GlobalKey<FormState>();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      bool isSaving = false;
      return StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('101 — Mamul Girişi'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(materialDescription),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(labelText: 'Giriş Miktarı ($unit)'),
                  validator: (value) {
                    final parsed = _parseQuantity(value);
                    if (parsed == null || parsed <= 0) {
                      return 'Geçerli bir miktar girin';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving
                  ? null
                  : () => Navigator.of(dialogContext).pop(),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      if (!(formKey.currentState?.validate() ?? false)) {
                        return;
                      }
                      setState(() => isSaving = true);
                      final quantity = _parseQuantity(controller.text)!;
                      try {
                        await ref
                            .read(materialMovementRepositoryProvider)
                            .postGoodsReceipt(
                              materialId: materialId,
                              productionOrderId: productionOrderId,
                              quantity: quantity,
                              unit: unit,
                            );
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${quantity.toStringAsFixed(0)} $unit mamul girişi kaydedildi.',
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        setState(() => isSaving = false);
                        if (dialogContext.mounted) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(content: Text('Hata: $e')),
                          );
                        }
                      }
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Girişi Onayla'),
            ),
          ],
        ),
      );
    },
  );
}

/// Operasyon Teyidi - sahadan operasyon bazlı miktar ve fire teyidi.
Future<void> showOperationConfirmationDialog({
  required BuildContext context,
  required WidgetRef ref,
  required String productionOrderId,
  required List<Routing> routings,
  required Map<String, WorkCenter> workCenters,
}) async {
  if (routings.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bu malzeme için tanımlı bir iş planı (routing) yok.'),
      ),
    );
    return;
  }

  Routing selectedRouting = routings.first;
  final confirmedController = TextEditingController();
  final scrapController = TextEditingController(text: '0');
  final confirmedByController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String routingLabel(Routing r) {
    final wc = workCenters[r.workCenterId];
    return '${r.operationSequence} — ${r.operationDescription}${wc != null ? ' (${wc.name})' : ''}';
  }

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      bool isSaving = false;
      return StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Operasyon Teyidi'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<Routing>(
                  initialValue: selectedRouting,
                  decoration: const InputDecoration(labelText: 'Operasyon'),
                  items: routings
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(routingLabel(r)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => selectedRouting = value);
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmedController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Teyit Edilen Miktar'),
                  validator: (value) {
                    final parsed = _parseQuantity(value);
                    if (parsed == null || parsed < 0) {
                      return 'Geçerli bir miktar girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: scrapController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Fire Miktarı'),
                  validator: (value) {
                    final parsed = _parseQuantity(value);
                    if (parsed == null || parsed < 0) {
                      return 'Geçerli bir miktar girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmedByController,
                  decoration: const InputDecoration(
                    labelText: 'Teyit Eden (opsiyonel)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving
                  ? null
                  : () => Navigator.of(dialogContext).pop(),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      if (!(formKey.currentState?.validate() ?? false)) {
                        return;
                      }
                      setState(() => isSaving = true);
                      final confirmedQuantity = _parseQuantity(
                        confirmedController.text,
                      )!;
                      final scrapQuantity = _parseQuantity(
                        scrapController.text,
                      )!;
                      try {
                        await ref
                            .read(productionConfirmationRepositoryProvider)
                            .insert(
                              ProductionConfirmation(
                                productionOrderId: productionOrderId,
                                operationSequence:
                                    selectedRouting.operationSequence,
                                confirmedQuantity: confirmedQuantity,
                                scrapQuantity: scrapQuantity,
                                confirmedBy: confirmedByController.text.trim().isEmpty
                                    ? null
                                    : confirmedByController.text.trim(),
                              ),
                            );
                        ref.invalidate(selectedOrderConfirmationsProvider);
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Operasyon teyidi kaydedildi.')),
                          );
                        }
                      } catch (e) {
                        setState(() => isSaving = false);
                        if (dialogContext.mounted) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(content: Text('Hata: $e')),
                          );
                        }
                      }
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Teyidi Kaydet'),
            ),
          ],
        ),
      );
    },
  );
}
