import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/material_repository.dart';
import '../domain/material.dart';

/// Tüm malzemelerin id -> Material haritası. Diğer ekranların (Hazıredim
/// master-detail vb.) sadece material_id tutup açıklamayı burada aramasını
/// sağlar.
final materialsMapProvider = FutureProvider<Map<String, Material>>((
  ref,
) async {
  final materials = await ref.watch(materialRepositoryProvider).getAll();
  return {
    for (final material in materials)
      if (material.id != null) material.id!: material,
  };
});
