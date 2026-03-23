import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/routine_model.dart';

class RoutineRemoteDataSource {
  final SupabaseClient _supabase;
  RoutineRemoteDataSource(this._supabase);

  Future<List<RoutineModel>> getRoutines(String userId) async {
    final data = await _supabase
        .from('routines')
        .select('*, routine_steps(*, product:products(*))')
        .eq('user_id', userId)
        .eq('is_active', true)
        .order('created_at', ascending: false);
    return (data as List).map((e) => RoutineModel.fromJson(e)).toList();
  }

  Future<RoutineModel> generateRoutine(String userId, String analysisId) async {
    final response = await _supabase.functions.invoke('generate-routine', body: {
      'user_id': userId,
      'analysis_id': analysisId,
    });
    return RoutineModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> toggleStepCompletion(String stepId, bool completed) async {
    // Step completion is tracked client-side per session or via daily_checkins
  }
}
