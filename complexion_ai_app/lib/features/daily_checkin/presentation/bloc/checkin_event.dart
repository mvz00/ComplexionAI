import 'package:equatable/equatable.dart';

abstract class CheckinEvent extends Equatable {
  const CheckinEvent();
  @override
  List<Object?> get props => [];
}

class CheckinFeelingSelected extends CheckinEvent {
  final String feeling;
  const CheckinFeelingSelected(this.feeling);
  @override
  List<Object?> get props => [feeling];
}

class CheckinRoutineCompletedToggled extends CheckinEvent {}

class CheckinSleepChanged extends CheckinEvent {
  final double hours;
  const CheckinSleepChanged(this.hours);
  @override
  List<Object?> get props => [hours];
}

class CheckinWaterChanged extends CheckinEvent {
  final double litres;
  const CheckinWaterChanged(this.litres);
  @override
  List<Object?> get props => [litres];
}

class CheckinStressChanged extends CheckinEvent {
  final int level;
  const CheckinStressChanged(this.level);
  @override
  List<Object?> get props => [level];
}

class CheckinNotesChanged extends CheckinEvent {
  final String notes;
  const CheckinNotesChanged(this.notes);
  @override
  List<Object?> get props => [notes];
}

class CheckinSubmitRequested extends CheckinEvent {}
