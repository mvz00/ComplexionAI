class ApiConstants {
  ApiConstants._();

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  // Edge function paths
  static const String analyseSkin = '/functions/v1/analyse-skin';
  static const String generateRoutine = '/functions/v1/generate-routine';
  static const String aiChat = '/functions/v1/ai-chat';
  static const String recommendProducts = '/functions/v1/recommend-products';
  static const String dailyInsights = '/functions/v1/daily-insights';
  static const String adminAnalytics = '/functions/v1/admin-analytics';

  // Storage buckets
  static const String skinImagesBucket = 'skin-images';
  static const String productImagesBucket = 'product-images';

  // Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration analysisTimeout = Duration(seconds: 60);
  static const Duration chatTimeout = Duration(seconds: 45);
}
