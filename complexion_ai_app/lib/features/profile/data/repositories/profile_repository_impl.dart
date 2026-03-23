import '../../domain/entities/skin_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/skin_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<SkinProfile?> getSkinProfile(String userId) {
    return _remoteDataSource.getSkinProfile(userId);
  }

  @override
  Future<SkinProfile> createSkinProfile(SkinProfile profile) {
    final model = SkinProfileModel(
      id: profile.id,
      userId: profile.userId,
      skinType: profile.skinType,
      skinConcerns: profile.skinConcerns,
      ageRange: profile.ageRange,
      gender: profile.gender,
      climate: profile.climate,
      allergies: profile.allergies,
      currentProducts: profile.currentProducts,
      goals: profile.goals,
      fitzpatrickScale: profile.fitzpatrickScale,
      onboardingCompleted: profile.onboardingCompleted,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
    return _remoteDataSource.createSkinProfile(model.toJson());
  }

  @override
  Future<SkinProfile> updateSkinProfile(SkinProfile profile) {
    final model = SkinProfileModel(
      id: profile.id,
      userId: profile.userId,
      skinType: profile.skinType,
      skinConcerns: profile.skinConcerns,
      ageRange: profile.ageRange,
      gender: profile.gender,
      climate: profile.climate,
      allergies: profile.allergies,
      currentProducts: profile.currentProducts,
      goals: profile.goals,
      fitzpatrickScale: profile.fitzpatrickScale,
      onboardingCompleted: profile.onboardingCompleted,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
    return _remoteDataSource.updateSkinProfile(profile.id, model.toJson());
  }
}
