import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'app/di.dart';

const _supabaseUrl = 'https://wxordyurslpdfzbykxmk.supabase.co';
const _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
    '.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind4b3JkeXVyc2xwZGZ6YnlreG1rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQyNTQ0NzMsImV4cCI6MjA4OTgzMDQ3M30'
    '.G_plcC43JvKta_NzzIyJafzkoNsE4RmVVQdj1Xs3Rlk';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('[App] Starting ComplexionAI...');
  debugPrint('[App] Supabase URL: $_supabaseUrl');
  debugPrint('[App] Anon key prefix: ${_supabaseAnonKey.substring(0, 20)}...');

  try {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
    debugPrint('[App] Supabase initialized OK');
  } catch (e) {
    debugPrint('[App] Supabase init ERROR: $e');
  }

  await setupDependencies();
  debugPrint('[App] DI setup complete');

  runApp(const ComplexionAIApp());
}
