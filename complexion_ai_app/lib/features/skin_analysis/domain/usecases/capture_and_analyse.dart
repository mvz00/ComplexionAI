import '../entities/analysis_result.dart';
import '../repositories/analysis_repository.dart';

class CaptureAndAnalyse {
  final AnalysisRepository _repository;
  CaptureAndAnalyse(this._repository);
  Future<AnalysisResult> call(String imagePath, String userId) {
    return _repository.analyseImage(imagePath, userId);
  }
}
