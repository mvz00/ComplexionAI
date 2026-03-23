import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/routine.dart';
import 'routine_event.dart';
import 'routine_state.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  RoutineBloc() : super(const RoutineState()) {
    on<RoutineLoadRequested>(_onLoad);
    on<RoutineStepToggled>(_onStepToggled);
    on<RoutineTabChanged>(_onTabChanged);
  }

  Future<void> _onLoad(RoutineLoadRequested event, Emitter<RoutineState> emit) async {
    emit(state.copyWith(isLoading: true));
    // TODO: Wire up repository
    await Future.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(isLoading: false));
  }

  void _onStepToggled(RoutineStepToggled event, Emitter<RoutineState> emit) {
    final updatedRoutines = state.routines.map((routine) {
      if (routine.id != event.routineId) return routine;
      final updatedSteps = routine.steps.map((step) {
        if (step.id != event.stepId) return step;
        return step.copyWith(isCompleted: !step.isCompleted);
      }).toList();
      return Routine(
        id: routine.id, userId: routine.userId, name: routine.name,
        routineType: routine.routineType, isActive: routine.isActive,
        generatedBy: routine.generatedBy, basedOnAnalysisId: routine.basedOnAnalysisId,
        aiReasoning: routine.aiReasoning, steps: updatedSteps, createdAt: routine.createdAt,
      );
    }).toList();
    emit(state.copyWith(routines: updatedRoutines));
  }

  void _onTabChanged(RoutineTabChanged event, Emitter<RoutineState> emit) {
    emit(state.copyWith(selectedType: event.routineType));
  }
}
