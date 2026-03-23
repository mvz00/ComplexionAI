import 'package:equatable/equatable.dart';
import '../../domain/entities/analysis_result.dart';

abstract class AnalysisState extends Equatable {
  const AnalysisState();
  @override
  List<Object?> get props => [];
}

class AnalysisInitial extends AnalysisState {}
class AnalysisCapturing extends AnalysisState {}
class AnalysisProcessing extends AnalysisState {}

class AnalysisComplete extends AnalysisState {
  final AnalysisResult result;
  const AnalysisComplete(this.result);
  @override
  List<Object?> get props => [result];
}

class AnalysisHistoryLoaded extends AnalysisState {
  final List<AnalysisResult> results;
  const AnalysisHistoryLoaded(this.results);
  @override
  List<Object?> get props => [results];
}

class AnalysisError extends AnalysisState {
  final String message;
  const AnalysisError(this.message);
  @override
  List<Object?> get props => [message];
}
