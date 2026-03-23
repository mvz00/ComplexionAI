import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../app/router.dart';
import '../bloc/checkin_bloc.dart';
import '../bloc/checkin_event.dart';
import '../bloc/checkin_state.dart';

class DailyCheckinPage extends StatelessWidget {
  const DailyCheckinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckinBloc(),
      child: BlocListener<CheckinBloc, CheckinState>(
        listener: (context, state) {
          if (state.isSubmitted) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Check-in complete!'),
                content: state.aiTip != null
                    ? Text(state.aiTip!, style: Theme.of(context).textTheme.bodySmall)
                    : null,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go(Routes.home);
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Daily check-in')),
          body: BlocBuilder<CheckinBloc, CheckinState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("How's your skin today?", style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    // Emoji selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (i) {
                        final feeling = AppConstants.skinFeelings[i];
                        final emoji = AppConstants.skinFeelingEmojis[i];
                        final selected = state.skinFeeling == feeling;
                        return GestureDetector(
                          onTap: () => context.read<CheckinBloc>().add(CheckinFeelingSelected(feeling)),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected ? AppColors.skinPrimary : AppColors.skinBorder,
                                width: selected ? 2 : 1,
                              ),
                              color: selected ? AppColors.skinPrimaryBg : null,
                            ),
                            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    // Routine completion
                    SwitchListTile(
                      title: const Text('Completed routine?'),
                      value: state.routineCompleted,
                      onChanged: (_) => context.read<CheckinBloc>().add(CheckinRoutineCompletedToggled()),
                      activeColor: AppColors.skinPrimary,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 16),
                    // Sleep slider
                    Text('Sleep: ${state.sleepHours.toStringAsFixed(1)} hours', style: Theme.of(context).textTheme.titleSmall),
                    Slider(
                      value: state.sleepHours,
                      min: 0, max: 12,
                      divisions: 24,
                      activeColor: AppColors.skinPrimary,
                      onChanged: (v) => context.read<CheckinBloc>().add(CheckinSleepChanged(v)),
                    ),
                    // Water slider
                    Text('Water: ${state.waterLitres.toStringAsFixed(1)}L', style: Theme.of(context).textTheme.titleSmall),
                    Slider(
                      value: state.waterLitres,
                      min: 0, max: 5,
                      divisions: 10,
                      activeColor: AppColors.info,
                      onChanged: (v) => context.read<CheckinBloc>().add(CheckinWaterChanged(v)),
                    ),
                    // Stress slider
                    Text('Stress: ${state.stressLevel}/5', style: Theme.of(context).textTheme.titleSmall),
                    Slider(
                      value: state.stressLevel.toDouble(),
                      min: 1, max: 5,
                      divisions: 4,
                      activeColor: AppColors.warning,
                      onChanged: (v) => context.read<CheckinBloc>().add(CheckinStressChanged(v.toInt())),
                    ),
                    const SizedBox(height: 16),
                    // Notes
                    TextField(
                      maxLines: 3,
                      decoration: const InputDecoration(hintText: 'Any notes about your skin today...'),
                      onChanged: (v) => context.read<CheckinBloc>().add(CheckinNotesChanged(v)),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isSubmitting ? null : () {
                          context.read<CheckinBloc>().add(CheckinSubmitRequested());
                        },
                        child: state.isSubmitting
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Submit check-in'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
