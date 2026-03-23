import '../entities/analysis_result.dart';

class CompareAnalyses {
  Map<String, double> call(AnalysisResult older, AnalysisResult newer) {
    return {
      'acne': newer.metrics.acneScore - older.metrics.acneScore,
      'texture': newer.metrics.textureScore - older.metrics.textureScore,
      'pigmentation': newer.metrics.pigmentationScore - older.metrics.pigmentationScore,
      'hydration': newer.metrics.hydrationScore - older.metrics.hydrationScore,
      'wrinkle': newer.metrics.wrinkleScore - older.metrics.wrinkleScore,
      'pore': newer.metrics.poreScore - older.metrics.poreScore,
      'redness': newer.metrics.rednessScore - older.metrics.rednessScore,
      'dark_circles': newer.metrics.darkCirclesScore - older.metrics.darkCirclesScore,
      'overall': newer.overallScore - older.overallScore,
    };
  }
}
