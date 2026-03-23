import '../../domain/entities/skin_metrics.dart';

class SkinMetricsModel extends SkinMetrics {
  const SkinMetricsModel({
    required super.acneScore,
    required super.textureScore,
    required super.pigmentationScore,
    required super.hydrationScore,
    required super.wrinkleScore,
    required super.poreScore,
    required super.rednessScore,
    required super.darkCirclesScore,
  });

  factory SkinMetricsModel.fromJson(Map<String, dynamic> json) {
    return SkinMetricsModel(
      acneScore: (json['acne_score'] as num).toDouble(),
      textureScore: (json['texture_score'] as num).toDouble(),
      pigmentationScore: (json['pigmentation_score'] as num).toDouble(),
      hydrationScore: (json['hydration_score'] as num).toDouble(),
      wrinkleScore: (json['wrinkle_score'] as num).toDouble(),
      poreScore: (json['pore_score'] as num).toDouble(),
      rednessScore: (json['redness_score'] as num).toDouble(),
      darkCirclesScore: (json['dark_circles_score'] as num).toDouble(),
    );
  }
}
