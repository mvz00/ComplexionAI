import 'package:equatable/equatable.dart';

class SkinMetrics extends Equatable {
  final double acneScore;
  final double textureScore;
  final double pigmentationScore;
  final double hydrationScore;
  final double wrinkleScore;
  final double poreScore;
  final double rednessScore;
  final double darkCirclesScore;

  const SkinMetrics({
    required this.acneScore,
    required this.textureScore,
    required this.pigmentationScore,
    required this.hydrationScore,
    required this.wrinkleScore,
    required this.poreScore,
    required this.rednessScore,
    required this.darkCirclesScore,
  });

  double get overallScore => (acneScore + textureScore + pigmentationScore + hydrationScore + wrinkleScore + poreScore + rednessScore + darkCirclesScore) / 8;

  @override
  List<Object?> get props => [acneScore, textureScore, pigmentationScore, hydrationScore, wrinkleScore, poreScore, rednessScore, darkCirclesScore];
}
