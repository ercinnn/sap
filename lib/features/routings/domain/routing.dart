import 'package:equatable/equatable.dart';

/// `routings` tablosunun Dart karşılığı — bir malzemenin operasyon sırasını
/// tanımlar (10-Kesim -> 20-Dikim -> 30-Yıkama -> 40-Kalite/Paket).
class Routing extends Equatable {
  const Routing({
    this.id,
    required this.materialId,
    required this.operationSequence,
    required this.workCenterId,
    required this.operationDescription,
    this.standardTimeMinutes = 0,
    this.createdAt,
  });

  final String? id;
  final String materialId;
  final int operationSequence;
  final String workCenterId;
  final String operationDescription;
  final double standardTimeMinutes;
  final DateTime? createdAt;

  factory Routing.fromJson(Map<String, dynamic> json) {
    return Routing(
      id: json['id'] as String?,
      materialId: json['material_id'] as String,
      operationSequence: json['operation_sequence'] as int,
      workCenterId: json['work_center_id'] as String,
      operationDescription: json['operation_description'] as String,
      standardTimeMinutes:
          (json['standard_time_minutes'] as num?)?.toDouble() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'material_id': materialId,
      'operation_sequence': operationSequence,
      'work_center_id': workCenterId,
      'operation_description': operationDescription,
      'standard_time_minutes': standardTimeMinutes,
    };
  }

  Routing copyWith({
    String? id,
    String? materialId,
    int? operationSequence,
    String? workCenterId,
    String? operationDescription,
    double? standardTimeMinutes,
    DateTime? createdAt,
  }) {
    return Routing(
      id: id ?? this.id,
      materialId: materialId ?? this.materialId,
      operationSequence: operationSequence ?? this.operationSequence,
      workCenterId: workCenterId ?? this.workCenterId,
      operationDescription: operationDescription ?? this.operationDescription,
      standardTimeMinutes: standardTimeMinutes ?? this.standardTimeMinutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        materialId,
        operationSequence,
        workCenterId,
        operationDescription,
        standardTimeMinutes,
        createdAt,
      ];
}
