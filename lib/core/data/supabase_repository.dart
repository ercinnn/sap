import 'package:supabase_flutter/supabase_flutter.dart';

/// Tüm feature repository'lerinin üzerine kurulduğu ortak CRUD davranışı.
/// `materials`, `bill_of_materials`, `work_centers` vb. 7 tablonun hepsi
/// aynı select/insert/update/delete şeklini paylaştığı için burada tutulur.
abstract class SupabaseRepository<T> {
  SupabaseRepository(this.client, this.table);

  final SupabaseClient client;
  final String table;

  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T entity);

  Future<List<T>> getAll() async {
    final rows = await client.from(table).select();
    return rows.map(fromJson).toList();
  }

  Future<T?> getById(String id) async {
    final row = await client.from(table).select().eq('id', id).maybeSingle();
    return row == null ? null : fromJson(row);
  }

  Future<T> insert(T entity) async {
    final row = await client.from(table).insert(toJson(entity)).select().single();
    return fromJson(row);
  }

  Future<T> update(String id, T entity) async {
    final row = await client
        .from(table)
        .update(toJson(entity))
        .eq('id', id)
        .select()
        .single();
    return fromJson(row);
  }

  Future<void> delete(String id) async {
    await client.from(table).delete().eq('id', id);
  }
}
