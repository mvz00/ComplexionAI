import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../app/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning, Mike',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Day 12 streak \u{1F525}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.go(Routes.profile),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: AppColors.skinPrimaryBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'M',
                          style: TextStyle(
                            color: AppColors.skinPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Skin health score card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Skin health score',
                        style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('74',
                            style: AppTypography.bigValue(
                                color: AppColors.skinPrimary)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.successBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '+3 this week',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      children: [
                        _ScoreBadge('Acne 68'),
                        _ScoreBadge('Texture 72'),
                        _ScoreBadge('Hydration 81'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Routine progress card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('AM routine',
                            style: Theme.of(context).textTheme.labelMedium),
                        Text(
                          '4/6 steps',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.skinPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: 4 / 6,
                        minHeight: 5,
                        backgroundColor: Theme.of(context).brightness ==
                                Brightness.dark
                            ? AppColors.darkSurfaceAlt
                            : AppColors.skinSurfaceAlt,
                        color: AppColors.skinPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.go(Routes.routine),
                        child: const Text('Continue routine'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // AI daily tip
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(10),
                  border: const Border(
                    left: BorderSide(color: AppColors.skinAccent, width: 3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI daily tip',
                        style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 6),
                    Text(
                      'Your hydration improved 8% this week \u2014 keep using the HA serum in your PM routine. Consider adding a weekly exfoliant for texture.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            height: 1.6,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Quick actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.push(Routes.scan),
                      child: const Text('New scan'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push(Routes.checkin),
                      child: const Text('Check in'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final String text;
  const _ScoreBadge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurfaceAlt
            : AppColors.skinSurfaceAlt,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
