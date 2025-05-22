import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_hotel_app/managers/auth_service.dart';
import 'package:smart_hotel_app/managers/backend_service.dart';
import 'package:smart_hotel_app/src/data/models/reservation/reservation.dart';
import 'package:smart_hotel_app/src/data/models/user/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<Login>((event, emit) async {
      try {
        emit(AuthInProgress());
        final backendService = BackendService();
        final authService = AuthService();

        // Prepare data
        final user = User(email: event.email, password: event.password);

        final tokens = await backendService.login(user);

        authService.signInWithUser(
          user,
          tokens['accessToken']!,
          tokens['refreshToken']!,
        );

        final reservation = await backendService.checkReservation();

        emit(AuthSuccess(reservation: reservation));
      } catch (e) {
        log('Error while logging in: $e');
        emit(AuthFailed(message: e.toString()));
      }
    });

    on<Register>((event, emit) async {
      try {
        emit(AuthInProgress());
        final backendService = BackendService();
        final authService = AuthService();

        // Prepare data
        final user = User(
          email: event.email,
          password: event.password,
          firstName: event.firstName,
          lastName: event.lastName,
          role: 'user',
        );

        await backendService.register(user);
        final tokens = await backendService.login(user);

        authService.signInWithUser(
          user,
          tokens['accessToken']!,
          tokens['refreshToken']!,
        );

        final reservation = await backendService.checkReservation();

        emit(AuthSuccess(reservation: reservation));
      } catch (e) {
        log('Error while logging in: $e');
        emit(AuthFailed(message: e.toString()));
      }
    });
  }
}
