import 'package:equatable/equatable.dart';
import 'skin_metrics.dart';

class AnalysisResult extends Equatable {
  final String id;
  final String userId;
  final String imagePath;
  final double overallScore;
  final SkinMetrics metrics;
  final String? aiSummary;
  final String? modelVersion;
  final DateTime analysedAt;

  const AnalysisResult({
    required this.id,
    required this.userId,
    required this.imagePath,
    required this.overallScore,
    required this.metrics,
    this.aiSummary,
    this.modelVersion,
    required this.analysedAt,
  });

  @override
  List<Object?> get props => [id, userId, overallScore, analysedAt];
}
