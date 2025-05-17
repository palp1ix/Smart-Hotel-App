// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:smart_hotel_app/src/presentation/auth/login_screen.dart' as _i2;
import 'package:smart_hotel_app/src/presentation/auth/registration_screen.dart'
    as _i5;
import 'package:smart_hotel_app/src/presentation/home/home.dart' as _i1;
import 'package:smart_hotel_app/src/presentation/main/main_screen.dart' as _i3;
import 'package:smart_hotel_app/src/presentation/manager/manager.dart' as _i4;
import 'package:smart_hotel_app/src/presentation/restaurant/restaurant.dart'
    as _i6;

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomeScreen();
    },
  );
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i7.PageRouteInfo<void> {
  const LoginRoute({List<_i7.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.LoginScreen();
    },
  );
}

/// generated route for
/// [_i3.MainScreen]
class MainRoute extends _i7.PageRouteInfo<void> {
  const MainRoute({List<_i7.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.MainScreen();
    },
  );
}

/// generated route for
/// [_i4.ManagerScreen]
class ManagerRoute extends _i7.PageRouteInfo<void> {
  const ManagerRoute({List<_i7.PageRouteInfo>? children})
    : super(ManagerRoute.name, initialChildren: children);

  static const String name = 'ManagerRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.ManagerScreen();
    },
  );
}

/// generated route for
/// [_i5.RegistrationScreen]
class RegistrationRoute extends _i7.PageRouteInfo<void> {
  const RegistrationRoute({List<_i7.PageRouteInfo>? children})
    : super(RegistrationRoute.name, initialChildren: children);

  static const String name = 'RegistrationRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.RegistrationScreen();
    },
  );
}

/// generated route for
/// [_i6.RestaurantScreen]
class RestaurantRoute extends _i7.PageRouteInfo<void> {
  const RestaurantRoute({List<_i7.PageRouteInfo>? children})
    : super(RestaurantRoute.name, initialChildren: children);

  static const String name = 'RestaurantRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.RestaurantScreen();
    },
  );
}
