part of 'reservation_bloc.dart';

sealed class ReservationEvent {}

class CreateReservationEvent extends ReservationEvent {
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final RoomType roomType;

  CreateReservationEvent({
    required this.checkInDate,
    required this.checkOutDate,
    required this.roomType,
  });
}
