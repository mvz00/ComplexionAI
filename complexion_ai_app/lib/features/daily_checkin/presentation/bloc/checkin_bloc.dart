import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkin_event.dart';
import 'checkin_state.dart';

class CheckinBloc extends Bloc<CheckinEvent, CheckinState> {
  CheckinBloc() : super(const CheckinState()) {
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

  Future<void> _onSubmit(CheckinSubmitRequested event, Emitter<CheckinState> emit) async {
    emit(state.copyWith(isSubmitting: true));
    // TODO: Wire up repository
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(
      isSubmitting: false,
      isSubmitted: true,
      aiTip: 'Your hydration improved 8% this week — keep using the HA serum in your PM routine. Consider adding a weekly exfoliant for texture.',
    ));
  }
}
