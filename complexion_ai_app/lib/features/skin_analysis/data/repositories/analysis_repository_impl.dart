import '../../domain/entities/analysis_result.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../datasources/analysis_remote_datasource.dart';

class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisRemoteDataSource _remoteDataSource;
  AnalysisRepositoryImpl(this._remoteDataSource);

  @override
  Future<AnalysisResult> analyseImage(String imagePath, String userId) {
    return _remoteDataSource.analyseImage(imagePath, userId);
  }

  @override
  Future<List<AnalysisResult>> getAnalysisHistory(String userId) {
    return _remoteDataSource.getAnalysisHistory(userId);
  }

  @override
  Future<AnalysisResult?> getLatestAnalysis(String userId) {
    return _remoteDataSource.getLatestAnalysis(userId);
  }
}
