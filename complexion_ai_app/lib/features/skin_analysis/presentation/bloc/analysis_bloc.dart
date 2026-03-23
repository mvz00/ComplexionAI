import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/capture_and_analyse.dart';
import '../../domain/usecases/get_analysis_history.dart';
import 'analysis_event.dart';
import 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final CaptureAndAnalyse _captureAndAnalyse;
  final GetAnalysisHistory _getAnalysisHistory;

  AnalysisBloc({
    required CaptureAndAnalyse captureAndAnalyse,
    required GetAnalysisHistory getAnalysisHistory,
  })  : _captureAndAnalyse = captureAndAnalyse,
        _getAnalysisHistory = getAnalysisHistory,
        super(AnalysisInitial()) {
    on<AnalysisCaptureRequested>(_onCapture);
    on<AnalysisHistoryRequested>(_onHistory);
  }

  Future<void> _onCapture(
    AnalysisCaptureRequested event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(AnalysisProcessing());
    try {
      final result = await _captureAndAnalyse(event.imageBytes, event.userId);
      emit(AnalysisComplete(result));
    } catch (e) {
      emit(AnalysisError(e.toString()));
    }
  }

  Future<void> _onHistory(
    AnalysisHistoryRequested event,
    Emitter<AnalysisState> emit,
  ) async {
    try {
      final results = await _getAnalysisHistory(event.userId);
      emit(AnalysisHistoryLoaded(results));
    } catch (e) {
      emit(AnalysisError(e.toString()));
    }
  }
}
