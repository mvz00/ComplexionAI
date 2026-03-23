import 'package:equatable/equatable.dart';

class Checkin extends Equatable {
  final String id;
  final String userId;
  final DateTime checkinDate;
  final String? skinFeeling;
  final String? notes;
  final String? photoPath;
  final bool routineCompleted;
  final String? routineId;
  final List<String> stepsCompleted;
  final double? sleepHours;
  final double? waterIntakeLitres;
  final int? stressLevel;
  final String? aiDailyTip;

  const Checkin({
    required this.id,
    required this.userId,
    required this.checkinDate,
    this.skinFeeling,
    this.notes,
    this.photoPath,
    this.routineCompleted = false,
    this.routineId,
    this.stepsCompleted = const [],
    this.sleepHours,
    this.waterIntakeLitres,
    this.stressLevel,
    this.aiDailyTip,
  });

  @override
  List<Object?> get props => [id, userId, checkinDate];
}
