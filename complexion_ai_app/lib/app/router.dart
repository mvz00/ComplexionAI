import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/onboarding_page.dart';
import '../features/profile/presentation/pages/skin_profile_setup_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/profile/presentation/pages/settings_page.dart';
import '../features/skin_analysis/presentation/pages/camera_capture_page.dart';
import '../features/skin_analysis/presentation/pages/analysis_result_page.dart';
import '../features/skin_analysis/presentation/pages/analysis_history_page.dart';
import '../features/routine/presentation/pages/routine_overview_page.dart';
import '../features/routine/presentation/pages/routine_detail_page.dart';
import '../features/routine/presentation/pages/product_detail_page.dart';
import '../features/daily_checkin/presentation/pages/daily_checkin_page.dart';
import '../features/daily_checkin/presentation/pages/progress_timeline_page.dart';
import '../features/ai_chat/presentation/pages/ai_chat_page.dart';
import '../features/home/home_page.dart';
import '../shared/widgets/bottom_nav_bar.dart';

// Route names
class Routes {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const skinProfileSetup = '/skin-profile-setup';
  static const home = '/';
  static const scan = '/scan';
  static const analysisResult = '/analysis-result';
  static const analysisHistory = '/analysis-history';
  static const routine = '/routine';
  static const routineDetail = '/routine-detail';
  static const productDetail = '/product-detail';
  static const checkin = '/checkin';
  static const progress = '/progress';
  static const chat = '/chat';
  static const profile = '/profile';
  static const settings = '/settings';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.onboarding,
  routes: [
    // Auth routes (no bottom nav)
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: Routes.skinProfileSetup,
      builder: (context, state) => const SkinProfileSetupPage(),
    ),

    // Full-screen routes (no bottom nav)
    GoRoute(
      path: Routes.scan,
      builder: (context, state) => const CameraCapturePage(),
    ),

    // Shell route with bottom navigation
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: Routes.routine,
          builder: (context, state) => const RoutineOverviewPage(),
        ),
        GoRoute(
          path: Routes.chat,
          builder: (context, state) => const AiChatPage(),
        ),
        GoRoute(
          path: Routes.profile,
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),

    // Detail routes (push on top of shell)
    GoRoute(
      path: Routes.analysisResult,
      builder: (context, state) => const AnalysisResultPage(),
    ),
    GoRoute(
      path: Routes.analysisHistory,
      builder: (context, state) => const AnalysisHistoryPage(),
    ),
    GoRoute(
      path: Routes.routineDetail,
      builder: (context, state) => const RoutineDetailPage(),
    ),
    GoRoute(
      path: Routes.productDetail,
      builder: (context, state) => const ProductDetailPage(),
    ),
    GoRoute(
      path: Routes.checkin,
      builder: (context, state) => const DailyCheckinPage(),
    ),
    GoRoute(
      path: Routes.progress,
      builder: (context, state) => const ProgressTimelinePage(),
    ),
    GoRoute(
      path: Routes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);

/// Shell widget with bottom navigation bar
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location == Routes.home) return 0;
    if (location == Routes.routine) return 1;
    if (location == Routes.chat) return 2;
    if (location == Routes.profile) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex(context),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(Routes.home);
            case 1:
              context.go(Routes.routine);
            case 2:
              context.go(Routes.chat);
            case 3:
              context.go(Routes.profile);
          }
        },
      ),
    );
  }
}

