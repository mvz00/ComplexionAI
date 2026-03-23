import '../entities/analysis_result.dart';
import '../repositories/analysis_repository.dart';

class GetAnalysisHistory {
  final AnalysisRepository _repository;
  GetAnalysisHistory(this._repository);
  Future<List<AnalysisResult>> call(String userId) {
    return _repository.getAnalysisHistory(userId);
  }
}
