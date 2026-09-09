import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../core/theme/theme_providers.dart';
import '../../../core/theme/ui_mode.dart';
import '../../materials/presentation/materials_map_provider.dart';
import '../../work_centers/presentation/work_centers_map_provider.dart';
import 'material_requirements_provider.dart';
import 'production_actions.dart';
import 'production_order_rows_provider.dart';
import 'production_orders_provider.dart';
import 'selected_order_operations_provider.dart';
import 'selected_production_order_provider.dart';

/// FAZ 4: Hazıredim ekranı. Üst tablo (Üretim/Proses Siparişleri) ve seçili
/// siparişe göre filtrelenen alt tablo (BOM malzeme ihtiyaçları) - Classic
/// SAP GUI ve Modern ERP modlarında farklı PlutoGrid stilleriyle render
/// edilir.
class ProductionReadinessScreen extends ConsumerStatefulWidget {
  const ProductionReadinessScreen({super.key});

  @override
  ConsumerState<ProductionReadinessScreen> createState() =>
      _ProductionReadinessScreenState();
}

class _ProductionReadinessScreenState
    extends ConsumerState<ProductionReadinessScreen> {
  PlutoGridStateManager? _masterManager;
  PlutoGridStateManager? _detailManager;

  static final _dateFormat = DateFormat('dd.MM.yyyy');

  void _syncRows(PlutoGridStateManager? manager, List<PlutoRow> rows) {
    if (manager == null) return;
    manager.removeAllRows(notify: false);
    manager.appendRows(rows);
  }

  List<PlutoRow> _masterRows(List<ProductionOrderRow> orders) {
    return orders
        .map(
          (o) => PlutoRow(
            cells: {
              'id': PlutoCell(value: o.id),
              'order_number': PlutoCell(value: o.orderNumber),
              'material': PlutoCell(value: o.materialDescription),
              'order_quantity': PlutoCell(value: o.orderQuantity),
              'status': PlutoCell(value: o.status.label),
              'planned_start_date': PlutoCell(
                value: o.plannedStartDate == null
                    ? ''
                    : _dateFormat.format(o.plannedStartDate!),
              ),
              'planned_end_date': PlutoCell(
                value: o.plannedEndDate == null
                    ? ''
                    : _dateFormat.format(o.plannedEndDate!),
              ),
            },
          ),
        )
        .toList();
  }

  List<PlutoRow> _detailRows(List<MaterialRequirementRow> rows) {
    return rows
        .map(
          (r) => PlutoRow(
            cells: {
              'component_number': PlutoCell(value: r.componentMaterialNumber),
              'component_description': PlutoCell(
                value: r.componentDescription,
              ),
              'required_quantity': PlutoCell(value: r.requiredQuantity),
              'unit': PlutoCell(value: r.unit),
              'issued_quantity': PlutoCell(value: r.issuedQuantity),
              'status': PlutoCell(
                value: r.isFullyIssued ? 'Çıkışı Yapıldı' : 'Bekliyor',
              ),
              'component_id': PlutoCell(value: r.componentMaterialId),
            },
          ),
        )
        .toList();
  }

  List<PlutoColumn> _masterColumns(UiMode uiMode) {
    return [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        hide: true,
      ),
      PlutoColumn(
        title: 'Sipariş No',
        field: 'order_number',
        type: PlutoColumnType.text(),
        width: 160,
      ),
      PlutoColumn(
        title: 'Malzeme',
        field: 'material',
        type: PlutoColumnType.text(),
        width: 260,
      ),
      PlutoColumn(
        title: 'Miktar',
        field: 'order_quantity',
        type: PlutoColumnType.number(format: '#,##0.##'),
        width: 100,
        textAlign: PlutoColumnTextAlign.end,
      ),
      PlutoColumn(
        title: 'Durum',
        field: 'status',
        type: PlutoColumnType.text(),
        width: 150,
        renderer: uiMode == UiMode.classic
            ? null
            : (context) => _StatusBadge(text: context.cell.value as String),
      ),
      PlutoColumn(
        title: 'Planlı Başlangıç',
        field: 'planned_start_date',
        type: PlutoColumnType.text(),
        width: 130,
      ),
      PlutoColumn(
        title: 'Planlı Bitiş',
        field: 'planned_end_date',
        type: PlutoColumnType.text(),
        width: 130,
      ),
    ];
  }

  List<PlutoColumn> _detailColumns(UiMode uiMode) {
    return [
      PlutoColumn(
        title: 'Malzeme No',
        field: 'component_number',
        type: PlutoColumnType.text(),
        width: 150,
      ),
      PlutoColumn(
        title: 'Açıklama',
        field: 'component_description',
        type: PlutoColumnType.text(),
        width: 260,
      ),
      PlutoColumn(
        title: 'Gerekli Miktar',
        field: 'required_quantity',
        type: PlutoColumnType.number(format: '#,##0.###'),
        width: 130,
        textAlign: PlutoColumnTextAlign.end,
      ),
      PlutoColumn(
        title: 'Birim',
        field: 'unit',
        type: PlutoColumnType.text(),
        width: 80,
      ),
      PlutoColumn(
        title: 'Çıkışı Yapılan',
        field: 'issued_quantity',
        type: PlutoColumnType.number(format: '#,##0.###'),
        width: 130,
        textAlign: PlutoColumnTextAlign.end,
      ),
      PlutoColumn(
        title: 'Durum',
        field: 'status',
        type: PlutoColumnType.text(),
        width: 150,
        renderer: uiMode == UiMode.classic
            ? null
            : (context) => _StatusBadge(text: context.cell.value as String),
      ),
      PlutoColumn(
        title: 'İşlem',
        field: 'component_id',
        type: PlutoColumnType.text(),
        width: 120,
        enableSorting: false,
        enableContextMenu: false,
        enableFilterMenuItem: false,
        enableEditingMode: false,
        renderer: (rendererContext) {
          final componentId = rendererContext.cell.value as String;
          return TextButton(
            onPressed: () {
              final rows =
                  ref.read(materialRequirementRowsProvider).value ??
                  const <MaterialRequirementRow>[];
              MaterialRequirementRow? row;
              for (final r in rows) {
                if (r.componentMaterialId == componentId) {
                  row = r;
                  break;
                }
              }
              final orderId = ref.read(selectedProductionOrderIdProvider);
              if (row == null || orderId == null) return;
              showGoodsIssueDialog(
                context: context,
                ref: ref,
                productionOrderId: orderId,
                row: row,
              );
            },
            child: const Text('261 Çıkış'),
          );
        },
      ),
    ];
  }

  PlutoGridConfiguration _gridConfiguration(UiMode uiMode) {
    if (uiMode == UiMode.classic) {
      return const PlutoGridConfiguration(
        style: PlutoGridStyleConfig(
          gridBackgroundColor: Colors.white,
          rowColor: Colors.white,
          oddRowColor: Color(0xFFF3F1E7),
          activatedColor: Color(0xFFB9D7FF),
          gridBorderColor: Color(0xFF919B9C),
          borderColor: Color(0xFFCFCABB),
          iconColor: Colors.black54,
          rowHeight: 26,
          columnHeight: 28,
          gridBorderRadius: BorderRadius.zero,
          columnTextStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          cellTextStyle: TextStyle(fontSize: 12, color: Colors.black),
        ),
      );
    }
    return PlutoGridConfiguration(
      style: PlutoGridStyleConfig(
        gridBackgroundColor: Colors.white,
        rowColor: Colors.white,
        evenRowColor: const Color(0xFFF7F8FC),
        activatedColor: const Color(0xFFE3E9FF),
        gridBorderColor: const Color(0xFFE3E5EA),
        borderColor: const Color(0xFFEEF0F4),
        iconColor: Colors.black45,
        rowHeight: 44,
        columnHeight: 44,
        gridBorderRadius: BorderRadius.circular(16),
        columnTextStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1F2430),
        ),
        cellTextStyle: GoogleFonts.inter(fontSize: 13),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uiMode = ref.watch(uiModeProvider);
    final masterAsync = ref.watch(productionOrderRowsProvider);
    final detailAsync = ref.watch(materialRequirementRowsProvider);
    final selectedOrderAsync = ref.watch(selectedProductionOrderProvider);
    final materialsMap = ref.watch(materialsMapProvider).value ?? const {};
    final workCentersMap = ref.watch(workCentersMapProvider).value ?? const {};
    final routingsAsync = ref.watch(selectedOrderRoutingsProvider);
    final confirmationsAsync = ref.watch(selectedOrderConfirmationsProvider);

    ref.listen(productionOrderRowsProvider, (previous, next) {
      next.whenData((orders) => _syncRows(_masterManager, _masterRows(orders)));
    });
    ref.listen(materialRequirementRowsProvider, (previous, next) {
      next.whenData((rows) => _syncRows(_detailManager, _detailRows(rows)));
    });

    final masterGrid = masterAsync.when(
      data: (orders) => PlutoGrid(
        columns: _masterColumns(uiMode),
        rows: _masterRows(orders),
        mode: PlutoGridMode.selectWithOneTap,
        configuration: _gridConfiguration(uiMode),
        onLoaded: (event) => _masterManager = event.stateManager,
        onSelected: (event) {
          final id = event.row?.cells['id']?.value as String?;
          ref.read(selectedProductionOrderIdProvider.notifier).select(id);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: SelectableText('Hata: $error')),
    );

    final detailTitle = selectedOrderAsync.maybeWhen(
      data: (order) => order == null
          ? 'Malzeme İhtiyacı (bir sipariş seçin)'
          : 'Malzeme İhtiyacı — ${order.orderNumber}',
      orElse: () => 'Malzeme İhtiyacı',
    );

    final detailGrid = detailAsync.when(
      data: (rows) => PlutoGrid(
        columns: _detailColumns(uiMode),
        rows: _detailRows(rows),
        configuration: _gridConfiguration(uiMode),
        onLoaded: (event) => _detailManager = event.stateManager,
        noRowsWidget: const Center(
          child: Text('Üstten bir üretim siparişi seçin.'),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: SelectableText('Hata: $error')),
    );

    final selectedOrder = selectedOrderAsync.value;
    final actionsBar = selectedOrder == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.move_to_inbox_outlined, size: 18),
                  label: const Text('101 — Mamul Girişi'),
                  onPressed: () {
                    final material = materialsMap[selectedOrder.materialId];
                    showGoodsReceiptDialog(
                      context: context,
                      ref: ref,
                      productionOrderId: selectedOrder.id!,
                      materialId: selectedOrder.materialId,
                      materialDescription:
                          material?.description ?? selectedOrder.materialId,
                      orderQuantity: selectedOrder.orderQuantity,
                      unit: material?.baseUnit ?? 'PC',
                    );
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.fact_check_outlined, size: 18),
                  label: const Text('Operasyon Teyidi Ekle'),
                  onPressed: () {
                    showOperationConfirmationDialog(
                      context: context,
                      ref: ref,
                      productionOrderId: selectedOrder.id!,
                      routings: routingsAsync.value ?? const [],
                      workCenters: workCentersMap,
                    );
                  },
                ),
              ],
            ),
          );

    final confirmationsPanel = confirmationsAsync.maybeWhen(
      data: (confirmations) => confirmations.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Operasyon Teyitleri',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  ...confirmations.map(
                    (c) => Text(
                      'OP${c.operationSequence}: '
                      '${c.confirmedQuantity.toStringAsFixed(0)} adet, '
                      '${c.scrapQuantity.toStringAsFixed(0)} fire'
                      '${c.confirmedBy != null ? ' — ${c.confirmedBy}' : ''}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
      orElse: () => const SizedBox.shrink(),
    );

    final detailFooter = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [actionsBar, confirmationsPanel],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hazıredim — Malzeme İhtiyaç Kontrolü'),
        actions: [
          IconButton(
            tooltip: 'Ayarlar / Bağlantı Testi',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: uiMode == UiMode.classic
          ? _ClassicLayout(
              masterGrid: masterGrid,
              detailTitle: detailTitle,
              detailGrid: detailGrid,
              detailFooter: detailFooter,
            )
          : _ModernLayout(
              masterGrid: masterGrid,
              detailTitle: detailTitle,
              detailGrid: detailGrid,
              detailFooter: detailFooter,
            ),
    );
  }
}

