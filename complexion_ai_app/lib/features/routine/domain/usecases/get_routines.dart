import '../entities/routine.dart';
import '../repositories/routine_repository.dart';

class GetRoutines {
  final RoutineRepository _repository;
  GetRoutines(this._repository);
  Future<List<Routine>> call(String userId) {
    return _repository.getRoutines(userId);
  }
}
