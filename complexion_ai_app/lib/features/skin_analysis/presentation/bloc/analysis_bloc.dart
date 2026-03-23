import 'package:flutter_bloc/flutter_bloc.dart';
import 'analysis_event.dart';
import 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  AnalysisBloc() : super(AnalysisInitial()) {
    on<AnalysisCaptureRequested>(_onCapture);
    on<AnalysisHistoryRequested>(_onHistory);
  }

  Future<void> _onCapture(AnalysisCaptureRequested event, Emitter<AnalysisState> emit) async {
    emit(AnalysisProcessing());
    // TODO: Wire up repository
    await Future.delayed(const Duration(seconds: 2));
    emit(AnalysisInitial()); // placeholder
  }

  Future<void> _onHistory(AnalysisHistoryRequested event, Emitter<AnalysisState> emit) async {
    // TODO: Wire up repository
  }
}
