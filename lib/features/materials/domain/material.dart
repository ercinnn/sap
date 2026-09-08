import 'package:equatable/equatable.dart';

import 'material_type.dart';

/// `materials` tablosunun Dart karşılığı.
class Material extends Equatable {
  const Material({
    this.id,
    required this.materialNumber,
    required this.description,
    required this.materialType,
    this.baseUnit = 'PC',
    this.createdAt,
  });

  final String? id;
  final String materialNumber;
  final String description;
  final MaterialType materialType;
  final String baseUnit;
  final DateTime? createdAt;

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'] as String?,
      materialNumber: json['material_number'] as String,
      description: json['description'] as String,
      materialType: MaterialType.fromValue(json['material_type'] as String),
      baseUnit: json['base_unit'] as String? ?? 'PC',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'material_number': materialNumber,
      'description': description,
      'material_type': materialType.value,
      'base_unit': baseUnit,
    };
  }

  Material copyWith({
    String? id,
    String? materialNumber,
    String? description,
    MaterialType? materialType,
    String? baseUnit,
    DateTime? createdAt,
  }) {
    return Material(
      id: id ?? this.id,
      materialNumber: materialNumber ?? this.materialNumber,
      description: description ?? this.description,
      materialType: materialType ?? this.materialType,
      baseUnit: baseUnit ?? this.baseUnit,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        materialNumber,
        description,
        materialType,
        baseUnit,
        createdAt,
      ];
}
