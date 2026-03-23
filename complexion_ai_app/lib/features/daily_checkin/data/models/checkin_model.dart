import '../../domain/entities/checkin.dart';

class CheckinModel extends Checkin {
  const CheckinModel({
    required super.id,
    required super.userId,
    required super.checkinDate,
    super.skinFeeling,
    super.notes,
    super.photoPath,
    super.routineCompleted,
    super.routineId,
    super.stepsCompleted,
    super.sleepHours,
    super.waterIntakeLitres,
    super.stressLevel,
    super.aiDailyTip,
  });

  factory CheckinModel.fromJson(Map<String, dynamic> json) {
    return CheckinModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      checkinDate: DateTime.parse(json['checkin_date'] as String),
      skinFeeling: json['skin_feeling'] as String?,
      notes: json['notes'] as String?,
      photoPath: json['photo_path'] as String?,
      routineCompleted: (json['routine_completed'] as bool?) ?? false,
      routineId: json['routine_id'] as String?,
      stepsCompleted: (json['steps_completed'] as List<dynamic>?)?.cast<String>() ?? [],
      sleepHours: (json['sleep_hours'] as num?)?.toDouble(),
      waterIntakeLitres: (json['water_intake_litres'] as num?)?.toDouble(),
      stressLevel: json['stress_level'] as int?,
      aiDailyTip: json['ai_daily_tip'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'checkin_date': checkinDate.toIso8601String().split('T').first,
      'skin_feeling': skinFeeling,
      'notes': notes,
      'photo_path': photoPath,
      'routine_completed': routineCompleted,
      'routine_id': routineId,
      'steps_completed': stepsCompleted,
      'sleep_hours': sleepHours,
      'water_intake_litres': waterIntakeLitres,
      'stress_level': stressLevel,
    };
  }
}
