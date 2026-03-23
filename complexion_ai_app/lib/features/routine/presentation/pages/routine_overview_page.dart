import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../app/di.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/routine.dart';
import '../../domain/entities/routine_step.dart';
import '../bloc/routine_bloc.dart';
import '../bloc/routine_event.dart';
import '../bloc/routine_state.dart';

class RoutineOverviewPage extends StatelessWidget {
  const RoutineOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
        return getIt<RoutineBloc>()..add(RoutineLoadRequested(userId));
      },
      child: const _RoutineOverviewView(),
    );
  }
}

class _RoutineOverviewView extends StatelessWidget {
  const _RoutineOverviewView();

  static const _tabTypes = ['morning', 'evening', 'weekly'];
  static const _tabLabels = ['Morning', 'Evening', 'Weekly'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutineBloc, RoutineState>(
      builder: (context, state) {
        final selectedIndex = _tabTypes.indexOf(state.selectedType);
        final currentIndex = selectedIndex < 0 ? 0 : selectedIndex;
        final routine = state.selectedRoutine;

        return Scaffold(
          appBar: AppBar(title: const Text('My routine')),
          body: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.skinPrimary),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tab pills
                      Row(
                        children: List.generate(_tabLabels.length, (i) {
                          final selected = currentIndex == i;
                          return GestureDetector(
                            onTap: () => context
                                .read<RoutineBloc>()
                                .add(RoutineTabChanged(_tabTypes[i])),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: selected
                                        ? AppColors.skinPrimary
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                _tabLabels[i],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: selected
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                  color: selected
                                      ? AppColors.skinPrimary
                                      : Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 8),

                      // Error banner
                      if (state.error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade900.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              state.error!,
                              style: const TextStyle(
                                  color: Colors.redAccent, fontSize: 12),
                            ),
                          ),
                        ),

                      // Steps or empty state
                      if (routine == null || routine.steps.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(Icons.spa_outlined,
                                    size: 48, color: Colors.white24),
                                const SizedBox(height: 12),
                                Text(
                                  'No ${_tabLabels[currentIndex].toLowerCase()} routine yet.',
                                  style:
                                      const TextStyle(color: Colors.white38),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap "Regenerate routine" to create one.',
                                  style:
                                      const TextStyle(color: Colors.white24, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        )
                      else ...[
                        ...routine.steps.map((step) => _StepRow(
                              step: step,
                              onTap: () => context.read<RoutineBloc>().add(
                                    RoutineStepToggled(
                                      routineId: routine.id,
                                      stepId: step.id,
                                    ),
                                  ),
                            )),
                        const Divider(height: 24),

                        // AI reasoning card
                        if (routine.aiReasoning != null &&
                            routine.aiReasoning!.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(10),
                              border: const Border(
                                left: BorderSide(
                                    color: AppColors.skinAccent, width: 3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Why this routine?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                                const SizedBox(height: 6),
                                Text(
                                  routine.aiReasoning!,
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),
                      ],

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            final userId = Supabase.instance.client.auth
                                    .currentUser?.id ??
                                '';
                            final analysisId =
                                routine?.basedOnAnalysisId ?? '';
                            context.read<RoutineBloc>().add(
                                  RoutineRegenerateRequested(
                                    userId: userId,
                                    analysisId: analysisId,
                                  ),
                                );
                          },
                          child: const Text('Regenerate routine'),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _StepRow extends StatelessWidget {
  final RoutineStep step;
  final VoidCallback onTap;

  const _StepRow({required this.step, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final product = step.recommendedProduct;
    final durationLabel = step.durationSeconds != null
        ? '${step.durationSeconds}s'
        : '';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // Check circle
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: step.isCompleted ? AppColors.successBg : Colors.transparent,
                border: Border.all(
                  color: step.isCompleted
                      ? AppColors.success
                      : Theme.of(context).colorScheme.outlineVariant,
                  width: 2,
                ),
              ),
              child: step.isCompleted
                  ? const Icon(Icons.check, size: 14, color: AppColors.success)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title,
                      style: Theme.of(context).textTheme.titleSmall),
                  if (product != null)
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  else if (step.description != null)
                    Text(
                      step.description!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            if (durationLabel.isNotEmpty)
              Text(durationLabel,
                  style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
