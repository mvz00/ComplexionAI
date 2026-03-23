import 'package:equatable/equatable.dart';
import '../../domain/entities/routine.dart';

class RoutineState extends Equatable {
  final List<Routine> routines;
  final String selectedType;
  final bool isLoading;
  final String? error;

  const RoutineState({
    this.routines = const [],
    this.selectedType = 'morning',
    this.isLoading = false,
    this.error,
  });

  Routine? get selectedRoutine {
    try {
      return routines.firstWhere((r) => r.routineType == selectedType);
    } catch (_) {
      return null;
    }
  }

  RoutineState copyWith({
    List<Routine>? routines,
    String? selectedType,
    bool? isLoading,
    String? error,
  }) {
    return RoutineState(
      routines: routines ?? this.routines,
      selectedType: selectedType ?? this.selectedType,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [routines, selectedType, isLoading, error];
}
