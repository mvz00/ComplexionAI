import '../entities/skin_profile.dart';

abstract class ProfileRepository {
  Future<SkinProfile?> getSkinProfile(String userId);
  Future<SkinProfile> createSkinProfile(SkinProfile profile);
  Future<SkinProfile> updateSkinProfile(SkinProfile profile);
}
