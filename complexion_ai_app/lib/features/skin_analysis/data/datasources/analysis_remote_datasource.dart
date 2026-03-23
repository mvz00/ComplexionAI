import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/analysis_result_model.dart';

class AnalysisRemoteDataSource {
  final SupabaseClient _supabase;
  AnalysisRemoteDataSource(this._supabase);

  Future<AnalysisResultModel> analyseImage(String imagePath, String userId) async {
    // Upload image to storage
    final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(imagePath);
    await _supabase.storage
        .from('skin-images')
        .upload(fileName, file,
            fileOptions: const FileOptions(contentType: 'image/jpeg'));

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
