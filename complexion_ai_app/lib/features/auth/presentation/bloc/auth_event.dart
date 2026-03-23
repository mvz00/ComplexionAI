import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthSignInWithEmail extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInWithEmail({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpWithEmail extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUpWithEmail({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignInWithGoogle extends AuthEvent {}

class AuthSignInWithApple extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

class AuthResetPassword extends AuthEvent {
  final String email;

  const AuthResetPassword({required this.email});

  @override
  List<Object?> get props => [email];
}
