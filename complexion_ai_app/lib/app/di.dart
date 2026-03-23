import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/network/api_client.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Supabase client
  final supabase = Supabase.instance.client;
  getIt.registerSingleton<SupabaseClient>(supabase);

  // API Client
  getIt.registerSingleton<ApiClient>(ApiClient(supabase));

  // Register feature-specific dependencies below as they are built
  // Auth
  _setupAuth();

  // Profile
  _setupProfile();

  // Skin Analysis
  _setupSkinAnalysis();

  // Routine
  _setupRoutine();

  // Daily Check-in
  _setupDailyCheckin();

  // AI Chat
  _setupAiChat();
}

void _setupAuth() {
  // Will be populated in Phase 3
}

void _setupProfile() {
  // Will be populated in Phase 4
}

void _setupSkinAnalysis() {
  // Will be populated in Phase 5
}

void _setupRoutine() {
  // Will be populated in Phase 6
}

void _setupDailyCheckin() {
  // Will be populated in Phase 7
}

void _setupAiChat() {
  // Will be populated in Phase 8
}
