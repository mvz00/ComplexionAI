import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/checkin.dart';
import '../../domain/usecases/submit_checkin.dart';
import '../../domain/usecases/get_checkin_streak.dart';
import '../../domain/repositories/checkin_repository.dart';
import 'checkin_event.dart';
import 'checkin_state.dart';

class CheckinBloc extends Bloc<CheckinEvent, CheckinState> {
  final SubmitCheckin _submitCheckin;
  final GetCheckinStreak _getCheckinStreak;
  final CheckinRepository _checkinRepository;

  CheckinBloc({
    required SubmitCheckin submitCheckin,
    required GetCheckinStreak getCheckinStreak,
    required CheckinRepository checkinRepository,
  })  : _submitCheckin = submitCheckin,
        _getCheckinStreak = getCheckinStreak,
        _checkinRepository = checkinRepository,
        super(const CheckinState()) {
    on<CheckinLoadRequested>(_onLoad);
    on<CheckinFeelingSelected>((event, emit) {
      emit(state.copyWith(skinFeeling: event.feeling));
    });
    on<CheckinRoutineCompletedToggled>((event, emit) {
      emit(state.copyWith(routineCompleted: !state.routineCompleted));
    });
    on<CheckinSleepChanged>((event, emit) {
      emit(state.copyWith(sleepHours: event.hours));
    });
    on<CheckinWaterChanged>((event, emit) {
      emit(state.copyWith(waterLitres: event.litres));
    });
    on<CheckinStressChanged>((event, emit) {
      emit(state.copyWith(stressLevel: event.level));
    });
    on<CheckinNotesChanged>((event, emit) {
      emit(state.copyWith(notes: event.notes));
    });
    on<CheckinSubmitRequested>(_onSubmit);
  }

  Future<void> _onLoad(CheckinLoadRequested event, Emitter<CheckinState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final streakFuture = _getCheckinStreak(event.userId);
      final historyFuture = _checkinRepository.getCheckins(event.userId);
      final streak = await streakFuture;
      final history = await historyFuture;
      emit(state.copyWith(isLoading: false, streak: streak, history: history));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onSubmit(CheckinSubmitRequested event, Emitter<CheckinState> emit) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      emit(state.copyWith(error: 'Not authenticated'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      final checkin = Checkin(
        id: '',
        userId: userId,
        checkinDate: DateTime.now(),
        skinFeeling: state.skinFeeling,
        notes: state.notes.isEmpty ? null : state.notes,
        routineCompleted: state.routineCompleted,
        sleepHours: state.sleepHours,
        waterIntakeLitres: state.waterLitres,
        stressLevel: state.stressLevel,
      );
      await _submitCheckin(checkin);
      emit(state.copyWith(isSubmitting: false, isSubmitted: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }
}
