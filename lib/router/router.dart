import 'package:auto_route/auto_route.dart';
import 'package:smart_hotel_app/router/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: RegistrationRoute.page, path: '/'),
    AutoRoute(page: LoginRoute.page, path: '/login'),
  ];
}
