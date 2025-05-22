import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_hotel_app/managers/auth_service.dart';
import 'package:smart_hotel_app/managers/backend_service.dart';
import 'package:smart_hotel_app/src/data/models/reservation/reservation.dart';
import 'package:smart_hotel_app/src/presentation/reservation/reservation.dart';

part 'reservation_event.dart';
part 'reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  ReservationBloc() : super(ReservationInitial()) {
    on<CreateReservationEvent>((event, emit) async {
      emit(ReservationInProgress());
      try {
        final checkInDate = event.checkInDate.toIso8601String();
        final checkOutDate = event.checkOutDate.toIso8601String();
        final userId = await AuthService().userId;
        final backendService = BackendService();
        final reservation = Reservation(
          checkInDate: checkInDate,
          checkOutDate: checkOutDate,
          userId: userId,
          apartmentId: 1,
        );
        final result = await backendService.reserveApartment(reservation);
        emit(ReservationSuccess(reservation: result));
      } catch (e) {
        emit(ReservationFailure(message: e.toString()));
      }
    });
  }
}
