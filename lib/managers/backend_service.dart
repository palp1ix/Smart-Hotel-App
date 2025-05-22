import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_hotel_app/managers/auth_service.dart';
import 'package:smart_hotel_app/src/data/models/reservation/reservation.dart';
import 'package:smart_hotel_app/src/data/models/user/user.dart';

class BackendService {
  static const String _baseUrl = 'http://10.65.158.107:3000/api';

  final dio = GetIt.I<Dio>();

  Future<Map<String, String>> login(User user) async {
    try {
      final response = await dio.post(
        '$_baseUrl/auth/login',
        data: user.toJson(),
      );
      final accessToken = response.data['accessToken'] as String;
      final refreshToken = response.data['refreshToken'] as String;
      log(accessToken);
      final output = {'accessToken': accessToken, 'refreshToken': refreshToken};
      return output;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> register(User user) async {
    try {
      await dio.post('$_baseUrl/auth/register', data: user.toJson());
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to login: $e');
    }
  }

  Future<Reservation?> checkReservation() async {
    try {
      final response = await dio.get('$_baseUrl/reservations/current');
      if (response.data.isEmpty) {
        return null;
      } else {
        final reservation = Reservation.fromJson(response.data);
        return reservation;
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed chekc reservation: $e');
    }
  }

  Future<Reservation> reserveApartment(Reservation reservation) async {
    try {
      log(reservation.toJson().toString());
      final response = await dio.post(
        '$_baseUrl/reservations',
        data: reservation.toJson(),
      );
      log(response.data.toString());
      return Reservation.fromJson(response.data);
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to reserve: $e');
    }
  }

  Future<String?> generateLink() async {
    try {
      final authService = AuthService();
      final data = {
        'userId': await authService.userId,
        'deviceId': 1,
        'status': 'DoorLockOpen',
        'useLimit': 10,
      };
      final response = await dio.post('$_baseUrl/share', data: data);
      log(response.data.toString());
      final link = response.data['link'] as String;
      final changedLink = link.replaceFirst(
        'localhost:3000',
        '10.65.158.107:3000',
      );
      return changedLink;
    } catch (e) {
      log(e.toString());
    }
  }
}
