import 'package:equatable/equatable.dart';

class CheckinState extends Equatable {
  final String? skinFeeling;
  final bool routineCompleted;
  final double sleepHours;
  final double waterLitres;
  final int stressLevel;
  final String notes;
  final bool isSubmitting;
  final bool isSubmitted;
  final String? aiTip;
  final String? error;

  const CheckinState({
    this.skinFeeling,
    this.routineCompleted = false,
    this.sleepHours = 7.0,
    this.waterLitres = 2.0,
    this.stressLevel = 3,
    this.notes = '',
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.aiTip,
    this.error,
  });

  CheckinState copyWith({
    String? skinFeeling,
    bool? routineCompleted,
    double? sleepHours,
    double? waterLitres,
    int? stressLevel,
    String? notes,
    bool? isSubmitting,
    bool? isSubmitted,
    String? aiTip,
    String? error,
  }) {
    return CheckinState(
      skinFeeling: skinFeeling ?? this.skinFeeling,
      routineCompleted: routineCompleted ?? this.routineCompleted,
      sleepHours: sleepHours ?? this.sleepHours,
      waterLitres: waterLitres ?? this.waterLitres,
      stressLevel: stressLevel ?? this.stressLevel,
      notes: notes ?? this.notes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      aiTip: aiTip ?? this.aiTip,
      error: error,
    );
  }

  @override
  List<Object?> get props => [skinFeeling, routineCompleted, sleepHours, waterLitres, stressLevel, notes, isSubmitting, isSubmitted, aiTip, error];
}