class _ClassicLayout extends StatelessWidget {
  const _ClassicLayout({
    required this.masterGrid,
    required this.detailTitle,
    required this.detailGrid,
    required this.detailFooter,
  });

  final Widget masterGrid;
  final String detailTitle;
  final Widget detailGrid;
  final Widget detailFooter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionLabel(text: 'Üretim / Proses Siparişleri', classic: true),
        Expanded(flex: 3, child: masterGrid),
        const Divider(height: 1, color: Color(0xFF919B9C)),
        _SectionLabel(text: detailTitle, classic: true),
        Expanded(flex: 2, child: detailGrid),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: detailFooter,
        ),
      ],
    );
  }
}

class _ModernLayout extends StatelessWidget {
  const _ModernLayout({
    required this.masterGrid,
    required this.detailTitle,
    required this.detailGrid,
    required this.detailFooter,
  });

  final Widget masterGrid;
  final String detailTitle;
  final Widget detailGrid;
  final Widget detailFooter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionLabel(text: 'Üretim / Proses Siparişleri', classic: false),
          const SizedBox(height: 8),
          Expanded(
            flex: 3,
            child: Card(child: Padding(padding: const EdgeInsets.all(8), child: masterGrid)),
          ),
          const SizedBox(height: 20),
          _SectionLabel(text: detailTitle, classic: false),
          const SizedBox(height: 8),
          Expanded(
            flex: 2,
            child: Card(child: Padding(padding: const EdgeInsets.all(8), child: detailGrid)),
          ),
          detailFooter,
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text, required this.classic});

  final String text;
  final bool classic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: classic ? 8 : 0, vertical: classic ? 4 : 0),
      child: Text(
        text,
        style: classic
            ? const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
            : Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text});

  final String text;

  Color _colorFor(String text) {
    switch (text) {
      case 'Serbest Bırakıldı':
      case 'Çıkışı Yapıldı':
        return const Color(0xFF2E7D32);
      case 'İşlemde':
        return const Color(0xFFB26A00);
      case 'Tamamlandı':
      case 'Kapatıldı':
        return const Color(0xFF37474F);
      default:
        return const Color(0xFF757575);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(text);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          text,
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
