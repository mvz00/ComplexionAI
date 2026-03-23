import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/skin_profile_model.dart';

class ProfileRemoteDataSource {
  final SupabaseClient _supabase;

  ProfileRemoteDataSource(this._supabase);

  Future<SkinProfileModel?> getSkinProfile(String userId) async {
    final data = await _supabase
        .from('skin_profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (data == null) return null;
    return SkinProfileModel.fromJson(data);
  }

  Future<SkinProfileModel> createSkinProfile(Map<String, dynamic> profileData) async {
    final data = await _supabase
        .from('skin_profiles')
        .insert(profileData)
        .select()
        .single();
    return SkinProfileModel.fromJson(data);
  }

  Future<SkinProfileModel> updateSkinProfile(String id, Map<String, dynamic> profileData) async {
    final data = await _supabase
        .from('skin_profiles')
        .update(profileData)
        .eq('id', id)
        .select()
        .single();
    return SkinProfileModel.fromJson(data);
  }
}
