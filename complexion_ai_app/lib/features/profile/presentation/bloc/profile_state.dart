import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String? skinType;
  final List<String> selectedConcerns;
  final String? ageRange;
  final int? fitzpatrickScale;
  final String? climate;
  final List<String> allergies;
  final List<String> selectedGoals;
  final bool isLoading;
  final bool isSaved;
  final String? error;

  const ProfileState({
    this.skinType,
    this.selectedConcerns = const [],
    this.ageRange,
    this.fitzpatrickScale,
    this.climate,
    this.allergies = const [],
    this.selectedGoals = const [],
    this.isLoading = false,
    this.isSaved = false,
    this.error,
  });

  ProfileState copyWith({
    String? skinType,
    List<String>? selectedConcerns,
    String? ageRange,
    int? fitzpatrickScale,
    String? climate,
    List<String>? allergies,
    List<String>? selectedGoals,
    bool? isLoading,
    bool? isSaved,
    String? error,
  }) {
    return ProfileState(
      skinType: skinType ?? this.skinType,
      selectedConcerns: selectedConcerns ?? this.selectedConcerns,
      ageRange: ageRange ?? this.ageRange,
      fitzpatrickScale: fitzpatrickScale ?? this.fitzpatrickScale,
      climate: climate ?? this.climate,
      allergies: allergies ?? this.allergies,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      error: error,
    );
  }

  @override
  List<Object?> get props => [skinType, selectedConcerns, ageRange, fitzpatrickScale, climate, allergies, selectedGoals, isLoading, isSaved, error];
}
