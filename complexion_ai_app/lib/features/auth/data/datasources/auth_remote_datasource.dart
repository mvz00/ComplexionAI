import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final SupabaseClient _supabase;

  AuthRemoteDataSource(this._supabase);

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Session? get currentSession => _supabase.auth.currentSession;

  Future<UserModel?> getCurrentUser() async {
    final authUser = _supabase.auth.currentUser;
    if (authUser == null) return null;
    return _fetchUserProfile(authUser.id);
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return _fetchUserProfile(response.user!.id);
  }

  Future<UserModel> signUpWithEmail(String email, String password) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    return _fetchUserProfile(response.user!.id);
  }

  Future<UserModel> signInWithGoogle() async {
    await _supabase.auth.signInWithOAuth(OAuthProvider.google);
    // After OAuth redirect, user will be available
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Google sign-in failed');
    return _fetchUserProfile(user.id);
  }

  Future<UserModel> signInWithApple() async {
    await _supabase.auth.signInWithOAuth(OAuthProvider.apple);
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Apple sign-in failed');
    return _fetchUserProfile(user.id);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  Future<UserModel> _fetchUserProfile(String userId) async {
    final data = await _supabase
        .from('users')
        .select()
        .eq('id', userId)
        .single();
    return UserModel.fromJson(data);
  }
}
