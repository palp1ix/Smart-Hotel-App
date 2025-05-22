// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i11;
import 'package:smart_hotel_app/src/data/models/reservation/reservation.dart'
    as _i13;
import 'package:smart_hotel_app/src/data/models/user/user.dart' as _i12;
import 'package:smart_hotel_app/src/presentation/auth/login_screen.dart' as _i4;
import 'package:smart_hotel_app/src/presentation/auth/registration_screen.dart'
    as _i7;
import 'package:smart_hotel_app/src/presentation/home/home.dart' as _i2;
import 'package:smart_hotel_app/src/presentation/loading_screen/loading_screen.dart'
    as _i3;
import 'package:smart_hotel_app/src/presentation/main/main_screen.dart' as _i5;
import 'package:smart_hotel_app/src/presentation/manager/manager.dart' as _i6;
import 'package:smart_hotel_app/src/presentation/reservation/details.dart'
    as _i8;
import 'package:smart_hotel_app/src/presentation/reservation/reservation.dart'
    as _i1;
import 'package:smart_hotel_app/src/presentation/restaurant/restaurant.dart'
    as _i9;

/// generated route for
/// [_i1.CombinedReservationScreen]
class CombinedReservationRoute extends _i10.PageRouteInfo<void> {
  const CombinedReservationRoute({List<_i10.PageRouteInfo>? children})
    : super(CombinedReservationRoute.name, initialChildren: children);

  static const String name = 'CombinedReservationRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i1.CombinedReservationScreen();
    },
  );
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i10.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    _i11.Key? key,
    _i12.User? user,
    _i13.Reservation? reservation,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         HomeRoute.name,
         args: HomeRouteArgs(key: key, user: user, reservation: reservation),
         initialChildren: children,
       );

  static const String name = 'HomeRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeRouteArgs>(
        orElse: () => const HomeRouteArgs(),
      );
      return _i2.HomeScreen(
        key: args.key,
        user: args.user,
        reservation: args.reservation,
      );
    },
  );
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key, this.user, this.reservation});

  final _i11.Key? key;

  final _i12.User? user;

  final _i13.Reservation? reservation;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key, user: $user, reservation: $reservation}';
  }
}

/// generated route for
/// [_i3.LoadingScreen]
class LoadingRoute extends _i10.PageRouteInfo<void> {
  const LoadingRoute({List<_i10.PageRouteInfo>? children})
    : super(LoadingRoute.name, initialChildren: children);

  static const String name = 'LoadingRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoadingScreen();
    },
  );
}

/// generated route for
/// [_i4.LoginScreen]
class LoginRoute extends _i10.PageRouteInfo<void> {
  const LoginRoute({List<_i10.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i4.LoginScreen();
    },
  );
}

/// generated route for
/// [_i5.MainScreen]
class MainRoute extends _i10.PageRouteInfo<void> {
  const MainRoute({List<_i10.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i5.MainScreen();
    },
  );
}

/// generated route for
/// [_i6.ManagerScreen]
class ManagerRoute extends _i10.PageRouteInfo<void> {
  const ManagerRoute({List<_i10.PageRouteInfo>? children})
    : super(ManagerRoute.name, initialChildren: children);

  static const String name = 'ManagerRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i6.ManagerScreen();
    },
  );
}

/// generated route for
/// [_i7.RegistrationScreen]
class RegistrationRoute extends _i10.PageRouteInfo<void> {
  const RegistrationRoute({List<_i10.PageRouteInfo>? children})
    : super(RegistrationRoute.name, initialChildren: children);

  static const String name = 'RegistrationRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i7.RegistrationScreen();
    },
  );
}

/// generated route for
/// [_i8.ReservationDetailsScreen]
class ReservationDetailsRoute extends _i10.PageRouteInfo<void> {
  const ReservationDetailsRoute({List<_i10.PageRouteInfo>? children})
    : super(ReservationDetailsRoute.name, initialChildren: children);

  static const String name = 'ReservationDetailsRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i8.ReservationDetailsScreen();
    },
  );
}

/// generated route for
/// [_i9.RestaurantScreen]
class RestaurantRoute extends _i10.PageRouteInfo<void> {
  const RestaurantRoute({List<_i10.PageRouteInfo>? children})
    : super(RestaurantRoute.name, initialChildren: children);

  static const String name = 'RestaurantRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i9.RestaurantScreen();
    },
  );
}
