part of 'auth_bloc.dart';

sealed class AuthEvent {}

class Login extends AuthEvent {
  final String email;
  final String password;

  Login({required this.email, required this.password});
}

class Register extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  Register({
    required this.firstName,
    required this.password,
    required this.lastName,
    required this.email,
  });
}
