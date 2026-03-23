import 'package:equatable/equatable.dart';
import 'routine_step.dart';

class Routine extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String routineType; // morning, evening, weekly
  final bool isActive;
  final String generatedBy;
  final String? basedOnAnalysisId;
  final String? aiReasoning;
  final List<RoutineStep> steps;
  final DateTime createdAt;

  const Routine({
    required this.id,
    required this.userId,
    required this.name,
    required this.routineType,
    this.isActive = true,
    this.generatedBy = 'ai',
    this.basedOnAnalysisId,
    this.aiReasoning,
    this.steps = const [],
    required this.createdAt,
  });

  int get completedSteps => steps.where((s) => s.isCompleted).length;
  double get progress => steps.isEmpty ? 0 : completedSteps / steps.length;

  @override
  List<Object?> get props => [id, routineType, isActive];
}
