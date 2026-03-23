import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../app/di.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/checkin.dart';
import '../bloc/checkin_bloc.dart';
import '../bloc/checkin_event.dart';
import '../bloc/checkin_state.dart';

class ProgressTimelinePage extends StatelessWidget {
  const ProgressTimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    return BlocProvider(
      create: (_) => getIt<CheckinBloc>()..add(CheckinLoadRequested(userId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Progress')),
        body: BlocBuilder<CheckinBloc, CheckinState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Failed to load progress: ${state.error}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              );
            }
            return Column(
              children: [
                // Streak card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.skinPrimaryBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          Text(
                            '${state.streak}',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.skinPrimary),
                          ),
                          Text('day streak', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
                // Timeline entries
                Expanded(
                  child: state.history.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.history, size: 48, color: AppColors.skinPrimary.withAlpha(100)),
                                const SizedBox(height: 16),
                                Text(
                                  'No check-ins yet',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Complete your first daily check-in to start tracking your skin journey.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.history.length,
                          itemBuilder: (context, index) {
                            final entry = state.history[index];
                            return _TimelineEntry(checkin: entry);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Color _feelingColor(String? feeling) {
  switch (feeling) {
    case 'great':
      return AppColors.skinPrimary;
    case 'good':
      return AppColors.success;
    case 'okay':
      return AppColors.warning;
    case 'bad':
      return AppColors.danger;
    case 'terrible':
      return AppColors.danger;
    default:
      return AppColors.skinBorder;
  }
}

String _formatDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final entryDay = DateTime(date.year, date.month, date.day);
  final diff = today.difference(entryDay).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return '$diff days ago';
}

class _TimelineEntry extends StatelessWidget {
  final Checkin checkin;

  const _TimelineEntry({required this.checkin});

  @override
  Widget build(BuildContext context) {
    final feeling = checkin.skinFeeling ?? 'unknown';
    final color = _feelingColor(checkin.skinFeeling);
    final dateLabel = _formatDate(checkin.checkinDate);
    final note = checkin.notes?.isNotEmpty == true ? checkin.notes! : 'No notes';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dateLabel, style: Theme.of(context).textTheme.labelMedium),
                      Text(feeling, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(note, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
