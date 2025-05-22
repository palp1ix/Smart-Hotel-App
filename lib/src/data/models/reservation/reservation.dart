import 'package:json_annotation/json_annotation.dart';

part 'reservation.g.dart';

@JsonSerializable(includeIfNull: false)
class Reservation {
  final int? id;
  final String checkInDate;
  final String checkOutDate;
  final String? status;
  final double? totalPrice;
  final int userId;
  final int apartmentId;

  Reservation({
    this.id,
    required this.checkInDate,
    required this.checkOutDate,
    this.status,
    this.totalPrice,
    required this.userId,
    required this.apartmentId,
  });
  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
