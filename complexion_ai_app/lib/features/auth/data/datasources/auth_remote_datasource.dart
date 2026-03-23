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
    return _buildUserModelFromAuthUser(authUser);
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) throw Exception('Sign-in failed: no user returned');
    return _buildUserModelFromAuthUser(user);
  }

  Future<UserModel> signUpWithEmail(String email, String password) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) throw Exception('Sign-up failed: no user returned');
    return _buildUserModelFromAuthUser(user);
  }

  Future<UserModel> signInWithGoogle() async {
    await _supabase.auth.signInWithOAuth(OAuthProvider.google);
    // After OAuth redirect, user will be available
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
    await _supabase.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  /// Builds a [UserModel] directly from the Supabase auth [User] object,
  /// without querying the `users` table (which may not have a row yet for
  /// newly-signed-up users). Optionally enriches with profile data if available.
  UserModel _buildUserModelFromAuthUser(User user) {
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
