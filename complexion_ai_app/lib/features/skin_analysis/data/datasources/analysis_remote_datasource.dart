import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/analysis_result_model.dart';

class AnalysisRemoteDataSource {
  final SupabaseClient _supabase;
  AnalysisRemoteDataSource(this._supabase);

  /// Uploads image bytes directly (web-compatible — no dart:io File).
  Future<AnalysisResultModel> analyseImage(
    Uint8List imageBytes,
    String userId,
  ) async {
    // Upload image bytes to storage
    final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await _supabase.storage
        .from('skin-images')
        .uploadBinary(
          fileName,
          imageBytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );

    // Call edge function
    final response = await _supabase.functions.invoke('analyse-skin', body: {
      'image_path': fileName,
      'user_id': userId,
    });

    return AnalysisResultModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<AnalysisResultModel>> getAnalysisHistory(String userId) async {
    final data = await _supabase
        .from('skin_analyses')
        .select()
        .eq('user_id', userId)
        .order('analysed_at', ascending: false);
    return (data as List)
        .map((e) => AnalysisResultModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AnalysisResultModel?> getLatestAnalysis(String userId) async {
    final data = await _supabase
        .from('skin_analyses')
        .select()
        .eq('user_id', userId)
        .order('analysed_at', ascending: false)
        .limit(1)
        .maybeSingle();
    if (data == null) return null;
    return AnalysisResultModel.fromJson(data);
  }
}
