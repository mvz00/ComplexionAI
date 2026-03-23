import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../../app/router.dart';
import '../../domain/entities/analysis_result.dart';

class AnalysisResultPage extends StatelessWidget {
  final AnalysisResult? result;

  const AnalysisResultPage({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final r = result;

    // Format the date
    final dateLabel = r != null
        ? '${r.analysedAt.day} ${_monthName(r.analysedAt.month)} ${r.analysedAt.year}'
        : '—';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(dateLabel, style: Theme.of(context).textTheme.labelMedium),
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
                child: Text(
                  r != null ? (r.overallScore * 100).round().toString() : '—',
                  style: AppTypography.bigValue(color: AppColors.skinPrimary),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Metric cards grid
            if (r != null) ...[
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.8,
                children: [
                  _MetricCard(label: 'Acne', score: r.metrics.acneScore * 100),
                  _MetricCard(label: 'Texture', score: r.metrics.textureScore * 100),
                  _MetricCard(label: 'Hydration', score: r.metrics.hydrationScore * 100),
                  _MetricCard(label: 'Pores', score: r.metrics.poreScore * 100),
                  _MetricCard(label: 'Pigmentation', score: r.metrics.pigmentationScore * 100),
                  _MetricCard(label: 'Redness', score: r.metrics.rednessScore * 100),
                ],
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'No analysis data available',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // AI summary card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(10),
                border: const Border(
                  left: BorderSide(color: AppColors.skinPrimary, width: 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI summary', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 6),
                  Text(
                    r?.aiSummary ?? 'No summary available for this analysis.',
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

  static String _monthName(int month) {
    const names = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[month];
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
          Text(
            score.round().toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
