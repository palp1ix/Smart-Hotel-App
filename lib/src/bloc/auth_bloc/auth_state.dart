part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthFailed extends AuthState {
  final String message;

  AuthFailed({required this.message});
}

class AuthInProgress extends AuthState {}

class AuthSuccess extends AuthState {
  AuthSuccess({this.reservation});
  final Reservation? reservation;
}
