import 'package:equatable/equatable.dart';
import 'product.dart';

class RoutineStep extends Equatable {
  final String id;
  final String routineId;
  final int stepOrder;
  final String stepType;
  final String title;
  final String? description;
  final int? durationSeconds;
  final Product? recommendedProduct;
  final bool isOptional;
  final String? aiNotes;
  final bool isCompleted;

  const RoutineStep({
    required this.id,
    required this.routineId,
    required this.stepOrder,
    required this.stepType,
    required this.title,
    this.description,
    this.durationSeconds,
    this.recommendedProduct,
    this.isOptional = false,
    this.aiNotes,
    this.isCompleted = false,
  });

  RoutineStep copyWith({bool? isCompleted}) {
    return RoutineStep(
      id: id, routineId: routineId, stepOrder: stepOrder, stepType: stepType,
      title: title, description: description, durationSeconds: durationSeconds,
      recommendedProduct: recommendedProduct, isOptional: isOptional,
      aiNotes: aiNotes, isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, stepOrder, title, isCompleted];
}
