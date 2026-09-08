import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/supabase_client.dart';
import '../../../core/theme/theme_providers.dart';
import '../../../core/theme/ui_mode.dart';

/// FAZ 1 doğrulama ekranı: mod/tema anahtarlarının ve Supabase bağlantısının
/// çalıştığını gösterir. FAZ 4'te gerçek Hazıredim (Master-Detail) ekranıyla
/// değiştirilecektir.
class DashboardPlaceholderScreen extends ConsumerStatefulWidget {
  const DashboardPlaceholderScreen({super.key});

  @override
  ConsumerState<DashboardPlaceholderScreen> createState() =>
      _DashboardPlaceholderScreenState();
}

class _DashboardPlaceholderScreenState
    extends ConsumerState<DashboardPlaceholderScreen> {
  String _connectionStatus = 'Henüz test edilmedi';
  bool _isTesting = false;

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _connectionStatus = 'Test ediliyor...';
    });

    if (!AppConfig.isConfigured) {
      setState(() {
        _isTesting = false;
        _connectionStatus =
            'SUPABASE_URL / SUPABASE_ANON_KEY --dart-define ile verilmedi.';
      });
      return;
    }

    try {
      // materials tablosu FAZ 2'de oluşturulacak; bu sorgu şu an "relation
      // does not exist" dönebilir - bu bile PostgREST'e ulaşıldığının kanıtıdır.
      await supabase.from('materials').select().limit(1);
      setState(() {
        _isTesting = false;
        _connectionStatus = 'Bağlantı başarılı, "materials" tablosu bulundu.';
      });
    } catch (e) {
      setState(() {
        _isTesting = false;
        _connectionStatus = 'Supabase\'e ulaşıldı, sunucu yanıtı: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiMode = ref.watch(uiModeProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SAP PP - Tekstil Üretim Planlama (FAZ 1)'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Görünüm Modu',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<UiMode>(
                          segments: const [
                            ButtonSegment(
                              value: UiMode.classic,
                              label: Text('Classic SAP GUI'),
                              icon: Icon(Icons.grid_on),
                            ),
                            ButtonSegment(
                              value: UiMode.modern,
                              label: Text('Modern ERP'),
                              icon: Icon(Icons.dashboard_customize_outlined),
                            ),
                          ],
                          selected: {uiMode},
                          onSelectionChanged: (_) =>
                              ref.read(uiModeProvider.notifier).toggle(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tema (sadece Modern modda etkili)',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.light,
                              label: Text('Açık'),
                              icon: Icon(Icons.light_mode_outlined),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              label: Text('Koyu'),
                              icon: Icon(Icons.dark_mode_outlined),
                            ),
                            ButtonSegment(
                              value: ThemeMode.system,
                              label: Text('Sistem'),
                              icon: Icon(Icons.brightness_auto_outlined),
                            ),
                          ],
                          selected: {themeMode},
                          onSelectionChanged: uiMode == UiMode.classic
                              ? null
                              : (selection) => ref
                                  .read(appThemeModeProvider.notifier)
                                  .setThemeMode(selection.first),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Supabase Bağlantısı',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(_connectionStatus),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _isTesting ? null : _testConnection,
                          child: Text(
                            _isTesting ? 'Test ediliyor...' : 'Bağlantıyı Test Et',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
