import 'dart:async';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<AppUser?> get authStateChanges {
    return _remoteDataSource.authStateChanges.asyncMap((state) async {
      if (state.session != null) {
        return await _remoteDataSource.getCurrentUser();
      }
      return null;
    });
  }

  @override
  Future<AppUser?> get currentUser => _remoteDataSource.getCurrentUser();

  @override
  Future<AppUser> signInWithEmail(String email, String password) {
    return _remoteDataSource.signInWithEmail(email, password);
  }

  @override
  Future<AppUser> signUpWithEmail(String email, String password) {
    return _remoteDataSource.signUpWithEmail(email, password);
  }

  @override
  Future<AppUser> signInWithGoogle() {
    return _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<AppUser> signInWithApple() {
    return _remoteDataSource.signInWithApple();
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }

  @override
  Future<void> resetPassword(String email) {
    return _remoteDataSource.resetPassword(email);
  }
}
