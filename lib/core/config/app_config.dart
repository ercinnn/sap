/// Derleme zamanında `--dart-define` ile enjekte edilen Supabase kimlik bilgileri.
/// Gerçek değerler repoya asla commit edilmez; yerelde `flutter run`/`flutter build`
/// komutlarına, CI'da GitHub Actions secrets üzerinden geçirilir.
class AppConfig {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
