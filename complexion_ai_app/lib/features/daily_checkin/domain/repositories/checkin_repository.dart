import '../entities/checkin.dart';

abstract class CheckinRepository {
  Future<Checkin> submitCheckin(Checkin checkin);
  Future<List<Checkin>> getCheckins(String userId, {int limit = 30});
  Future<int> getStreakCount(String userId);
}
