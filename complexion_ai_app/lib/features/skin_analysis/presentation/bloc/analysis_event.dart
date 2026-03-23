import 'dart:typed_data';
import 'package:equatable/equatable.dart';

abstract class AnalysisEvent extends Equatable {
  const AnalysisEvent();
  @override
  List<Object?> get props => [];
}

class AnalysisCaptureRequested extends AnalysisEvent {
  final Uint8List imageBytes;
  final String userId;
  const AnalysisCaptureRequested({required this.imageBytes, required this.userId});
  @override
  List<Object?> get props => [imageBytes, userId];
}

class AnalysisHistoryRequested extends AnalysisEvent {
  final String userId;
  const AnalysisHistoryRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}
