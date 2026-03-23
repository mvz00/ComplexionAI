import '../../domain/entities/skin_profile.dart';

class SkinProfileModel extends SkinProfile {
  const SkinProfileModel({
    required super.id,
    required super.userId,
    super.skinType,
    super.skinConcerns,
    super.ageRange,
    super.gender,
    super.climate,
    super.allergies,
    super.currentProducts,
    super.goals,
    super.fitzpatrickScale,
    super.onboardingCompleted,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SkinProfileModel.fromJson(Map<String, dynamic> json) {
    return SkinProfileModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      skinType: json['skin_type'] as String?,
      skinConcerns: (json['skin_concerns'] as List<dynamic>?)?.cast<String>() ?? [],
      ageRange: json['age_range'] as String?,
      gender: json['gender'] as String?,
      climate: json['climate'] as String?,
      allergies: (json['allergies'] as List<dynamic>?)?.cast<String>() ?? [],
      currentProducts: (json['current_products'] as List<dynamic>?)?.cast<String>() ?? [],
      goals: (json['goals'] as List<dynamic>?)?.cast<String>() ?? [],
      fitzpatrickScale: json['fitzpatrick_scale'] as int?,
      onboardingCompleted: (json['onboarding_completed'] as bool?) ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'user_id': userId,
      'skin_type': skinType,
      'skin_concerns': skinConcerns,
      'age_range': ageRange,
      'gender': gender,
      'climate': climate,
      'allergies': allergies,
      'current_products': currentProducts,
      'goals': goals,
      'fitzpatrick_scale': fitzpatrickScale,
      'onboarding_completed': onboardingCompleted,
    };
  }
}
