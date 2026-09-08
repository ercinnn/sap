import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

Future<void> initSupabase() async {
  if (!AppConfig.isConfigured) {
    // SUPABASE_URL / SUPABASE_ANON_KEY --dart-define ile verilmediyse
    // uygulamanın açılışını engellemeden sessizce atla (örn. `flutter analyze`,
    // widget testleri). Gerçek çalıştırmada bu değerler her zaman set edilmelidir.
    return;
  }
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    publishableKey: AppConfig.supabaseAnonKey,
  );
}

SupabaseClient get supabase => Supabase.instance.client;

final supabaseClientProvider = Provider<SupabaseClient>((ref) => supabase);
