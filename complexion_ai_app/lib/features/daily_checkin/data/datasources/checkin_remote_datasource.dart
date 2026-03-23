import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/checkin_model.dart';

class CheckinRemoteDataSource {
  final SupabaseClient _supabase;
  CheckinRemoteDataSource(this._supabase);

  Future<CheckinModel> submitCheckin(Map<String, dynamic> data) async {
    // Use upsert on (user_id, checkin_date) to handle same-day re-submissions.
    // The id is not included in data so Supabase will generate it on insert,
    // and update existing fields on conflict with the unique constraint.
    final result = await _supabase
        .from('daily_checkins')
        .upsert(data, onConflict: 'user_id,checkin_date')
        .select()
        .single();
    return CheckinModel.fromJson(result);
  }

  Future<List<CheckinModel>> getCheckins(String userId, {int limit = 30}) async {
    final data = await _supabase
        .from('daily_checkins')
        .select()
        .eq('user_id', userId)
        .order('checkin_date', ascending: false)
        .limit(limit);
    return (data as List).map((e) => CheckinModel.fromJson(e)).toList();
  }

  Future<int> getStreakCount(String userId) async {
    final data = await _supabase
        .from('daily_checkins')
        .select('checkin_date')
        .eq('user_id', userId)
        .order('checkin_date', ascending: false)
        .limit(60);
    if ((data as List).isEmpty) return 0;
    int streak = 1;
    for (int i = 1; i < data.length; i++) {
      final current = DateTime.parse(data[i - 1]['checkin_date'] as String);
      final prev = DateTime.parse(data[i]['checkin_date'] as String);
      if (current.difference(prev).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}
