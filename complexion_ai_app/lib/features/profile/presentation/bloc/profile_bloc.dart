import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
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

    on<ProfileSaveRequested>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      // TODO: Wire up repository save
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(isLoading: false, isSaved: true));
    });
  }
}
