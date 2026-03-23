import 'package:equatable/equatable.dart';

abstract class RoutineEvent extends Equatable {
  const RoutineEvent();
  @override
  List<Object?> get props => [];
}

class RoutineLoadRequested extends RoutineEvent {
  final String userId;
  const RoutineLoadRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}

class RoutineStepToggled extends RoutineEvent {
  final String routineId;
  final String stepId;
  const RoutineStepToggled({required this.routineId, required this.stepId});
  @override
  List<Object?> get props => [routineId, stepId];
}

class RoutineTabChanged extends RoutineEvent {
  final String routineType; // morning, evening, weekly
  const RoutineTabChanged(this.routineType);
  @override
  List<Object?> get props => [routineType];
}
