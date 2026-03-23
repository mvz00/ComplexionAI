import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../app/di.dart';
import '../../../../app/router.dart';
import '../bloc/analysis_bloc.dart';
import '../bloc/analysis_event.dart';
import '../bloc/analysis_state.dart';
import '../../domain/entities/analysis_result.dart';
import '../../../../core/theme/colors.dart';

class AnalysisHistoryPage extends StatelessWidget {
  const AnalysisHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
        return getIt<AnalysisBloc>()..add(AnalysisHistoryRequested(userId));
      },
      child: const _AnalysisHistoryView(),
    );
  }
}

class _AnalysisHistoryView extends StatelessWidget {
  const _AnalysisHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analysis History')),
      body: BlocBuilder<AnalysisBloc, AnalysisState>(
        builder: (context, state) {
          if (state is AnalysisProcessing) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.skinPrimary),
            );
          }

          if (state is AnalysisError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white38, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.white54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is AnalysisHistoryLoaded) {
            final results = state.results;
            if (results.isEmpty) {
              return const Center(
                child: Text(
                  'No analysis history yet.\nTake your first skin scan!',
                  style: TextStyle(color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final r = results[index];
                return _HistoryCard(result: r);
              },
            );
          }

          // AnalysisInitial or other — show empty
          return const Center(
            child: Text(
              'No history loaded.',
              style: TextStyle(color: Colors.white38),
            ),
          );
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final AnalysisResult result;
  const _HistoryCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final score = (result.overallScore * 100).round();
    final date = '${result.analysedAt.day}/${result.analysedAt.month}/${result.analysedAt.year}';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => context.go(Routes.analysisResult, extra: result),
        title: Text('Score: $score'),
        subtitle: Text(date),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.skinPrimaryBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$score',
                style: const TextStyle(
                  color: AppColors.skinPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
