import '../../domain/entities/analysis_result.dart';
import 'skin_metrics_model.dart';

class AnalysisResultModel extends AnalysisResult {
  const AnalysisResultModel({
    required super.id,
    required super.userId,
    required super.imagePath,
    required super.overallScore,
    required super.metrics,
    super.aiSummary,
    super.modelVersion,
    required super.analysedAt,
  });

  factory AnalysisResultModel.fromJson(Map<String, dynamic> json) {
    final metrics = SkinMetricsModel.fromJson(json);
    return AnalysisResultModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      imagePath: json['image_path'] as String,
      overallScore: (json['overall_score'] as num).toDouble(),
      metrics: metrics,
      aiSummary: json['ai_summary'] as String?,
      modelVersion: json['model_version'] as String?,
      analysedAt: DateTime.parse(json['analysed_at'] as String),
    );
  }
}
