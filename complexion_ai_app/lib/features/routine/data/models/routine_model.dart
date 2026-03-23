import '../../domain/entities/routine.dart';
import 'routine_step_model.dart';

class RoutineModel extends Routine {
  const RoutineModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.routineType,
    super.isActive,
    super.generatedBy,
    super.basedOnAnalysisId,
    super.aiReasoning,
    super.steps,
    required super.createdAt,
  });

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    final stepsData = json['routine_steps'] as List<dynamic>? ?? [];
    return RoutineModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      routineType: json['routine_type'] as String,
      isActive: (json['is_active'] as bool?) ?? true,
      generatedBy: (json['generated_by'] as String?) ?? 'ai',
      basedOnAnalysisId: json['based_on_analysis_id'] as String?,
      aiReasoning: json['ai_reasoning'] as String?,
      steps: stepsData.map((e) => RoutineStepModel.fromJson(e as Map<String, dynamic>)).toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
