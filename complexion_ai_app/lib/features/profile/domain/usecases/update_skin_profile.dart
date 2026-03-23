import '../entities/skin_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateSkinProfile {
  final ProfileRepository _repository;

  UpdateSkinProfile(this._repository);

  Future<SkinProfile> call(SkinProfile profile) {
    return _repository.updateSkinProfile(profile);
  }
}
