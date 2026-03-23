import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

class ComplexionAIApp extends StatelessWidget {
  const ComplexionAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ComplexionAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
