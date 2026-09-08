import 'package:equatable/equatable.dart';

import 'work_center_type.dart';

/// `work_centers` tablosunun Dart karşılığı (Kesimhane, Dikim Bandı,
/// Yıkama Tesisleri, Ütü/Paket).
class WorkCenter extends Equatable {
  const WorkCenter({
    this.id,
    required this.code,
    required this.name,
    required this.workCenterType,
    this.createdAt,
  });

  final String? id;
  final String code;
  final String name;
  final WorkCenterType workCenterType;
  final DateTime? createdAt;

  factory WorkCenter.fromJson(Map<String, dynamic> json) {
    return WorkCenter(
      id: json['id'] as String?,
      code: json['code'] as String,
      name: json['name'] as String,
      workCenterType: WorkCenterType.fromValue(
        json['work_center_type'] as String,
      ),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'work_center_type': workCenterType.value,
    };
  }

  WorkCenter copyWith({
    String? id,
    String? code,
    String? name,
    WorkCenterType? workCenterType,
    DateTime? createdAt,
  }) {
    return WorkCenter(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      workCenterType: workCenterType ?? this.workCenterType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, code, name, workCenterType, createdAt];
}
