import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/supabase_repository.dart';
import '../../../core/network/supabase_client.dart';
import '../domain/work_center.dart';

class WorkCenterRepository extends SupabaseRepository<WorkCenter> {
  WorkCenterRepository(SupabaseClient client) : super(client, 'work_centers');

  @override
  WorkCenter fromJson(Map<String, dynamic> json) => WorkCenter.fromJson(json);

  @override
  Map<String, dynamic> toJson(WorkCenter entity) => entity.toJson();
}

final workCenterRepositoryProvider = Provider<WorkCenterRepository>((ref) {
  return WorkCenterRepository(ref.watch(supabaseClientProvider));
});
