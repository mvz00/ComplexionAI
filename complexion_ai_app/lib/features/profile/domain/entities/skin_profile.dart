import 'package:equatable/equatable.dart';

class SkinProfile extends Equatable {
  final String id;
  final String userId;
  final String? skinType;
  final List<String> skinConcerns;
  final String? ageRange;
  final String? gender;
  final String? climate;
  final List<String> allergies;
  final List<String> currentProducts;
  final List<String> goals;
  final int? fitzpatrickScale;
  final bool onboardingCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SkinProfile({
    required this.id,
    required this.userId,
    this.skinType,
    this.skinConcerns = const [],
    this.ageRange,
    this.gender,
    this.climate,
    this.allergies = const [],
    this.currentProducts = const [],
    this.goals = const [],
    this.fitzpatrickScale,
    this.onboardingCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, userId, skinType, skinConcerns, ageRange, fitzpatrickScale, onboardingCompleted];
}
