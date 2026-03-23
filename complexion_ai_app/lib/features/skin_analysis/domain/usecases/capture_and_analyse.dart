import 'dart:typed_data';
import '../entities/analysis_result.dart';
import '../repositories/analysis_repository.dart';

class CaptureAndAnalyse {
  final AnalysisRepository _repository;
  CaptureAndAnalyse(this._repository);
  Future<AnalysisResult> call(Uint8List imageBytes, String userId) {
    return _repository.analyseImage(imageBytes, userId);
  }
}
