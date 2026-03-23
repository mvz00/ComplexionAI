import '../repositories/routine_repository.dart';

class UpdateRoutineStep {
  final RoutineRepository _repository;
  UpdateRoutineStep(this._repository);
  Future<void> call(String stepId, bool completed) {
    return _repository.toggleStepCompletion(stepId, completed);
  }
}
