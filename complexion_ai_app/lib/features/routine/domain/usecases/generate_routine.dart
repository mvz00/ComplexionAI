import '../entities/routine.dart';
import '../repositories/routine_repository.dart';

class GenerateRoutine {
  final RoutineRepository _repository;
  GenerateRoutine(this._repository);
  Future<Routine> call(String userId, String analysisId) {
    return _repository.generateRoutine(userId, analysisId);
  }
}
