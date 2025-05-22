// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
  id: (json['id'] as num?)?.toInt(),
  checkInDate: json['checkInDate'] as String,
  checkOutDate: json['checkOutDate'] as String,
  status: json['status'] as String?,
  totalPrice: (json['totalPrice'] as num?)?.toDouble(),
  userId: (json['userId'] as num).toInt(),
  apartmentId: (json['apartmentId'] as num).toInt(),
);

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'checkInDate': instance.checkInDate,
      'checkOutDate': instance.checkOutDate,
      if (instance.status case final value?) 'status': value,
      if (instance.totalPrice case final value?) 'totalPrice': value,
      'userId': instance.userId,
      'apartmentId': instance.apartmentId,
    };
