import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  final String userId;
  const ProfileLoadRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}

class ProfileSkinTypeSelected extends ProfileEvent {
  final String skinType;
  const ProfileSkinTypeSelected(this.skinType);
  @override
  List<Object?> get props => [skinType];
}

class ProfileConcernToggled extends ProfileEvent {
  final String concern;
  const ProfileConcernToggled(this.concern);
  @override
  List<Object?> get props => [concern];
}

class ProfileAgeRangeSelected extends ProfileEvent {
  final String ageRange;
  const ProfileAgeRangeSelected(this.ageRange);
  @override
  List<Object?> get props => [ageRange];
}

class ProfileFitzpatrickSelected extends ProfileEvent {
  final int scale;
  const ProfileFitzpatrickSelected(this.scale);
  @override
  List<Object?> get props => [scale];
}

class ProfileClimateSelected extends ProfileEvent {
  final String climate;
  const ProfileClimateSelected(this.climate);
  @override
  List<Object?> get props => [climate];
}

class ProfileAllergiesUpdated extends ProfileEvent {
  final List<String> allergies;
  const ProfileAllergiesUpdated(this.allergies);
  @override
  List<Object?> get props => [allergies];
}

class ProfileGoalToggled extends ProfileEvent {
  final String goal;
  const ProfileGoalToggled(this.goal);
  @override
  List<Object?> get props => [goal];
}

class ProfileSaveRequested extends ProfileEvent {}
