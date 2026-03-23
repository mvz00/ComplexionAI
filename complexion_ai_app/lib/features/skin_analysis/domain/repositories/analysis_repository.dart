import 'dart:typed_data';
import '../entities/analysis_result.dart';

abstract class AnalysisRepository {
  Future<AnalysisResult> analyseImage(Uint8List imageBytes, String userId);
  Future<List<AnalysisResult>> getAnalysisHistory(String userId);
  Future<AnalysisResult?> getLatestAnalysis(String userId);
}
