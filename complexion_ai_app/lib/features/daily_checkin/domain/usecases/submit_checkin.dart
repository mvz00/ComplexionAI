import '../entities/checkin.dart';
import '../repositories/checkin_repository.dart';

class SubmitCheckin {
  final CheckinRepository _repository;
  SubmitCheckin(this._repository);
  Future<Checkin> call(Checkin checkin) => _repository.submitCheckin(checkin);
}
