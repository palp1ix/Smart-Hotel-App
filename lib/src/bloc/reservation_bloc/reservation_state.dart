part of 'reservation_bloc.dart';

sealed class ReservationState {}

final class ReservationInitial extends ReservationState {}

class ReservationInProgress extends ReservationState {}

class ReservationSuccess extends ReservationState {
  final Reservation reservation;

  ReservationSuccess({required this.reservation});
}

class ReservationFailure extends ReservationState {
  final String message;

  ReservationFailure({required this.message});
}
