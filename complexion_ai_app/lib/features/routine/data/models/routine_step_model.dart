import '../../domain/entities/routine_step.dart';
import 'product_model.dart';

class RoutineStepModel extends RoutineStep {
  const RoutineStepModel({
    required super.id,
    required super.routineId,
    required super.stepOrder,
    required super.stepType,
    required super.title,
    super.description,
    super.durationSeconds,
    super.recommendedProduct,
    super.isOptional,
    super.aiNotes,
    super.isCompleted,
  });

  factory RoutineStepModel.fromJson(Map<String, dynamic> json) {
    return RoutineStepModel(
      id: json['id'] as String,
      routineId: json['routine_id'] as String,
      stepOrder: json['step_order'] as int,
      stepType: json['step_type'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      durationSeconds: json['duration_seconds'] as int?,
      recommendedProduct: json['product'] != null ? ProductModel.fromJson(json['product']) : null,
      isOptional: (json['is_optional'] as bool?) ?? false,
      aiNotes: json['ai_notes'] as String?,
    );
  }
}
