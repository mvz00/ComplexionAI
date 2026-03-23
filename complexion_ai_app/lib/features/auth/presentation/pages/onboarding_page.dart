import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/colors.dart';
import '../../../../app/router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo circle
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.skinPrimaryBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'C',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.skinPrimary,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // App name
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.displaySmall,
                  children: const [
                    TextSpan(text: 'Complexion'),
                    TextSpan(
                      text: 'AI',
                      style: TextStyle(color: AppColors.skinAccent),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your AI skincare companion.\nAnalyse, track, and transform your skin.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.skinTextSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              // Get started button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go(Routes.register),
                  child: const Text('Get started'),
                ),
              ),
              const SizedBox(height: 16),
              // Sign in link
              GestureDetector(
                onTap: () => context.go(Routes.login),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall,
                    children: const [
                      TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Sign in',
                        style: TextStyle(
                          color: AppColors.info,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
