import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/work_center_repository.dart';
import '../domain/work_center.dart';

/// Tüm iş yerlerinin id -> WorkCenter haritası. Routing/operasyon
/// ekranlarının work_center_id tutup adını burada aramasını sağlar.
final workCentersMapProvider = FutureProvider<Map<String, WorkCenter>>((
  ref,
) async {
  final workCenters = await ref.watch(workCenterRepositoryProvider).getAll();
  return {
    for (final workCenter in workCenters)
      if (workCenter.id != null) workCenter.id!: workCenter,
  };
});
