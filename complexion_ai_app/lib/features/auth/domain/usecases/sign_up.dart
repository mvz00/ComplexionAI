import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository _repository;

  SignUp(this._repository);

  Future<AppUser> call(String email, String password) {
    return _repository.signUpWithEmail(email, password);
  }
}
