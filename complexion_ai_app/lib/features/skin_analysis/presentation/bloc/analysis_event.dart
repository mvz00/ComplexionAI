import 'package:equatable/equatable.dart';

abstract class AnalysisEvent extends Equatable {
  const AnalysisEvent();
  @override
  List<Object?> get props => [];
}

class AnalysisCaptureRequested extends AnalysisEvent {
  final String imagePath;
  final String userId;
  const AnalysisCaptureRequested({required this.imagePath, required this.userId});
  @override
  List<Object?> get props => [imagePath, userId];
}

class AnalysisHistoryRequested extends AnalysisEvent {
  final String userId;
  const AnalysisHistoryRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}
