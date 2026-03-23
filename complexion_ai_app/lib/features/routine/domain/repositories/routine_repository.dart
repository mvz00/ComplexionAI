import '../entities/routine.dart';

abstract class RoutineRepository {
  Future<List<Routine>> getRoutines(String userId);
  Future<Routine> generateRoutine(String userId, String analysisId);
  Future<void> toggleStepCompletion(String stepId, bool completed);
}
