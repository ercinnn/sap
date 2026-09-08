import 'package:equatable/equatable.dart';

/// `production_confirmations` tablosunun Dart karşılığı — sahadan operasyon
/// bazlı miktar ve fire teyidi.
class ProductionConfirmation extends Equatable {
  const ProductionConfirmation({
    this.id,
    required this.productionOrderId,
    required this.operationSequence,
    required this.confirmedQuantity,
    this.scrapQuantity = 0,
    this.confirmedAt,
    this.confirmedBy,
  });

  final String? id;
  final String productionOrderId;
  final int operationSequence;
  final double confirmedQuantity;
  final double scrapQuantity;
  final DateTime? confirmedAt;
  final String? confirmedBy;

  factory ProductionConfirmation.fromJson(Map<String, dynamic> json) {
    return ProductionConfirmation(
      id: json['id'] as String?,
      productionOrderId: json['production_order_id'] as String,
      operationSequence: json['operation_sequence'] as int,
      confirmedQuantity: (json['confirmed_quantity'] as num).toDouble(),
      scrapQuantity: (json['scrap_quantity'] as num?)?.toDouble() ?? 0,
      confirmedAt: json['confirmed_at'] == null
          ? null
          : DateTime.parse(json['confirmed_at'] as String),
      confirmedBy: json['confirmed_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'production_order_id': productionOrderId,
      'operation_sequence': operationSequence,
      'confirmed_quantity': confirmedQuantity,
      'scrap_quantity': scrapQuantity,
      'confirmed_by': confirmedBy,
    };
  }

  ProductionConfirmation copyWith({
    String? id,
    String? productionOrderId,
    int? operationSequence,
    double? confirmedQuantity,
    double? scrapQuantity,
    DateTime? confirmedAt,
    String? confirmedBy,
  }) {
    return ProductionConfirmation(
      id: id ?? this.id,
      productionOrderId: productionOrderId ?? this.productionOrderId,
      operationSequence: operationSequence ?? this.operationSequence,
      confirmedQuantity: confirmedQuantity ?? this.confirmedQuantity,
      scrapQuantity: scrapQuantity ?? this.scrapQuantity,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      confirmedBy: confirmedBy ?? this.confirmedBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        productionOrderId,
        operationSequence,
        confirmedQuantity,
        scrapQuantity,
        confirmedAt,
        confirmedBy,
      ];
}
