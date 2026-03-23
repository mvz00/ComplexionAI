import '../../domain/entities/checkin.dart';
import '../../domain/repositories/checkin_repository.dart';
import '../datasources/checkin_remote_datasource.dart';
import '../models/checkin_model.dart';

class CheckinRepositoryImpl implements CheckinRepository {
  final CheckinRemoteDataSource _remoteDataSource;
  CheckinRepositoryImpl(this._remoteDataSource);

  @override
  Future<Checkin> submitCheckin(Checkin checkin) {
    final model = CheckinModel(
      id: checkin.id,
      userId: checkin.userId,
      checkinDate: checkin.checkinDate,
      skinFeeling: checkin.skinFeeling,
      notes: checkin.notes,
      photoPath: checkin.photoPath,
      routineCompleted: checkin.routineCompleted,
      routineId: checkin.routineId,
      stepsCompleted: checkin.stepsCompleted,
      sleepHours: checkin.sleepHours,
      waterIntakeLitres: checkin.waterIntakeLitres,
      stressLevel: checkin.stressLevel,
    );
    return _remoteDataSource.submitCheckin(model.toJson());
  }

  @override
  Future<List<Checkin>> getCheckins(String userId, {int limit = 30}) {
    return _remoteDataSource.getCheckins(userId, limit: limit);
  }

  @override
  Future<int> getStreakCount(String userId) {
    return _remoteDataSource.getStreakCount(userId);
  }
}
