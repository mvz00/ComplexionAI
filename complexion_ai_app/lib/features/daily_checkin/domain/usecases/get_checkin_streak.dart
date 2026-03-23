import '../repositories/checkin_repository.dart';

class GetCheckinStreak {
  final CheckinRepository _repository;
  GetCheckinStreak(this._repository);
  Future<int> call(String userId) => _repository.getStreakCount(userId);
}
