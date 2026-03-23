import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'app/di.dart';

const _supabaseUrl = 'https://wxordyurslpdfzbykxmk.supabase.co';
const _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
    '.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind4b3JkeXVyc2xwZGZ6YnlreG1rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQyNTQ0NzMsImV4cCI6MjA4OTgzMDQ3M30'
    '.G_plcC43JvKta_NzzIyJafzkoNsE4RmVVQdj1Xs3Rlk';

// Build stamp — increment to bust service worker cache
const kBuildStamp = 'v1.0.4';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('[App] $kBuildStamp Starting ComplexionAI...');
  print('[App] Supabase URL: $_supabaseUrl');

  try {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
    print('[App] Supabase initialized OK');
  } catch (e) {
    print('[App] Supabase init ERROR: $e');
  }

  await setupDependencies();
  print('[App] DI setup complete — $kBuildStamp');

  runApp(const ComplexionAIApp());
}
