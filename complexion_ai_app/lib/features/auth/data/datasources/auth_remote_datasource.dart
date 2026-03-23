import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final SupabaseClient _supabase;

  AuthRemoteDataSource(this._supabase) {
    debugPrint('[Auth] DataSource created. Supabase URL: ${_supabase.supabaseUrl}');
  }

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Session? get currentSession => _supabase.auth.currentSession;

  Future<UserModel?> getCurrentUser() async {
    final authUser = _supabase.auth.currentUser;
    debugPrint('[Auth] getCurrentUser → ${authUser?.id ?? 'null'}');
    if (authUser == null) return null;
    return _buildUserModelFromAuthUser(authUser);
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    debugPrint('[Auth] signInWithEmail → $email');
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      debugPrint('[Auth] signIn response user: ${response.user?.id}');
      final user = response.user;
      if (user == null) throw Exception('Sign-in failed: no user returned');
      return _buildUserModelFromAuthUser(user);
    } catch (e) {
      debugPrint('[Auth] signInWithEmail ERROR: $e');
      rethrow;
    }
  }

  Future<UserModel> signUpWithEmail(String email, String password) async {
    debugPrint('[Auth] signUpWithEmail → $email');
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      debugPrint('[Auth] signUp response user: ${response.user?.id}, session: ${response.session?.accessToken != null}');
      final user = response.user;
      if (user == null) throw Exception('Sign-up failed: no user returned');
      return _buildUserModelFromAuthUser(user);
    } catch (e) {
      debugPrint('[Auth] signUpWithEmail ERROR: $e');
      rethrow;
    }
  }

  Future<UserModel> signInWithGoogle() async {
    await _supabase.auth.signInWithOAuth(OAuthProvider.google);
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Google sign-in failed');
    return _buildUserModelFromAuthUser(user);
  }

  Future<UserModel> signInWithApple() async {
    await _supabase.auth.signInWithOAuth(OAuthProvider.apple);
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Apple sign-in failed');
    return _buildUserModelFromAuthUser(user);
  }

  Future<void> signOut() async {
    debugPrint('[Auth] signOut');
    await _supabase.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  UserModel _buildUserModelFromAuthUser(User user) {
    debugPrint('[Auth] Building UserModel for id=${user.id} email=${user.email}');
    final meta = user.userMetadata ?? {};
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      displayName: meta['display_name'] as String? ??
          meta['full_name'] as String? ??
          meta['name'] as String?,
      avatarUrl: meta['avatar_url'] as String?,
      subscriptionTier: 'free',
      subscriptionExpiresAt: null,
      createdAt: DateTime.parse(user.createdAt),
    );
  }
}
