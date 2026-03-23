import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../../app/router.dart';

class AnalysisResultPage extends StatelessWidget {
  const AnalysisResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data matching wireframe
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text('23 Mar 2026', style: Theme.of(context).textTheme.labelMedium),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Overall score ring
            Text('Overall score', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.skinPrimary, width: 5),
              ),
              child: Center(
                child: Text('74', style: AppTypography.bigValue(color: AppColors.skinPrimary)),
              ),
            ),
            const SizedBox(height: 20),
            // Metric cards grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.8,
              children: const [
                _MetricCard(label: 'Acne', score: 68),
                _MetricCard(label: 'Texture', score: 72),
                _MetricCard(label: 'Hydration', score: 81),
                _MetricCard(label: 'Pores', score: 65),
                _MetricCard(label: 'Pigmentation', score: 78),
                _MetricCard(label: 'Redness', score: 70),
              ],
            ),
            const SizedBox(height: 16),
            // AI summary card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(10),
                border: const Border(left: BorderSide(color: AppColors.skinPrimary, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI summary', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 6),
                  Text(
                    'Good overall shape. Mild congestion around the T-zone and slightly dehydrated cheeks. Texture has improved since last scan. Focus on hydration and gentle exfoliation.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go(Routes.routine),
                child: const Text('Build my routine'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Compare with previous'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final double score;
  const _MetricCard({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(score.toInt().toString(),
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
