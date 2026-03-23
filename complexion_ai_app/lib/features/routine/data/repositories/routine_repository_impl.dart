import '../../domain/entities/routine.dart';
import '../../domain/repositories/routine_repository.dart';
import '../datasources/routine_remote_datasource.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineRemoteDataSource _remoteDataSource;
  RoutineRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Routine>> getRoutines(String userId) {
    return _remoteDataSource.getRoutines(userId);
  }

  @override
  Future<Routine> generateRoutine(String userId, String analysisId) {
    return _remoteDataSource.generateRoutine(userId, analysisId);
  }

  @override
  Future<void> toggleStepCompletion(String stepId, bool completed) {
    return _remoteDataSource.toggleStepCompletion(stepId, completed);
  }
}
