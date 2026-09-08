import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/network/supabase_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/classic_sap_theme.dart';
import 'core/theme/modern_theme.dart';
import 'core/theme/theme_providers.dart';
import 'core/theme/ui_mode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  runApp(const ProviderScope(child: SapPpApp()));
}

class SapPpApp extends ConsumerWidget {
  const SapPpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiMode = ref.watch(uiModeProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp.router(
      title: 'SAP PP - Tekstil Üretim Planlama',
      debugShowCheckedModeBanner: false,
      theme: uiMode == UiMode.classic ? classicSapTheme : modernLightTheme,
      darkTheme: uiMode == UiMode.classic ? classicSapTheme : modernDarkTheme,
      themeMode: uiMode == UiMode.classic ? ThemeMode.light : themeMode,
      routerConfig: appRouter,
    );
  }
}
