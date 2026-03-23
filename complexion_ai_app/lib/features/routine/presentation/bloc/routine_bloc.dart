import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/routine.dart';
import '../../domain/usecases/get_routines.dart';
import '../../domain/usecases/generate_routine.dart';
import '../../domain/usecases/update_routine.dart';
import 'routine_event.dart';
import 'routine_state.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  final GetRoutines _getRoutines;
  final GenerateRoutine _generateRoutine;
  final UpdateRoutineStep _updateRoutineStep;

  RoutineBloc({
    required GetRoutines getRoutines,
    required GenerateRoutine generateRoutine,
    required UpdateRoutineStep updateRoutineStep,
  })  : _getRoutines = getRoutines,
        _generateRoutine = generateRoutine,
        _updateRoutineStep = updateRoutineStep,
        super(const RoutineState()) {
    on<RoutineLoadRequested>(_onLoad);
    on<RoutineStepToggled>(_onStepToggled);
    on<RoutineTabChanged>(_onTabChanged);
    on<RoutineRegenerateRequested>(_onRegenerate);
  }

  Future<void> _onLoad(
    RoutineLoadRequested event,
    Emitter<RoutineState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final routines = await _getRoutines(event.userId);
      emit(state.copyWith(isLoading: false, routines: routines));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onRegenerate(
    RoutineRegenerateRequested event,
    Emitter<RoutineState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final routine = await _generateRoutine(event.userId, event.analysisId);
      // Replace or add the routine with the same type in the list
      final updated = [
        ...state.routines.where((r) => r.routineType != routine.routineType),
        routine,
      ];
      emit(state.copyWith(isLoading: false, routines: updated));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onStepToggled(
    RoutineStepToggled event,
    Emitter<RoutineState> emit,
  ) async {
    // Optimistically update local state first
    final updatedRoutines = state.routines.map((routine) {
      if (routine.id != event.routineId) return routine;
      final updatedSteps = routine.steps.map((step) {
        if (step.id != event.stepId) return step;
        return step.copyWith(isCompleted: !step.isCompleted);
      }).toList();
      return Routine(
        id: routine.id,
        userId: routine.userId,
        name: routine.name,
        routineType: routine.routineType,
        isActive: routine.isActive,
        generatedBy: routine.generatedBy,
        basedOnAnalysisId: routine.basedOnAnalysisId,
        aiReasoning: routine.aiReasoning,
        steps: updatedSteps,
        createdAt: routine.createdAt,
      );
    }).toList();
    emit(state.copyWith(routines: updatedRoutines));

    // Persist the new completion state
    try {
      // Find the step's new completed value
      bool? newCompleted;
      for (final r in updatedRoutines) {
        if (r.id == event.routineId) {
          for (final s in r.steps) {
            if (s.id == event.stepId) {
              newCompleted = s.isCompleted;
              break;
            }
          }
        }
      }
      if (newCompleted != null) {
        await _updateRoutineStep(event.stepId, newCompleted);
      }
    } catch (_) {
      // Ignore persistence errors — optimistic update stays
    }
  }

  void _onTabChanged(
    RoutineTabChanged event,
    Emitter<RoutineState> emit,
  ) {
    emit(state.copyWith(selectedType: event.routineType));
  }
}
