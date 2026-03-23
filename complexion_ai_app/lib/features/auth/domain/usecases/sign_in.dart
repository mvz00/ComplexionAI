import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignIn {
  final AuthRepository _repository;

  SignIn(this._repository);

  Future<AppUser> callWithEmail(String email, String password) {
    return _repository.signInWithEmail(email, password);
  }

  Future<AppUser> callWithGoogle() {
    return _repository.signInWithGoogle();
  }

  Future<AppUser> callWithApple() {
    return _repository.signInWithApple();
  }
}
