import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/skin_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/update_skin_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateSkinProfile _updateSkinProfile;
  final ProfileRepository _profileRepository;

  ProfileBloc({
    required UpdateSkinProfile updateSkinProfile,
    required ProfileRepository profileRepository,
  })  : _updateSkinProfile = updateSkinProfile,
        _profileRepository = profileRepository,
        super(const ProfileState()) {
    on<ProfileLoadRequested>(_onLoad);
    on<ProfileSkinTypeSelected>((event, emit) {
      emit(state.copyWith(skinType: event.skinType));
    });
    on<ProfileConcernToggled>((event, emit) {
      final concerns = List<String>.from(state.selectedConcerns);
      if (concerns.contains(event.concern)) {
        concerns.remove(event.concern);
      } else {
        concerns.add(event.concern);
      }
      emit(state.copyWith(selectedConcerns: concerns));
    });
    on<ProfileAgeRangeSelected>((event, emit) {
      emit(state.copyWith(ageRange: event.ageRange));
    });
    on<ProfileFitzpatrickSelected>((event, emit) {
      emit(state.copyWith(fitzpatrickScale: event.scale));
    });
    on<ProfileClimateSelected>((event, emit) {
      emit(state.copyWith(climate: event.climate));
    });
    on<ProfileAllergiesUpdated>((event, emit) {
      emit(state.copyWith(allergies: event.allergies));
    });
    on<ProfileGoalToggled>((event, emit) {
      final goals = List<String>.from(state.selectedGoals);
      if (goals.contains(event.goal)) {
        goals.remove(event.goal);
      } else {
        goals.add(event.goal);
      }
      emit(state.copyWith(selectedGoals: goals));
    });
    on<ProfileSaveRequested>(_onSave);
  }

  Future<void> _onLoad(ProfileLoadRequested event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final profile = await _profileRepository.getSkinProfile(event.userId);
      if (profile != null) {
        emit(state.copyWith(
          isLoading: false,
          skinType: profile.skinType,
          selectedConcerns: profile.skinConcerns,
          ageRange: profile.ageRange,
          fitzpatrickScale: profile.fitzpatrickScale,
          climate: profile.climate,
          allergies: profile.allergies,
          selectedGoals: profile.goals,
          loadedProfile: profile,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onSave(ProfileSaveRequested event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
      final now = DateTime.now();
      final existingProfile = state.loadedProfile;

      final profile = SkinProfile(
        id: existingProfile?.id ?? '',
        userId: existingProfile?.userId ?? userId,
        skinType: state.skinType,
        skinConcerns: state.selectedConcerns,
        ageRange: state.ageRange,
        fitzpatrickScale: state.fitzpatrickScale,
        climate: state.climate,
        allergies: state.allergies,
        goals: state.selectedGoals,
        onboardingCompleted: true,
        createdAt: existingProfile?.createdAt ?? now,
        updatedAt: now,
      );

      SkinProfile saved;
      if (existingProfile == null || existingProfile.id.isEmpty) {
        saved = await _profileRepository.createSkinProfile(profile);
      } else {
        saved = await _updateSkinProfile(profile);
      }

      emit(state.copyWith(isLoading: false, isSaved: true, loadedProfile: saved));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
